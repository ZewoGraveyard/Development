public protocol SingularResource : RouterRepresentable {
    associatedtype ControllerType: SingularController
    var controller: ControllerType { get }
    var path: String { get }
    var middleware: [Middleware] { get }
    var matcher: RouteMatcher.Type { get }
    var mediaTypes: [MediaTypeRepresentor.Type] { get }
    func recover(error: ErrorProtocol) throws -> Response
    func build(resource: ResourceBuilder)
}

extension SingularResource {
    public var path: String {
        return ""
    }

    public var matcher: RouteMatcher.Type {
        return TrieRouteMatcher.self
    }

    public var middleware: [Middleware] {
        return []
    }

    public var mediaTypes: [MediaTypeRepresentor.Type] {
        return []
    }

    public func recover(error: ErrorProtocol) throws -> Response {
        throw error
    }

    public func build(resource: ResourceBuilder) {}
}

extension SingularResource {
    public var router: RouterProtocol {
        let resource = ResourceBuilder(path: path, viewsPath: "")
        build(resource: resource)
        resource.create(action: controller.create)
        resource.detail(action: controller.detail)
        resource.update(action: controller.update)
        resource.destroy(action: controller.destroy)
        return BasicResource(
            matcher: matcher,
            middleware: middleware,
            mediaTypes: mediaTypes,
            recover: recover,
            resource: resource
        )
    }
}
