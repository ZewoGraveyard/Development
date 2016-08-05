extension Body {
    /**
     Converts the body's contents into a `Data` buffer.
     If the body is a reader or writer type,
     it will be drained.
     */
    public mutating func becomeBuffer(deadline: Double = .never) throws -> Data {
        switch self {
        case .buffer(let data):
            return data
        case .reader(let reader):
            let data = Drain(stream: reader, deadline: deadline).data
            self = .buffer(data)
            return data
        case .writer(let writer):
            let drain = Drain()
            try writer(drain)
            let data = drain.data

            self = .buffer(data)
            return data
        default:
            throw BodyError.inconvertibleType
        }
    }

    /**
     Converts the body's contents into a `InputStream`
     that can be received in chunks.
     */
    public mutating func becomeReader() throws -> InputStream {
        switch self {
        case .reader(let reader):
            return reader
        case .buffer(let buffer):
            let stream = Drain(buffer: buffer)
            self = .reader(stream)
            return stream
        case .writer(let writer):
            let stream = Drain()
            try writer(stream)
            self = .reader(stream)
            return stream
        default:
            throw BodyError.inconvertibleType
        }
    }

    /**
     Converts the body's contents into a closure
     that accepts a `C7.OutputStream`.
     */
    public mutating func becomeWriter(deadline: Double = .never) throws -> ((C7.OutputStream) throws -> Void) {
        switch self {
        case .buffer(let data):
            let closure: ((C7.OutputStream) throws -> Void) = { writer in
                try writer.write(data, deadline: deadline)
            }
            self = .writer(closure)
            return closure
        case .reader(let reader):
            let closure: ((C7.OutputStream) throws -> Void) = { writer in
                let data = Drain(stream: reader, deadline: deadline).data
                try writer.write(data, deadline: deadline)
            }
            self = .writer(closure)
            return closure
        case .writer(let writer):
            return writer
        default:
            throw BodyError.inconvertibleType
        }
    }
}

extension Body : Equatable {}

public func == (lhs: Body, rhs: Body) -> Bool {
    switch (lhs, rhs) {
        case let (.buffer(l), .buffer(r)) where l == r: return true
        default: return false
    }
}
