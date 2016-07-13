import CLibvenice

public final class TCPConnection : Connection {
    public var ip: IP
    var socket: tcpsock?
    public private(set) var closed = true

    internal init(with socket: tcpsock) throws {
        let address = tcpaddr(socket)
        try ensureLastOperationSucceeded()
        self.ip = IP(address: address)
        self.socket = socket
        self.closed = false
    }

    public init(host: String, port: Int, timingOut deadline: Double = .never) throws {
        self.ip = try IP(remoteAddress: host, port: port, deadline: deadline)
    }

    public func open(timingOut deadline: Double) throws {
        self.socket = tcpconnect(ip.address, deadline.int64milliseconds)
        try ensureLastOperationSucceeded()
        self.closed = false
    }

    public func send(_ data: Data, timingOut deadline: Double) throws {
        try send(data, flushing: true, timingOut: deadline)
    }

    public func send(_ data: Data, flushing flush: Bool, timingOut deadline: Double) throws {
        let socket = try getSocket()
        try ensureStreamIsOpen()

        let sent = data.withUnsafeBufferPointer {
            tcpsend(socket, $0.baseAddress, $0.count, deadline.int64milliseconds)
        }

        if sent == 0 {
            try ensureLastOperationSucceeded()
        }

        if flush {
            try self.flush()
        }
    }

    public func flush(timingOut deadline: Double) throws {
        let socket = try getSocket()
        try ensureStreamIsOpen()

        tcpflush(socket, deadline.int64milliseconds)
        try ensureLastOperationSucceeded()
    }

    public func receive(upTo byteCount: Int, timingOut deadline: Double = .never) throws -> Data {
        let socket = try getSocket()
        try ensureStreamIsOpen()

        var data = Data.buffer(with: byteCount)
        let received = data.withUnsafeMutableBufferPointer {
            tcprecvlh(socket, $0.baseAddress, 1, $0.count, deadline.int64milliseconds)
        }

        if received == 0 {
            do {
                try ensureLastOperationSucceeded()
            } catch SystemError.connectionResetByPeer {
                closed = true
                throw StreamError.closedStream(data: Data(data.prefix(received)))
            }
        }

        return Data(data.prefix(received))
    }

    public func receive(_ byteCount: Int, timingOut deadline: Double = .never) throws -> Data {
        let socket = try getSocket()
        try ensureStreamIsOpen()

        var data = Data.buffer(with: byteCount)
        let received = data.withUnsafeMutableBufferPointer {
            tcprecv(socket, $0.baseAddress, $0.count, deadline.int64milliseconds)
        }

        if received == 0 {
            try ensureLastOperationSucceeded()
        }

        return Data(data.prefix(received))
    }

    public func close() throws {
        let socket = try getSocket()

        if closed {
            throw ClosableError.alreadyClosed
        }

        tcpclose(socket)
        try ensureLastOperationSucceeded()
        closed = true
    }

    private func getSocket() throws -> tcpsock {
        guard let socket = self.socket else {
            throw SystemError.socketIsNotConnected
        }
        return socket
    }

    private func ensureStreamIsOpen() throws {
        if closed {
            throw StreamError.closedStream(data: [])
        }
    }

    deinit {
        if let socket = socket where !closed {
            tcpclose(socket)
        }
    }
}

extension TCPConnection {
    public func send(_ convertible: DataConvertible, timingOut deadline: Double = .never) throws {
        try send(convertible.data, timingOut: deadline)
    }

    public func receiveString(upTo codeUnitCount: Int, timingOut deadline: Double = .never) throws -> String {
        let result = try receive(upTo: codeUnitCount, timingOut: deadline)
        return try String(data: result)
    }
}
