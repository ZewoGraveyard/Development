public protocol AsyncWritable {
    func write(_ data: Data, deadline: Double, completion: @escaping ((Void) throws -> Void) -> Void)
    func flush(deadline: Double, completion: @escaping ((Void) throws -> Void) -> Void)
}

extension AsyncWritable {
    public func write(_ data: Data, completion: @escaping ((Void) throws -> Void) -> Void) {
        write(data, deadline: .never, completion: completion)
    }

    public func write(_ convertible: DataConvertible, deadline: Double = .never, completion: @escaping ((Void) throws -> Void) -> Void) {
        write(convertible.data, deadline: deadline, completion: completion)
    }

    public func flush(completion: @escaping ((Void) throws -> Void) -> Void) {
        flush(deadline: .never, completion: completion)
    }
}

public protocol AsyncReadable {
    func read(upTo byteCount: Int, deadline: Double, completion: @escaping ((Void) throws -> Data) -> Void)
}

extension AsyncReadable {
    public func read(upTo byteCount: Int, completion: @escaping ((Void) throws -> Data) -> Void) {
        read(upTo: byteCount, deadline: .never, completion: completion)
    }
}

public protocol AsyncOutputStream : Closable, AsyncWritable {}
public protocol AsyncInputStream : Closable, AsyncReadable {}
public protocol AsyncStream : AsyncOutputStream, AsyncInputStream {}
