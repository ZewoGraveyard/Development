public struct Log {
    public struct Level: OptionSet {
        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static let trace   = Level(rawValue: 1 << 0)
        public static let debug   = Level(rawValue: 1 << 1)
        public static let info    = Level(rawValue: 1 << 2)
        public static let warning = Level(rawValue: 1 << 3)
        public static let error   = Level(rawValue: 1 << 4)
        public static let fatal   = Level(rawValue: 1 << 5)
        public static let all     = Level(rawValue: ~0)
    }

    let stream: Stream
    let levels: Level

    public init(stream: Stream, levels: Level = .all) {
        self.stream = stream
        self.levels = levels
    }

    public func log(level: Level, item: Any, terminator: String = "\n", flush: Bool = true) {
        if levels.contains(level) {
            let message = "\(item)\(terminator)"
            do {
                try stream.send(message.data, timingOut: .never)
                if flush {
                    try stream.flush(timingOut: .never)
                }
            } catch {
                print("Log error: \(error)")
                print("Log message: \(message)")
            }
        }
    }

    public func trace(_ item: Any, terminator: String = "\n", flush: Bool = true) {
        log(level: .trace, item: item, terminator: terminator, flush: flush)
    }

    public func debug(_ item: Any, terminator: String = "\n", flush: Bool = true) {
        log(level: .debug, item: item, terminator: terminator, flush: flush)
    }

    public func info(_ item: Any, terminator: String = "\n", flush: Bool = true) {
        log(level: .info, item: item, terminator: terminator, flush: flush)
    }

    public func warning(_ item: Any, terminator: String = "\n", flush: Bool = true) {
        log(level: .warning, item: item, terminator: terminator, flush: flush)
    }

    public func error(_ item: Any, terminator: String = "\n", flush: Bool = true) {
        log(level: .error, item: item, terminator: terminator, flush: flush)
    }

    public func fatal(_ item: Any, terminator: String = "\n", flush: Bool = true) {
        log(level: .fatal, item: item, terminator: terminator, flush: flush)
    }
}

public final class Logger {

    var appenders = [Appender]()
    var levels: Log.Level
    var name: String

    public init(name: String = "Logger", appender: Appender? = StandardOutputAppender(), levels: Log.Level = .all) {
        if let appender = appender {
            self.appenders.append(appender)
        }
        self.levels = levels
        self.name = name
    }

    public init(name: String = "Logger", appenders: [Appender], levels: Log.Level = .all) {
        self.appenders.append(contentsOf: appenders)
        self.levels = levels
        self.name = name
    }

    public func log(_ item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let locationInfo = LocationInfo(file: file, line: line, column: column, function: function)
        let event = LoggingEvent(locationInfo: locationInfo, timestamp: currentTime, level: self.levels, name: self.name, logger: self, message: item, error: error)
        for apender in appenders {
            apender.append(event)
        }
    }

    private func log(level: Log.Level, item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        let locationInfo = LocationInfo(file: file, line: line, column: column, function: function)
        let event = LoggingEvent(locationInfo: locationInfo, timestamp: currentTime, level: level, name: self.name, logger: self, message: item, error: error)
        for apender in appenders {
            apender.append(event)
        }
    }

    public func trace(_ item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .trace, item: item, error: error, file: file, function: function, line: line, column: column)
    }

    public func debug(_ item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .debug, item: item, error: error, file: file, function: function, line: line, column: column)
    }

    public func info(_ item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .info, item: item, error: error, file: file, function: function, line: line, column: column)
    }

    public func warning(_ item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .warning, item: item, error: error, file: file, function: function, line: line, column: column)
    }

    public func error(_ item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .error, item: item, error: error, file: file, function: function, line: line, column: column)
    }

    public func fatal(_ item: Any?, error: ErrorProtocol? = nil, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .fatal, item: item, error: error, file: file, function: function, line: line, column: column)
    }

    private var currentTime: Int {
      var tv = timeval()
      gettimeofday(&tv, nil)
      return tv.tv_sec
    }
}
