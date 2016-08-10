public protocol AsyncConnection : AsyncStream {
    func open(deadline: Double, completion: ((Void) throws -> AsyncConnection) -> Void) throws
}

extension AsyncConnection {
    public func open(completion: ((Void) throws -> AsyncConnection) -> Void) throws {
        try open(deadline: .never, completion: completion)
    }
}
