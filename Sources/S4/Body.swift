/**
    Represents the body of the HTTP message.

    An HTTP message body contains the bytes of data that
    are transmitted immediately following the headers.

    - buffer:        Simplest type of HTTP message body.
                     Represents a `Data` object containing
                     a byte array.

    - reader:      Contains a `InputStream` that can be drained
                     in chunks to access the body's data.

    - writer:        Contains a closure that accepts a `OutputStream`
                     object to which the body's data should be sent.
 
    - asyncReader: Contains a `AsyncInputStream` that can be drained
                     in chunks to access the body's data.
 
    - asyncWriter:   Contains a closure that accepts a `AsyncOutputStream`
                     object to which the body's data should be sent.
 
*/
public enum Body {
    case buffer(Data)
    case reader(InputStream)
    case writer((C7.OutputStream) throws -> Void)
    case asyncReader(AsyncInputStream)
    case asyncWriter((AsyncOutputStream, ((Void) throws -> Void) -> Void) -> Void)
}

public enum BodyError : Error {
    case inconvertibleType
}

extension Body {
    ///Returns true if body is case `buffer`
    public var isBuffer: Bool {
        switch self {
        case .buffer: return true
        default: return false
        }
    }

    ///Returns true if body is case `reader`
    public var isReader: Bool {
        switch self {
        case .reader: return true
        default: return false
        }
    }

    ///Returns true if body is case `writer`
    public var isWriter: Bool {
        switch self {
        case .writer: return true
        default: return false
        }
    }

    ///Returns true if body is case `asyncReader`
    public var isAsyncReader: Bool {
        switch self {
        case .asyncReader: return true
        default: return false
        }
    }
    
    ///Returns true if body is case `asyncWriter`
    public var isAsyncWriter: Bool {
        switch self {
        case .asyncWriter: return true
        default: return false
        }
    }
}
