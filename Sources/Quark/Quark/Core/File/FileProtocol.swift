public enum FileMode {
    case read
    case createWrite
    case truncateWrite
    case appendWrite
    case readWrite
    case createReadWrite
    case truncateReadWrite
    case appendReadWrite
}

public protocol FileProtocol {
    init(path: String, mode: FileMode) throws
    var stream: Stream { get }
    var fileExtension: String? { get }

    func write(_ data: Data, timingOut deadline: Double) throws
    func read(upTo byteCount: Int, timingOut deadline: Double) throws -> Data
    func read(_ byteCount: Int, timingOut deadline: Double) throws -> Data
    func readAllBytes(timingOut deadline: Double) throws -> Data
    func flush(timingOut deadline: Double) throws
    func close() throws
}

extension FileProtocol {
    public func write(_ data: Data) throws {
        try write(data, timingOut: .never)
    }

    public func read(upTo byteCount: Int) throws -> Data {
        return try read(upTo: byteCount, timingOut: .never)
    }

    public func read(_ byteCount: Int) throws -> Data {
        return try read(byteCount, timingOut: .never)
    }

    public func readAllBytes() throws -> Data {
        return try readAllBytes(timingOut: .never)
    }

    public func flush() throws {
        try flush(timingOut: .never)
    }
}

extension FileProtocol {
    public init(path: String) throws {
        try self.init(path: path, mode: .read)
    }
}
