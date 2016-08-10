extension Server {
    public init(host: String = "0.0.0.0", port: Int = 8080, reusePort: Bool = false, parser: S4.RequestParser.Type = RequestParser.self, serializer: S4.ResponseSerializer.Type = ResponseSerializer.self, middleware: [Middleware], responder: Responder, failure: @escaping (Error) -> Void = Server.logError) throws {
        try self.init(
            host: try TCPHost(host: host, port: port, backlog: 128, reusePort: reusePort),
            port: port,
            parser: parser,
            serializer: serializer,
            middleware: middleware,
            responder: responder,
            failure: failure
        )
    }

    public func start() throws {
        printHeader()
        while true {
            let stream = try host.accept()
            co { do { try self.process(stream: stream) } catch { self.failure(error) } }
        }
    }

    public func startInBackground() {
        co { do { try self.start() } catch { self.failure(error) } }
    }
}

extension Server : ConfigurableServer {
    public init(middleware: [Middleware], responder: Responder, configuration: Map) throws {
        let host = configuration["server", "host"]?.asString ?? "127.0.0.1"
        let port = configuration["server", "port"]?.asInt ?? 8080
        let reusePort = configuration["server", "reusePort"]?.asBool ?? false

        try self.init(
            host: host,
            port: port,
            reusePort: reusePort,
            middleware: middleware,
            responder: responder
        )
    }
}

public func configure<AppConfiguration : Configuration>(configurationFile: String = "Configuration.swift", arguments: [String] = CommandLine.arguments, configuration: (AppConfiguration) throws -> ResponderRepresentable) {
    configure(configurationFile: configurationFile, arguments: arguments, server: Server.self, configuration: configuration)
}

extension FileResponder {
    public init(path: String, headers: Headers = [:]) {
        self.init(path: path, headers: headers, fileType: File.self)
    }
}

extension Request {
    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], filePath: String) throws {
        try self.init(method: method, uri: uri, headers: headers, filePath: filePath, fileType: File.self)
    }
}

extension Response {
    public init(status: Status = .ok, headers: Headers = [:], filePath: String) throws {
        try self.init(status: status, headers: headers, filePath: filePath, fileType: File.self)
    }
}

extension BasicRouter {
    public init(recover: Recover = RecoveryMiddleware.recover, staticFilesPath: String = "Public", middleware: [Middleware] = [], routes: (Routes) -> Void) {
        self.init(recover: recover, staticFilesPath: staticFilesPath, fileType: File.self, middleware: middleware, routes: routes)
    }
}

extension BasicResource {
    public init(recover: Recover = RecoveryMiddleware.recover, staticFilesPath: String = "Public", middleware: [Middleware] = [], routes: (ResourceRoutes) -> Void) {
        self.init(recover: recover, staticFilesPath: staticFilesPath, fileType: File.self, middleware: middleware, routes: routes)
    }
}

// Warning: Due to a swift bug this has to be in the same file the protocol is declared
// When we split Venice from Quark this will have to be uncommented

// extension Resource {
//     public var file: C7.File.Type {
//         return File.self
//     }
// }
//
// extension Router {
//     public var file: C7.File.Type {
//         return File.self
//     }
// }
