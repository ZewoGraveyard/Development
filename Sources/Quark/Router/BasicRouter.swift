public struct BasicRouter : RouterProtocol {
    public let middleware: [Middleware]
    public let matcher: RouteMatcher
    public let routes: [Route]
    public let fallback: Responder

    init(middleware: [Middleware], matcher: RouteMatcher.Type, router: RouterBuilder) {
        self.middleware = middleware
        self.matcher = matcher.init(routes: router.routes)
        self.routes = router.routes
        self.fallback = router.fallback
    }

    public init(
        path: String = "",
        matcher: RouteMatcher.Type = TrieRouteMatcher.self,
        middleware: [Middleware] = [],
        build: @noescape (router: RouterBuilder) -> Void
        ) {
        let router = RouterBuilder(path: path)
        build(router: router)
        self.init(
            middleware: middleware,
            matcher: matcher,
            router: router
        )
    }

    public func match(_ request: Request) -> Route? {
        return matcher.match(request)
    }
}

extension BasicRouter {
    public func respond(to request: Request) throws -> Response {
        let responder = match(request) ?? fallback
        return try middleware.chain(to: responder).respond(to: request)
    }
}
