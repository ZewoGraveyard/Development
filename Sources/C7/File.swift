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

public protocol File : Stream {
    init(path: String, mode: FileMode) throws
    var fileExtension: String? { get }
    static func changeWorkingDirectory(path: String) throws

    func read(_ byteCount: Int, deadline: Double) throws -> Data
    func readAll(deadline: Double) throws -> Data
}

extension File {
    public func read(_ byteCount: Int) throws -> Data {
        return try read(byteCount, deadline: .never)
    }

    public func readAll() throws -> Data {
        return try readAll(deadline: .never)
    }
}

extension File {
    public init(path: String) throws {
        try self.init(path: path, mode: .read)
    }
}
