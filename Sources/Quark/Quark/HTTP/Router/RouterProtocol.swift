public protocol RouterRepresentable : ResponderRepresentable {
    var router: RouterProtocol { get }
}

extension RouterRepresentable {
    public var responder: Responder {
        return router
    }
}

public protocol RouterProtocol : Responder, RouterRepresentable {
    var routes: [Route] { get }
    var fallback: Responder { get }
    var middleware: [Middleware] { get }
    func match(_ request: Request) -> Route?
}

extension RouterProtocol {
    public func respond(to request: Request) throws -> Response {
        let responder = match(request) ?? fallback
        return try middleware.chain(to: responder).respond(to: request)
    }
}

extension RouterProtocol {
    public var router: RouterProtocol {
        return self
    }
}

public final class Route : Responder {
    public let path: String
    public var actions: [Method: Responder]
    public var fallback: Responder

    public init(path: String, actions: [Method: Responder] = [:], fallback: Responder = Route.defaultFallback) {
        self.path = path
        self.actions = actions
        self.fallback = fallback
    }

    public func addAction(method: Method, action: Responder) {
        actions[method] = action
    }

    public static let defaultFallback = BasicResponder { _ in
        throw ClientError.methodNotAllowed
    }

    public func respond(to request: Request) throws -> Response {
        let action = actions[request.method] ?? fallback
        return try action.respond(to: request)
    }
}

extension Route : CustomStringConvertible {
    public var description: String {
        var actions: [String] = []

        for (method, _) in self.actions {
            actions.append("\(method) \(path)")
        }

        return actions.joined(separator: ", ")
    }
}
