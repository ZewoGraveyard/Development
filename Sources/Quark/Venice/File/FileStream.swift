internal final class FileStream : Stream {
    internal let file: File

    internal init(file: File) {
        self.file = file
    }

    var closed: Bool {
        return file.closed
    }

    func send(_ data: Data, timingOut deadline: Double) throws {
        try file.write(data, timingOut: deadline)
    }

    func flush(timingOut deadline: Double) throws {
        try file.flush(timingOut: deadline)
    }

    func receive(upTo byteCount: Int, timingOut deadline: Double) throws -> Data {
        return try file.read(upTo: byteCount, timingOut: deadline)
    }

    func close() throws {
        try file.close()
    }
}
