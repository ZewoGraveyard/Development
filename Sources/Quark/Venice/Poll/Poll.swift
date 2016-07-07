import CLibvenice

public typealias FileDescriptor = Int32

public enum PollError : ErrorProtocol {
    case timeout
    case failure
}

public struct PollEvent : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let reading  = PollEvent(rawValue: Int(FDW_IN))
    public static let writing = PollEvent(rawValue: Int(FDW_OUT))
}

/// Polls file descriptor for events
public func poll(_ fileDescriptor: FileDescriptor, for events: PollEvent, timingOut deadline: Double = .never) throws -> PollEvent {
    let event = mill_fdwait(fileDescriptor, Int32(events.rawValue), deadline.int64milliseconds, "pollFileDescriptor")

    if event == 0 {
        throw PollError.timeout
    }

    if event == FDW_ERR {
        throw PollError.failure
    }

    return PollEvent(rawValue: Int(event))
}
