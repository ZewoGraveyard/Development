public struct RecoveryMiddleware : Middleware {
    let recover: (ErrorProtocol) throws -> Response

    public init(_ recover: (ErrorProtocol) throws -> Response = RecoveryMiddleware.defaultRecover) {
        self.recover = recover
    }

    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch {
            return try recover(error)
        }
    }

    public static func defaultRecover(error: ErrorProtocol) throws -> Response {
        switch error {
        case ClientError.badRequest:
            return Response(status: .badRequest)
        case ClientError.unauthorized:
            return Response(status: .unauthorized)
        case ClientError.paymentRequired:
            return Response(status: .paymentRequired)
        case ClientError.forbidden:
            return Response(status: .forbidden)
        case ClientError.notFound:
            return Response(status: .notFound)
        case ClientError.methodNotAllowed:
            return Response(status: .methodNotAllowed)
        case ClientError.notAcceptable:
            return Response(status: .notAcceptable)
        case ClientError.proxyAuthenticationRequired:
            return Response(status: .proxyAuthenticationRequired)
        case ClientError.requestTimeout:
            return Response(status: .requestTimeout)
        case ClientError.conflict:
            return Response(status: .conflict)
        case ClientError.gone:
            return Response(status: .gone)
        case ClientError.lengthRequired:
            return Response(status: .lengthRequired)
        case ClientError.preconditionFailed:
            return Response(status: .preconditionFailed)
        case ClientError.requestEntityTooLarge:
            return Response(status: .requestEntityTooLarge)
        case ClientError.requestURITooLong:
            return Response(status: .requestURITooLong)
        case ClientError.unsupportedMediaType:
            return Response(status: .unsupportedMediaType)
        case ClientError.requestedRangeNotSatisfiable:
            return Response(status: .requestedRangeNotSatisfiable)
        case ClientError.expectationFailed:
            return Response(status: .expectationFailed)
        case ClientError.imATeapot:
            return Response(status: .imATeapot)
        case ClientError.authenticationTimeout:
            return Response(status: .authenticationTimeout)
        case ClientError.enhanceYourCalm:
            return Response(status: .enhanceYourCalm)
        case ClientError.unprocessableEntity:
            return Response(status: .unprocessableEntity)
        case ClientError.locked:
            return Response(status: .locked)
        case ClientError.failedDependency:
            return Response(status: .failedDependency)
        case ClientError.preconditionRequired:
            return Response(status: .preconditionRequired)
        case ClientError.tooManyRequests:
            return Response(status: .tooManyRequests)
        case ClientError.requestHeaderFieldsTooLarge:
            return Response(status: .requestHeaderFieldsTooLarge)

        case ServerError.internalServerError:
            return Response(status: .internalServerError)
        case ServerError.notImplemented:
            return Response(status: .notImplemented)
        case ServerError.badGateway:
            return Response(status: .badGateway)
        case ServerError.serviceUnavailable:
            return Response(status: .serviceUnavailable)
        case ServerError.gatewayTimeout:
            return Response(status: .gatewayTimeout)
        case ServerError.httpVersionNotSupported:
            return Response(status: .httpVersionNotSupported)
        case ServerError.variantAlsoNegotiates:
            return Response(status: .variantAlsoNegotiates)
        case ServerError.insufficientStorage:
            return Response(status: .insufficientStorage)
        case ServerError.loopDetected:
            return Response(status: .loopDetected)
        case ServerError.notExtended:
            return Response(status: .notExtended)
        case ServerError.networkAuthenticationRequired:
            return Response(status: .networkAuthenticationRequired)

        default:
            throw error
        }
    }
}
