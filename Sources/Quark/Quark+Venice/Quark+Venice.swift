extension Server {
    public init(host: String = "0.0.0.0", port: Int = 8080, reusePort: Bool = false, parser: S4.RequestParser.Type = RequestParser.self, serializer: S4.ResponseSerializer.Type = ResponseSerializer.self, middleware: Middleware..., responder: Responder) throws {
        try self.init(
            server: try TCPServer(host: host, port: port, reusePort: reusePort),
            port: port,
            parser: parser,
            serializer: serializer,
            middleware: middleware,
            responder: responder
        )
    }

    public init(_ responder: Responder) throws {
        try self.init(responder: responder)
    }

    public init(_ responder: ResponderRepresentable) throws {
        try self.init(responder: responder.responder)
    }

    public func start(_ failure: (ErrorProtocol) -> Void = Server.log) throws {
        printHeader()
        while true {
            let stream = try server.accept(timingOut: .never)
            co { do { try self.process(stream: stream) } catch { failure(error) } }
        }
    }

    public func startInBackground(_ failure: (ErrorProtocol) -> Void = Server.log) {
        co { do { try self.start() } catch { failure(error) } }
    }
}

extension Request {
    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], filePath: String) throws {
        try self.init(method: method, uri: uri, headers: headers, filePath: filePath, file: File.self)
    }
}

extension Response {
    public init(status: Status = .ok, headers: Headers = [:], filePath: String) throws {
        try self.init(status: status, headers: headers, filePath: filePath, file: File.self)
    }
}

extension FileResponder {
    public init(path: String, headers: Headers = [:]) {
        self.init(path: path, headers: headers, file: File.self)
    }
}

// Warning: Due to a swift bug this has to be in the same file the protocol is declared
// When we split Venice from Quark this will have to be uncommented

// extension Resource {
//     public var file: FileProtocol.Type {
//         return File.self
//     }
// }
