public typealias Recover = (Error) throws -> Response

public struct RecoveryMiddleware : Middleware {
    let recover: Recover

    public init(_ recover: Recover = RecoveryMiddleware.recover) {
        self.recover = recover
    }

    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch {
            return try recover(error)
        }
    }

    public static func recover(error: Error) throws -> Response {
        switch error {
        case let error as HTTPError:
            return Response(status: error.status)
        default:
            throw error
        }
    }
}
