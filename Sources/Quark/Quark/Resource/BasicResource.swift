public struct BasicResource : RouterProtocol {
    public let middleware: [Middleware]
    public let routes: [RouteProtocol]
    public let fallback: Responder
    public let matcher: RouteMatcher

    init(
        recover: ((ErrorProtocol) throws -> Response),
        middleware: [Middleware],
        routes: ResourceRoutes
        ) {
        var chain: [Middleware] = []
        chain.append(RecoveryMiddleware(recover))
        chain.append(contentsOf: middleware)

        self.middleware = chain
        self.routes = routes.routes
        self.fallback = routes.fallback
        self.matcher = TrieRouteMatcher(routes: routes.routes)
    }

    public func match(_ request: Request) -> RouteProtocol? {
        return matcher.match(request)
    }
}

extension BasicResource {
    public func respond(to request: Request) throws -> Response {
        let responder = match(request) ?? fallback
        return try middleware.chain(to: responder).respond(to: request)
    }
}
