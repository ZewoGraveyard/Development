// Appender.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if os(Linux)
    @_exported import Glibc
#else
    @_exported import Darwin.C
#endif

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
