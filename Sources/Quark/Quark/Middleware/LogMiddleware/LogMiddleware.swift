public struct LogMiddleware : Middleware {
    private let debug: Bool

    public init(debug: Bool = false) {
        self.debug = debug
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)
        var message = "================================================================================\n"
        message += "Request:\n\n"
        message += debug ? "\(request.debugDescription)\n" : "\(request)\n"
        message += "--------------------------------------------------------------------------------\n"
        message += "Response:\n\n"
        message += debug ? "\(response.debugDescription)\n" : "\(response)\n"
        message += "================================================================================\n"
        print(message)
        return response
    }
}
