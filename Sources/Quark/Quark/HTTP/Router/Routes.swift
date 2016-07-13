public class Routes {
    public let staticFilesPath: String
    public let fileType: FileProtocol.Type
    public var routes: [RouteProtocol] = []

    public lazy var fallback: Responder = FileResponder(path: self.staticFilesPath, fileType: self.fileType)

    public init(staticFilesPath: String, fileType: FileProtocol.Type) {
        self.staticFilesPath = staticFilesPath
        self.fileType = fileType
    }
}

extension Routes {
    public func compose(_ path: String, middleware: Middleware..., resource: RouterRepresentable)  {
        compose(path, middleware: middleware, router: resource)
    }

    public func compose(_ path: String, middleware: Middleware..., router: RouterRepresentable) {
        compose(path, middleware: middleware, router: router)
    }

    private func compose(_ path: String, middleware: [Middleware], router representable: RouterRepresentable) {
        let router = representable.router
        let prefix = path

        let prefixPathComponentsCount = prefix.split(separator: "/").count

        for route in router.routes {
            for (method, _) in route.actions {
                addRoute(
                    method: method,
                    path: path + route.path,
                    middleware: middleware,
                    responder: BasicResponder { request in
                        var request = request

                        guard let path = request.path else {
                            return Response(status: .badRequest)
                        }

                        let requestPathComponents = path.split(separator: "/")
                        let shortenedRequestPathComponents = requestPathComponents.dropFirst(prefixPathComponentsCount)
                        let shortenedPath = "/" + shortenedRequestPathComponents.joined(separator: "/")

                        request.uri.path = shortenedPath
                        return try router.respond(to: request)
                    }
                )
            }
        }
    }
}

extension Routes {
    public func fallback(middleware: [Middleware] = [], respond: Respond) {
        fallback(middleware: middleware, responder: BasicResponder(respond))
    }

    public func fallback(middleware: [Middleware] = [], responder: Responder) {
        fallback = middleware.chain(to: responder)
    }
}

extension Routes {
    public func get(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: Respond) {
        get(path, middleware: middleware, responder: BasicResponder(respond))
    }

    public func get(
        _ path: String = "",
        middleware: [Middleware] = [],
        responder: Responder) {
        addRoute(method: .get, path: path, middleware: middleware, responder: responder)
    }

    public func get<
        A: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, T) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, T) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, T) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, T) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }

    public func get<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        addRoute(method: .get, path: path, middleware: middleware, respond: respond)
    }
}

extension Routes {
    public func head(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: Respond) {
        head(path, middleware: middleware, responder: BasicResponder(respond))
    }

    public func head(
        _ path: String = "",
        middleware: [Middleware] = [],
        responder: Responder) {
        addRoute(method: .head, path: path, middleware: middleware, responder: responder)
    }

    public func head<
        A: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, T) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, T) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, T) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, T) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }

    public func head<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        addRoute(method: .head, path: path, middleware: middleware, respond: respond)
    }
}

extension Routes {
    public func post(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: Respond) {
        post(path, middleware: middleware, responder: BasicResponder(respond))
    }

    public func post(
        _ path: String = "",
        middleware: [Middleware] = [],
        responder: Responder) {
        addRoute(method: .post, path: path, middleware: middleware, responder: responder)
    }

    public func post<
        A: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, T) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, T) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, T) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, T) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }

    public func post<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        addRoute(method: .post, path: path, middleware: middleware, respond: respond)
    }
}

extension Routes {
    public func put(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: Respond) {
        put(path, middleware: middleware, responder: BasicResponder(respond))
    }

    public func put(
        _ path: String = "",
        middleware: [Middleware] = [],
        responder: Responder) {
        addRoute(method: .put, path: path, middleware: middleware, responder: responder)
    }

    public func put<
        A: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, T) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, T) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, T) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, T) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }

    public func put<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        addRoute(method: .put, path: path, middleware: middleware, respond: respond)
    }
}

extension Routes {
    public func patch(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: Respond) {
        patch(path, middleware: middleware, responder: BasicResponder(respond))
    }

    public func patch(
        _ path: String = "",
        middleware: [Middleware] = [],
        responder: Responder) {
        addRoute(method: .patch, path: path, middleware: middleware, responder: responder)
    }

    public func patch<
        A: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, T) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, T) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, T) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, T) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }

    public func patch<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        addRoute(method: .patch, path: path, middleware: middleware, respond: respond)
    }
}

extension Routes {
    public func delete(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: Respond) {
        delete(path, middleware: middleware, responder: BasicResponder(respond))
    }

    public func delete(
        _ path: String = "",
        middleware: [Middleware] = [],
        responder: Responder) {
        addRoute(method: .delete, path: path, middleware: middleware, responder: responder)
    }

    public func delete<
        A: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, T) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, T) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, T) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, T) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }

    public func delete<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        addRoute(method: .delete, path: path, middleware: middleware, respond: respond)
    }
}

extension Routes {
    public func options(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: Respond) {
        options(path, middleware: middleware, responder: BasicResponder(respond))
    }

    public func options(
        _ path: String = "",
        middleware: [Middleware] = [],
        responder: Responder) {
        addRoute(method: .options, path: path, middleware: middleware, responder: responder)
    }

    public func options<
        A: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, T) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, T) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, T) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, T) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }

    public func options<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        _ path: String = "",
        middleware: [Middleware] = [],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        addRoute(method: .options, path: path, middleware: middleware, respond: respond)
    }
}

extension Routes {
    public func methods(methods: Set<Method>, path: String, middleware: Middleware..., responder: Responder) {
        for method in methods {
            addRoute(method: method, path: path, middleware: middleware, responder: responder)
        }
    }

    public func methods(methods: Set<Method>, path: String, middleware: Middleware..., respond: Respond) {
        for method in methods {
            addRoute(method: method, path: path, middleware: middleware, responder: BasicResponder(respond))
        }
    }
}

extension Routes {
    public func fallback(_ path: String, middleware: Middleware..., responder: Responder) {
        addRouteFallback(path: path, middleware: middleware, responder: responder)
    }

    public func fallback(_ path: String, middleware: Middleware..., respond: Respond) {
        addRouteFallback(path: path, middleware: middleware, responder: BasicResponder(respond))
    }
}

extension Routes {
    public func addRoute<
        A: PathParameterInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 1)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 1
            )

            let a = try A(pathParameter: parameters[0])

            return try respond(request, a)
        }

        addRoute(method: method, path: path, middleware: middleware, responder: responder)
    }

    public func addRoute<
        A: PathParameterInitializable,
        B: PathParameterInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A, B) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 2)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 2
            )

            let a = try A(pathParameter: parameters[0])
            let b = try B(pathParameter: parameters[1])

            return try respond(request, a, b)
        }

        addRoute(method: method, path: path, middleware: middleware, responder: responder)
    }

    public func addRoute<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A, B, C) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 3)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 3
            )

            let a = try A(pathParameter: parameters[0])
            let b = try B(pathParameter: parameters[1])
            let c = try C(pathParameter: parameters[2])

            return try respond(request, a, b, c)
        }

        addRoute(method: method, path: path, middleware: middleware, responder: responder)
    }

    public func addRoute<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A, B, C, D) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 4)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 4
            )

            let a = try A(pathParameter: parameters[0])
            let b = try B(pathParameter: parameters[1])
            let c = try C(pathParameter: parameters[2])
            let d = try D(pathParameter: parameters[3])

            return try respond(request, a, b, c, d)
        }

        addRoute(method: method, path: path, middleware: middleware, responder: responder)
    }

    public func addRoute<
        T: StructuredDataInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (request: Request, content: T) throws -> Response) {
        let contentMapper = ContentMapperMiddleware(mappingTo: T.self)
        let responder = BasicResponder { request in
            guard let content = request.storage[T.key] as? T else {
                throw ClientError.badRequest
            }
            return try respond(request: request, content: content)
        }
        addRoute(method: method, path: path, middleware: [contentMapper] + middleware, responder: responder)
    }

    public func addRoute<
        A: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A, T) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 1)
        let contentMapper = ContentMapperMiddleware(mappingTo: T.self)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 1
            )

            let a = try A(pathParameter: parameters[0])

            guard let content = request.storage[T.key] as? T else {
                throw ClientError.badRequest
            }

            return try respond(request, a, content)
        }

        addRoute(method: method, path: path, middleware: [contentMapper] + middleware, responder: responder)
    }

    public func addRoute<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A, B, T) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 2)
        let contentMapper = ContentMapperMiddleware(mappingTo: T.self)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 2
            )

            let a = try A(pathParameter: parameters[0])
            let b = try B(pathParameter: parameters[1])
            guard let content = request.storage[T.key] as? T else {
                throw ClientError.badRequest
            }

            return try respond(request, a, b, content)
        }

        addRoute(method: method, path: path, middleware: [contentMapper] + middleware, responder: responder)
    }

    public func addRoute<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A, B, C, T) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 3)
        let contentMapper = ContentMapperMiddleware(mappingTo: T.self)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 3
            )

            let a = try A(pathParameter: parameters[0])
            let b = try B(pathParameter: parameters[1])
            let c = try C(pathParameter: parameters[2])

            guard let content = request.storage[T.key] as? T else {
                throw ClientError.badRequest
            }

            return try respond(request, a, b, c, content)
        }

        addRoute(method: method, path: path, middleware: [contentMapper] + middleware, responder: responder)
    }

    public func addRoute<
        A: PathParameterInitializable,
        B: PathParameterInitializable,
        C: PathParameterInitializable,
        D: PathParameterInitializable,
        T: StructuredDataInitializable
        >(
        method: Method,
        path: String,
        middleware: [Middleware],
        respond: (Request, A, B, C, D, T) throws -> Response) {
        let keys = parseParameterKeys(path: path, count: 4)
        let contentMapper = ContentMapperMiddleware(mappingTo: T.self)
        let responder = BasicResponder { request in
            let parameters = try self.parseParameters(
                keys: keys,
                pathParameters: request.pathParameters,
                count: 4
            )

            let a = try A(pathParameter: parameters[0])
            let b = try B(pathParameter: parameters[1])
            let c = try C(pathParameter: parameters[2])
            let d = try D(pathParameter: parameters[3])

            guard let content = request.storage[T.key] as? T else {
                throw ClientError.badRequest
            }

            return try respond(request, a, b, c, d, content)
        }

        addRoute(method: method, path: path, middleware: [contentMapper] + middleware, responder: responder)
    }

    private func parseParameters(keys: [String], pathParameters: [String: String], count: Int) throws -> [String] {
        //        Todo: Fix bug in TrieRouteMatcher https://github.com/Zewo/Zewo/issues/122
        guard pathParameters.count >= count else {
            throw ServerError.internalServerError
        }

        let parameters = keys.flatMap({ pathParameters[$0] })

        guard parameters.count == count else {
            throw ServerError.internalServerError
        }

        return parameters
    }

    // Todo: if there are repeated identifiers call malformedRoute
    private func parseParameterKeys(path: String, count: Int) -> [String] {
        let split = path.characters
            .split(separator: "/")
            .map(String.init)
        let keys = split
            .map({ $0.characters })
            .filter({ $0.first == ":" })
            .map({ $0.dropFirst() })
            .map({ String($0) })

        if keys.count != count {
            let message = "Invalid route \"\(path)\". The number of path parameters doesn't match the number of strong typed parameters in the route"
            malformedRoute(message: message)
        }

        return keys
    }

    private func malformedRoute(message: String) {
        fatalError("Error: \(message)")
    }
}

extension Routes {
    public func addRouteFallback(path: String, middleware: [Middleware], responder: Responder) {
        let fallback = middleware.chain(to: responder)
        let routePath = path

        if let route = route(for: routePath) {
            route.fallback = fallback
        } else {
            let route = BasicRoute(path: routePath, fallback: fallback)
            routes.append(route)
        }
    }

    public func addRoute(method: Method, path: String, middleware: [Middleware], responder: Responder) {
        let action = middleware.chain(to: responder)
        let routePath = path

        if let route = route(for: routePath) {
            route.addAction(method: method, action: action)
        } else {
            let route = BasicRoute(path: routePath, actions: [method: action], fallback: self.fallback)
            routes.append(route)
        }
    }

    private func route(for path: String) -> BasicRoute? {
        for route in routes where route.path == path {
            return route as? BasicRoute
        }
        return nil
    }
}
