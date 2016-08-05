public typealias MainRouter = Router

public protocol Router : RouterRepresentable {
    var staticFilesPath: String { get }
    var fileType: C7.File.Type { get }
    var middleware: [Middleware] { get }

    func recover(error: ErrorProtocol) throws -> Response
    func custom(routes: Routes)
}

// Warning: This is here due to a compiler bug.
// This will have to be deleted once we split Venice from Quark

extension Router {
    public var fileType: C7.File.Type {
        return File.self
    }
}

extension Router {
    public var staticFilesPath: String {
        return "Public"
    }

    public var middleware: [Middleware] {
        return []
    }

    public func recover(error: ErrorProtocol) throws -> Response {
        return try RecoveryMiddleware.recover(error: error)
    }

    public func custom(routes: Routes) {}
}

extension Router {
    public var router: RouterProtocol {
        let routes = Routes(staticFilesPath: staticFilesPath, fileType: fileType)
        custom(routes: routes)
        return BasicRouter(recover: recover, middleware: middleware, routes: routes)
    }
}
