public enum BodyStreamError: Error {
    case receiveUnsupported
}

final class BodyStream : Stream {
    var closed = false
    let transport: Stream

    init(_ transport: Stream) {
        self.transport = transport
    }

    func close() {
        closed = true
    }

    func read(upTo byteCount: Int, deadline: Double = .never) throws -> Data {
        throw BodyStreamError.receiveUnsupported
    }

    func write(_ data: Data, deadline: Double = .never) throws {
        if closed {
            throw StreamError.closedStream(data: data)
        }
        let newLine: Data = [13, 10]
        try transport.write(String(data.count, radix: 16).data)
        try transport.write(newLine)
        try transport.write(data)
        try transport.write(newLine)
    }

    func flush(deadline: Double = .never) throws {
        try transport.flush()
    }
}
