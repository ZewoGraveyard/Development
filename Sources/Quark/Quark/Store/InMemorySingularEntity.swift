public final class InMemorySingularEntity<Element> : SingularEntityProtocol {
    private var element: Element?

    public init() {}

    public func get() throws -> Element {
        guard let element = element else {
            throw ClientError.notFound
        }
        return element
    }

    public func save(_ element: Element) throws -> Element {
        self.element = element
        return element
    }

    public func update(_ element: Element) throws -> Element {
        self.element = element
        return element
    }

    public func remove() throws {
        guard element != nil else {
            throw ClientError.notFound
        }
        self.element = nil
    }
}
