public protocol SingularEntityProtocol {
    associatedtype Element
    func get() throws -> Element
    func save(_ element: Element) throws -> Element
    func update(_ element: Element) throws -> Element
    func remove() throws
}

class SingularEntityBoxBase<Element> : SingularEntityProtocol {
    func get() throws -> Element {
        fatalError()
    }

    func save(_ element: Element) throws -> Element {
        fatalError()
    }

    func update(_ element: Element) throws -> Element {
        fatalError()
    }

    func remove() throws {
        fatalError()
    }
}

class SingularEntityBox<E : SingularEntityProtocol> : SingularEntityBoxBase<E.Element> {
    private let base: E

    init(_ base: E) {
        self.base = base
    }

    override func get() throws -> E.Element {
        return try base.get()
    }

    override func save(_ element: E.Element) throws -> E.Element {
        return try base.save(element)
    }

    override func update(_ element: E.Element) throws -> E.Element {
        return try base.update(element)
    }

    override func remove() throws {
        return try base.remove()
    }
}

public final class SingularEntity<Element> : SingularEntityProtocol {
    private let box: SingularEntityBoxBase<Element>

    public init<E: SingularEntityProtocol where E.Element == Element>(_ base: E) {
        self.box = SingularEntityBox(base)
    }

    public func get() throws -> Element {
        return try box.get()
    }

    public func save(_ element: Element) throws -> Element {
        return try box.save(element)
    }

    public func update(_ element: Element) throws -> Element {
        return try box.update(element)
    }

    public func remove() throws {
        return try box.remove()
    }
}
