public protocol Server {
    init(host: String, port: Int, responder: Responder) throws
    func start() throws
}

extension Server {
    public init(port: Int, responder: Responder) throws {
        try self.init(host: "0.0.0.0", port: port, responder: responder)
    }
}
