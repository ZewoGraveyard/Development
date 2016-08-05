public protocol AsyncServer {
    init(host: String, port: Int, responder: AsyncResponder) throws
    func start() throws
}

extension AsyncServer {
    public init(port: Int, responder: AsyncResponder) throws {
        try self.init(host: "0.0.0.0", port: port, responder: responder)
    }
}
