public struct LogMiddleware : Middleware {
    private let logger: Logger
    private let level: Log.Level
    private let debug: Bool

    public init(logger: Logger, level: Log.Level = .info, debug: Bool = true) {
        self.logger = logger
        self.level = level
        self.debug = debug
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)
        var message = "================================================================================\n"
        message += "Request:\n"
        message += debug ? "\(request.debugDescription)\n" : "\(request)\n"
        message += "--------------------------------------------------------------------------------\n"
        message += "Response:\n"
        message += debug ? "\(response.debugDescription)\n" : "\(response)\n"
        message += "================================================================================\n\n"
        logger.log(message)
        return response
    }
}
