public protocol Connection : Stream {
    func open(deadline: Double) throws
}

extension Connection {
    public func open() throws {
        try open(deadline: .never)
    }
}
