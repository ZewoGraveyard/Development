public protocol UniquelyIdentifiable {
    var uniqueIdentifier: String? { get set }
}

public protocol EntityProtocol {
    associatedtype Element : UniquelyIdentifiable
    func getAll() throws -> [Element]
    func save(_ element: Element) throws -> Element
    func get(id: String) throws -> Element
    func update(id: String, element: Element) throws -> Element
    func remove(id: String) throws
}

class EntityBoxBase<Element : UniquelyIdentifiable> : EntityProtocol {
    func getAll() throws -> [Element] {
        fatalError()
    }

    func save(_ element: Element) throws -> Element {
        fatalError()
    }

    func get(id: String) throws -> Element {
        fatalError()
    }

    func update(id: String, element: Element) throws -> Element {
        fatalError()
    }

    func remove(id: String) throws {
        fatalError()
    }
}

class EntityBox<E : EntityProtocol> : EntityBoxBase<E.Element> {
    private let base: E

    init(_ base: E) {
        self.base = base
    }

    override func getAll() throws -> [E.Element] {
        return try base.getAll()
    }

    override func save(_ element: E.Element) throws -> E.Element {
        return try base.save(element)
    }

    override func get(id: String) throws -> E.Element {
        return try base.get(id: id)
    }

    override func update(id: String, element: E.Element) throws -> E.Element {
        return try base.update(id: id, element: element)
    }

    override func remove(id: String) throws {
        return try base.remove(id: id)
    }
}

public final class Entity<Element : UniquelyIdentifiable> : EntityProtocol {
    private let box: EntityBoxBase<Element>

    public init<E: EntityProtocol where E.Element == Element>(_ base: E) {
        self.box = EntityBox(base)
    }

    public func getAll() throws -> [Element] {
        return try box.getAll()
    }

    public func save(_ element: Element) throws -> Element {
        return try box.save(element)
    }

    public func get(id: String) throws -> Element {
        return try box.get(id: id)
    }

    public func update(id: String, element: Element) throws -> Element {
        return try box.update(id: id, element: element)
    }

    public func remove(id: String) throws {
        return try box.remove(id: id)
    }
}
