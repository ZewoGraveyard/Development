public protocol Resource : RouterRepresentable {
    associatedtype ControllerType: Controller
    var controller: ControllerType { get }
    var path: String { get }
    var viewsPath: String { get }
    var matcher: RouteMatcher.Type { get }
    var middleware: [Middleware] { get }
    var mediaTypes: [MediaTypeRepresentor.Type] { get }
    func recover(error: ErrorProtocol) throws -> Response
    func build(resource: ResourceBuilder)

    associatedtype ListOutput: StructuredDataFallibleRepresentable = ControllerType.ListOutput

    func renderList(input: ControllerType.ListOutput) throws -> ListOutput
}

extension Resource {
    public var path: String {
        return ""
    }

    public var viewsPath: String {
        let typeName = String(self.dynamicType)
        return String(typeName.characters.dropLast(8))
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

    public func renderList(input: ControllerType.ListOutput) throws -> ListOutput {
        throw PresenterError.bypass
    }
}

extension Resource {
    public var router: RouterProtocol {
        let resource = ResourceBuilder(path: path, viewsPath: viewsPath)
        build(resource: resource)
        resource.list(action: controller.list, render: renderList)
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
