public final class ResourceRoutes : Routes {
    let viewsPath: String

    init(staticFilesPath: String, viewsPath: String, fileType: FileProtocol.Type) {
        self.viewsPath = viewsPath
        super.init(staticFilesPath: staticFilesPath, fileType: fileType)
    }
}

extension ResourceRoutes {
    public func list(
        middleware: [Middleware] = [],
        action: (Request) throws -> Response
        ) {
        let responder = BasicResponder { request in
            return try action(request)
        }
        addRoute(method: .get, path: "", middleware: middleware, responder: responder)
    }

    public func create<Content: StructuredDataInitializable>(
        middleware: [Middleware] = [],
        action: (Request, Content) throws -> Response) {
        let contentMapper = ContentMapperMiddleware(mappingTo: Content.self)
        let responder = BasicResponder { request in
            guard let content = request.storage[Content.key] as? Content else {
                throw ClientError.badRequest
            }
            return try action(request, content)
        }
        addRoute(method: .post, path: "", middleware: [contentMapper] + middleware, responder: responder)
    }

    public func detail<ID: PathParameterInitializable>(
        middleware: [Middleware] = [],
        action: (Request, ID) throws -> Response) {
        let responder = BasicResponder { request in
            let id = try ID(pathParameter: request.pathParameters["id"]!)
            return try action(request, id)
        }
        addRoute(method: .get, path: "/:id", middleware: middleware, responder: responder)
    }

    public func update<ID: PathParameterInitializable, Content: StructuredDataInitializable>(
        middleware: [Middleware] = [],
        action: (Request, ID, Content) throws -> Response) {
        let contentMapper = ContentMapperMiddleware(mappingTo: Content.self)
        let responder = BasicResponder { request in
            let id = try ID(pathParameter: request.pathParameters["id"]!)
            guard let content = request.storage[Content.key] as? Content else {
                throw ClientError.badRequest
            }
            return try action(request, id, content)
        }
        addRoute(method: .patch, path: "/:id", middleware: [contentMapper] + middleware, responder: responder)
    }

    public func destroy<ID: PathParameterInitializable>(
        middleware: [Middleware] = [],
        action: (Request, ID) throws -> Response) {
        let responder = BasicResponder { request in
            let id = try ID(pathParameter: request.pathParameters["id"]!)
            return try action(request, id)
        }
        addRoute(method: .delete, path: "/:id", middleware: middleware, responder: responder)
    }
}
