public protocol Resource : RouterRepresentable {
    associatedtype ID : PathParameterInitializable = String
    associatedtype Model : StructuredDataInitializable, StructuredDataFallibleRepresentable = StructuredData

    associatedtype DetailID : PathParameterInitializable = ID
    associatedtype UpdateID : PathParameterInitializable = ID
    associatedtype DestroyID : PathParameterInitializable = ID

    associatedtype CreateInput : StructuredDataInitializable = Model
    associatedtype UpdateInput : StructuredDataInitializable = Model

    var fileType: FileProtocol.Type { get }
    var staticFilesPath: String { get }

    var viewsPath: String { get }
    var middleware: [Middleware] { get }

    func list() throws -> Response
    func list(request: Request) throws -> Response

    func create(content: CreateInput) throws -> Response
    func create(request: Request, content: CreateInput) throws -> Response

    func detail(id: DetailID) throws -> Response
    func detail(request: Request, id: DetailID) throws -> Response

    func update(id: UpdateID, content: UpdateInput) throws -> Response
    func update(request: Request, id: UpdateID, content: UpdateInput) throws -> Response

    func destroy(id: DestroyID) throws -> Response
    func destroy(request: Request, id: DestroyID) throws -> Response

    func recover(error: ErrorProtocol) throws -> Response
    func custom(routes: ResourceRoutes)
}

// Warning: This is here due to a compiler bug.
// This will have to be deleted once we split Venice from Quark

public extension Resource {
    var fileType: FileProtocol.Type {
        return File.self
    }
}

public extension Resource {
    var staticFilesPath: String {
        return "Public"
    }

    var viewsPath: String {
        let typeName = String(self.dynamicType)
        return String(typeName.characters.dropLast(8))
    }

    var middleware: [Middleware] {
        return []
    }
}

public extension Resource {
    func list() throws -> Response {
        throw ClientError.notFound
    }

    func list(request: Request) throws -> Response {
        return try list()
    }
}

public extension Resource {
    func create(content: CreateInput) throws -> Response {
        throw ClientError.notFound
    }

    func create(request: Request, content: CreateInput) throws -> Response {
        return try create(content: content)
    }
}

public extension Resource {
    func detail(id: DetailID) throws -> Response {
        throw ClientError.notFound
    }

    func detail(request: Request, id: DetailID) throws -> Response {
        return try detail(id: id)
    }
}

public extension Resource {
    func update(id: UpdateID, content: UpdateInput) throws -> Response {
        throw ClientError.notFound
    }

    func update(request: Request, id: UpdateID, content: UpdateInput) throws -> Response {
        return try update(id: id, content: content)
    }
}

public extension Resource {
    func destroy(id: DestroyID) throws -> Response {
        throw ClientError.notFound
    }

    func destroy(request: Request, id: DestroyID) throws -> Response {
        return try destroy(id: id)
    }
}

public extension Resource {
    func recover(error: ErrorProtocol) throws -> Response {
        return try RecoveryMiddleware.defaultRecover(error: error)
    }

    func custom(routes: ResourceRoutes) {}
}


extension Resource {
    public var router: RouterProtocol {
        let routes = ResourceRoutes(staticFilesPath: staticFilesPath, viewsPath: viewsPath, fileType: fileType)
        custom(routes: routes)
        routes.list(action: list)
        routes.create(action: create)
        routes.detail(action: detail)
        routes.update(action: update)
        routes.destroy(action: destroy)
        return BasicResource(recover: recover, middleware: middleware, routes: routes)
    }
}
