public struct BasicResource : RouterProtocol {
    public let middleware: [Middleware]
    public let routes: [Route]
    public let fallback: Responder
    public let matcher: RouteMatcher

    init(
        matcher: RouteMatcher.Type,
        middleware: [Middleware],
        mediaTypes: [MediaTypeRepresentor.Type],
        recover: ((ErrorProtocol) throws -> Response),
        resource: ResourceBuilder) {
        var chain: [Middleware] = []

        chain.append(RecoveryMiddleware(recover))

        var types: [MediaTypeRepresentor.Type] = [JSON.self, URLEncodedForm.self]
        types.append(contentsOf: mediaTypes)
        let contentNegotiaton = ContentNegotiationMiddleware(mediaTypes: types)
        chain.append(contentNegotiaton)

        chain.append(contentsOf: middleware)

        self.middleware = chain
        self.fallback = resource.fallback
        self.matcher = matcher.init(routes: resource.routes)
        self.routes = resource.routes
    }

    public func match(_ request: Request) -> Route? {
        return matcher.match(request)
    }
}

extension BasicResource {
    public func respond(to request: Request) throws -> Response {
        let responder = match(request) ?? fallback
        return try middleware.chain(to: responder).respond(to: request)
    }
}
