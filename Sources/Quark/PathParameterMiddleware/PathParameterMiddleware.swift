public struct PathParameterMiddleware : Middleware {
    let pathParameters: [String: String]

    public init(_ pathParameters: [String: String]) {
        self.pathParameters = pathParameters
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        var request = request

        for (key, value) in pathParameters {
            request.pathParameters[key] = value
        }

        return try next.respond(to: request)
    }
}
