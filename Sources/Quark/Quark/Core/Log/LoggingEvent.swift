public struct LoggingEvent {
    public let locationInfo: LocationInfo
    public let timestamp: Int
    public let level: Log.Level
    public let name: String
    public let logger: Logger
    public var message: Any? = nil
    public var error: ErrorProtocol? = nil
}
