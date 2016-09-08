import CLibvenice

public final class FileDescriptorStream : Stream {
    fileprivate var file: mfile?
    public fileprivate(set) var closed = false

    init(file: mfile) {
        self.file = file
    }

    public convenience init(fileDescriptor: FileDescriptor) throws {
        let file = fileattach(fileDescriptor)
        try ensureLastOperationSucceeded()
        self.init(file: file!)
    }

    deinit {
        if let file = file, !closed {
            fileclose(file)
        }
    }
}

extension FileDescriptorStream {
    public func write(_ data: Data, length: Int, deadline: Double) throws -> Int {
        try ensureFileIsOpen()

        let bytesWritten = data.withUnsafeBytes {
            filewrite(file, $0, length, deadline.int64milliseconds)
        }

        if bytesWritten == 0 {
            try ensureLastOperationSucceeded()
        }

        return bytesWritten
    }

    public func read(into buffer: inout Data, length: Int, deadline: Double) throws -> Int {
        try ensureFileIsOpen()

        let bytesRead = buffer.withUnsafeMutableBytes {
            filereadlh(file, $0, 1, length, deadline.int64milliseconds)
        }

        if bytesRead == 0 {
            try ensureLastOperationSucceeded()
        }

        return bytesRead
    }

    public func flush(deadline: Double) throws {
        try ensureFileIsOpen()
        fileflush(file, deadline.int64milliseconds)
        try ensureLastOperationSucceeded()
    }

    public func close() {
        if !closed {
            fileclose(file)
        }
        closed = true
    }

    private func ensureFileIsOpen() throws {
        if closed {
            throw StreamError.closedStream(data: Data())
        }
    }
}

