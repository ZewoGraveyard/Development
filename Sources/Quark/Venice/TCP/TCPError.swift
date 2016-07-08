public enum TCPError : ErrorProtocol {
    case didSendDataWithError(error: SystemError, remaining: Data)
    case didReceiveDataWithError(error: SystemError, received: Data)
}

extension TCPError : CustomStringConvertible {
    public var description: String {
        switch self {
        case didSendDataWithError(let error, _): return "\(error)"
        case didReceiveDataWithError(let error, _): return "\(error)"
        }
    }
}
