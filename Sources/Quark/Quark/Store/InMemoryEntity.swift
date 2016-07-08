public final class InMemoryEntity<Element : UniquelyIdentifiable> : EntityProtocol {
    var store: [String: Element] = [:]

    var count = 0

    func newIdentifier() -> String {
        let id = "\(count)"
        count += 1
        return id
    }

    public init() {}

    public func getAll() throws -> [Element] {
        return Array(store.values)
    }

    public func save(_ element: Element) throws -> Element {
        var element = element
        let uniqueIdentifier = newIdentifier()
        element.uniqueIdentifier = uniqueIdentifier
        store[uniqueIdentifier] = element
        return element
    }

    public func get(id: String) throws -> Element {
        guard let element = store[id] else {
            throw ClientError.notFound
        }
        return element
    }

    public func update(id: String, element: Element) throws -> Element {
        var element = element
        if store[id] == nil {
            throw ClientError.notFound
        }
        element.uniqueIdentifier = id
        store[id] = element
        return element
    }

    public func remove(id: String) throws {
        if store[id] == nil {
            throw ClientError.notFound
        }
        store[id] = nil
    }
}
