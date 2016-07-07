public protocol Appender {
    var name: String { get }
    var closed: Bool { get }
    var level: Log.Level { get }

    func append (_ event: LoggingEvent)
}
