public protocol AsyncHost {
    func accept(deadline: Double, completion: ((Void) throws -> AsyncStream) -> Void)
}

extension AsyncHost {
    public func accept(completion: ((Void) throws -> AsyncStream) -> Void) {
        accept(deadline: .never, completion: completion)
    }
}
