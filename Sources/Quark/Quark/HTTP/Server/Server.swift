public struct Server {
    public let host: Host
    public let port: Int
    public let parser: S4.RequestParser.Type
    public let serializer: S4.ResponseSerializer.Type
    public let middleware: [Middleware]
    public let responder: Responder
    public let failure: (Error) -> Void

    public let bufferSize: Int = 2048

    public init(
        host: Host,
        port: Int,
        parser: S4.RequestParser.Type,
        serializer: S4.ResponseSerializer.Type,
        middleware: [Middleware],
        responder: Responder,
        failure: @escaping (Error) -> Void
        ) throws {
        self.host = host
        self.port = port
        self.parser = parser
        self.serializer = serializer
        self.middleware = middleware
        self.responder = responder
        self.failure = failure
    }
}

extension Server {
    public func process(stream: Stream) throws {
        let parser = self.parser.init(stream: stream)
        let serializer = self.serializer.init(stream: stream)

        while !stream.closed {
            do {
                let request = try parser.parse()
                let response = try middleware.chain(to: responder).respond(to: request)
                try serializer.serialize(response)

                if let upgrade = response.upgradeConnection {
                    try upgrade(request, stream)
                    try stream.close()
                }

                if !request.isKeepAlive {
                    try stream.close()
                }
            } catch SystemError.brokenPipe {
                break
            } catch {
                if stream.closed {
                    break
                }

                let (response, unrecoveredError) = Server.recover(error: error)
                try serializer.serialize(response)

                if let error = unrecoveredError {
                    throw error
                }
            }
        }
    }

    private static func recover(error: Error) -> (Response, Error?) {
        switch error {
        case let error as HTTPError:
            return (Response(status: error.status), nil)
        default:
            return (Response(status: .internalServerError), error)
        }
    }

    public static func logError(error: Error) -> Void {
        print("Error: \(error)")
    }

    public func printHeader() {
        var header = "\n"
        header += "\n"
        header += "\n"
        header += "                             _____\n"
        header += "     ,.-``-._.-``-.,        /__  /  ___ _      ______\n"
        header += "    |`-._,.-`-.,_.-`|         / /  / _ \\ | /| / / __ \\\n"
        header += "    |   |ˆ-. .-`|   |        / /__/  __/ |/ |/ / /_/ /\n"
        header += "    `-.,|   |   |,.-`       /____/\\___/|__/|__/\\____/ (c)\n"
        header += "        `-.,|,.-`           -----------------------------\n"
        header += "\n"
        header += "================================================================================\n"
        header += "Started HTTP server, listening on port \(port)."
        print(header)
    }
}
