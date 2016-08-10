public final class Drain : DataRepresentable, Stream {
    var buffer: Data
    public var closed = false

    public var data: Data {
        return buffer
    }

    public convenience init() {
        self.init(buffer: [])
    }

    public init(stream: InputStream, deadline: Double = .never) {
        var buffer: Data = []

        if stream.closed {
            self.closed = true
        }

        while !stream.closed {
            if let chunk = try? stream.read(upTo: 1024, deadline: deadline) {
                buffer.bytes += chunk.bytes
            } else {
                break
            }
        }

        self.buffer = buffer
    }

    public init(buffer: Data) {
        self.buffer = buffer
    }

    public convenience init(buffer: DataRepresentable) {
        self.init(buffer: buffer.data)
    }

    public func close() throws {
        guard !closed else {
            throw ClosableError.alreadyClosed
        }
        closed = true
    }

    public func read(upTo byteCount: Int, deadline: Double = .never) throws -> Data {
        if byteCount >= buffer.count {
            try close()
            return buffer
        }

        let data = buffer.prefix(upTo: byteCount)
        buffer.removeFirst(byteCount)

        return Data(data)
    }

    public func write(_ data: Data, deadline: Double = .never) throws {
        buffer += data.bytes
    }

    public func flush(deadline: Double = .never) throws {}
}
