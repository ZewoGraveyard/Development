public enum StreamError : Error {
    case closedStream(data: Data)
    case timeout(data: Data)
}

public protocol Closable {
    var closed: Bool { get }
    func close() throws
}

public enum ClosableError: Error {
    case alreadyClosed
}

public protocol Writable : AsyncWritable {
    func write(_ data: Data, deadline: Double) throws
    func flush(deadline: Double) throws
}

extension Writable {
    public func write(_ data: Data) throws {
        try write(data, deadline: .never)
    }

    public func write(_ convertible: DataConvertible, deadline: Double = .never) throws {
        try write(convertible.data, deadline: deadline)
    }

    public func flush() throws {
        try flush(deadline: .never)
    }
}

extension Writable {
    public func write(_ data: Data, deadline: Double, completion: @escaping ((Void) throws -> Void) -> Void) {
        completion { try self.write(data, deadline: deadline) }
    }

    public func flush(deadline: Double, completion: @escaping ((Void) throws -> Void) -> Void) {
        completion { try self.flush(deadline: deadline) }
    }
}

public protocol Readable : AsyncReadable {
    func read(upTo byteCount: Int, deadline: Double) throws -> Data
}

extension Readable {
    public func read(upTo byteCount: Int) throws -> Data {
        return try read(upTo: byteCount, deadline: .never)
    }
}

extension Readable {
    public func read(upTo byteCount: Int, deadline: Double, completion: @escaping ((Void) throws -> Data) -> Void) {
        completion { try self.read(upTo: byteCount, deadline: deadline) }
    }
}

public protocol OutputStream : Closable, Writable, AsyncOutputStream {}
public protocol InputStream : Closable, Readable, AsyncInputStream {}
public protocol Stream : OutputStream, InputStream, AsyncStream {}
