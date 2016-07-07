public protocol Router : RouterRepresentable {
    var path: String { get }
    var middleware: [Middleware] { get }
    var matcher: RouteMatcher.Type { get }
    func build(router: RouterBuilder)
}

extension Router {
    public var path: String {
        return ""
    }

    public var middleware: [Middleware] {
        return []
    }

    public var matcher: RouteMatcher.Type {
        return TrieRouteMatcher.self
    }

    public func build(router: RouterBuilder) {}
}

extension Router {
    public var router: RouterProtocol {
        let router = RouterBuilder(path: path)
        build(router: router)
        return BasicRouter(
            middleware: middleware,
            matcher: matcher,
            router: router
        )
    }
}
