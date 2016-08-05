public struct BasicResource : RouterProtocol {
    public let middleware: [Middleware]
    public let routes: [Route]
    public let fallback: Responder
    public let matcher: TrieRouteMatcher

    init(
        recover: Recover,
        middleware: [Middleware],
        routes: ResourceRoutes
        ) {
        self.middleware = [RecoveryMiddleware(recover)] + middleware
        self.routes = routes.routes
        self.fallback = routes.fallback
        self.matcher = TrieRouteMatcher(routes: routes.routes)
    }

    public init(
        recover: Recover = RecoveryMiddleware.recover,
        staticFilesPath: String = "Public",
        fileType: C7.File.Type,
        middleware: [Middleware] = [],
        routes: (ResourceRoutes) -> Void
        ) {
        let r = ResourceRoutes(staticFilesPath: staticFilesPath, fileType: fileType)
        routes(r)
        self.init(recover: recover, middleware: middleware, routes: r)
    }

    public func match(_ request: Request) -> Route? {
        return matcher.match(request)
    }
}
