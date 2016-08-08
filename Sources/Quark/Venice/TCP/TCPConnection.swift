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

    public init(host: String, port: Int, deadline: Double = .never) throws {
        self.ip = try IP(remoteAddress: host, port: port, deadline: deadline)
    }

    public func open(deadline: Double) throws {
        self.socket = tcpconnect(ip.address, deadline.int64milliseconds)
        try ensureLastOperationSucceeded()
        self.closed = false
    }

    public func write(_ data: Data, deadline: Double) throws {
        try write(data, flush: true, deadline: deadline)
    }

    public func write(_ data: Data, flush: Bool, deadline: Double) throws {
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

    public func flush(deadline: Double) throws {
        let socket = try getSocket()
        try ensureStreamIsOpen()

        tcpflush(socket, deadline.int64milliseconds)
        try ensureLastOperationSucceeded()
    }

    public func read(upTo byteCount: Int, deadline: Double = .never) throws -> Data {
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

    public func read(_ byteCount: Int, deadline: Double = .never) throws -> Data {
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
        if let socket = socket, !closed {
            tcpclose(socket)
        }
    }
}

extension TCPConnection {
    public func readString(upTo codeUnitCount: Int, deadline: Double = .never) throws -> String {
        let result = try read(upTo: codeUnitCount, deadline: deadline)
        return try String(data: result)
    }
}
