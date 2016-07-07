final class BodyStream : Stream {
    var closed = false
    let transport: Stream

    init(_ transport: Stream) {
        self.transport = transport
    }

    func close() {
        closed = true
    }

    func receive(upTo byteCount: Int, timingOut deadline: Double = .never) throws -> Data {
        enum Error: ErrorProtocol {
            case receiveUnsupported
        }
        throw Error.receiveUnsupported
    }

    func send(_ data: Data, timingOut deadline: Double = .never) throws {
        if closed {
            throw StreamError.closedStream(data: data)
        }
        let newLine: Data = [13, 10]
        try transport.send(String(data.count, radix: 16).data)
        try transport.send(newLine)
        try transport.send(data)
        try transport.send(newLine)
    }

    func flush(timingOut deadline: Double = .never) throws {
        try transport.flush()
    }
}
