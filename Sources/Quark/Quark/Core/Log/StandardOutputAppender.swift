public struct StandardOutputAppender : Appender {
    public let name: String
    public var closed: Bool
    public var level: Log.Level

    init(name: String = "Standard Output Appender", closed: Bool = false, level: Log.Level = .all) {
        self.name = name
        self.closed = closed
        self.level = level
    }

    public func append(_ event: LoggingEvent) {
        var logMessage = ""

        logMessage += "[\(event.timestamp)]"
        logMessage += "[\(event.locationInfo.description)]"

        if let message = event.message {
            logMessage += ": \(message)"
        }
        if let error = event.error {
            logMessage += ": \(error)"
        }

        print(logMessage)
    }
}
