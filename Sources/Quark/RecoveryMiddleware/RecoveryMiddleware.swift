public struct RecoveryMiddleware : Middleware {
    let recover: (ErrorProtocol) throws -> Response

    public init(_ recover: (ErrorProtocol) throws -> Response) {
        self.recover = recover
    }

    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch {
            return try recover(error)
        }
    }
}
