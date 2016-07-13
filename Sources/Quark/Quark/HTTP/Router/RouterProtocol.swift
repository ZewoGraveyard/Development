public protocol RouterRepresentable : ResponderRepresentable {
    var router: RouterProtocol { get }
}

extension RouterRepresentable {
    public var responder: Responder {
        return router
    }
}

public protocol RouterProtocol : Responder, RouterRepresentable {
    var routes: [RouteProtocol] { get }
    var fallback: Responder { get }
    func match(_ request: Request) -> RouteProtocol?
}

extension RouterProtocol {
    public var router: RouterProtocol {
        return self
    }
}

extension RouterProtocol {
    public func respond(request: Request) throws -> Response {
        let responder = match(request) ?? fallback
        return try responder.respond(to: request)
    }
}

public protocol RouteProtocol : Responder {
    var path: String { get }
    var actions: [Method: Responder] { get }
    var fallback: Responder { get }
}

public protocol RouteMatcher {
    var routes: [RouteProtocol] { get }
    init(routes: [RouteProtocol])
    func match(_ request: Request) -> RouteProtocol?
}

extension RouteProtocol {
    public var fallback: Responder {
        return BasicResponder { _ in
            Response(status: .methodNotAllowed)
        }
    }

    public func respond(to request: Request) throws -> Response {
        let action = actions[request.method] ?? fallback
        return try action.respond(to: request)
    }
}

public final class BasicRoute : RouteProtocol {
    public let path: String
    public var actions: [Method: Responder]
    public var fallback: Responder

    public init(path: String, actions: [Method: Responder] = [:], fallback: Responder = BasicRoute.defaultFallback) {
        self.path = path
        self.actions = actions
        self.fallback = fallback
    }

    public func addAction(method: Method, action: Responder) {
        actions[method] = action
    }

    public static let defaultFallback = BasicResponder { _ in
        Response(status: .methodNotAllowed)
    }
}

extension BasicRoute : CustomStringConvertible {
    public var description: String {
        var actions: [String] = []

        for (method, _) in self.actions {
            actions.append("\(method) \(path)")
        }

        return actions.joined(separator: ", ")
    }
}
