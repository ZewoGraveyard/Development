public final class InMemoryRepository<Model> : RepositoryProtocol {
    var store: [String: Model] = [:]

    var count = 0

    func nextId() -> String {
        defer { count += 1 }
        return String(count)
    }

    public init() {}

    public func fetchAll() throws -> [Record<Model>] {
        var elements: [Record<Model>] = []
        for (id, model) in store {
            elements.append(Record(id: id, model: model))
        }
        return elements
    }

    public func fetch(id: String) throws -> Record<Model> {
        guard let model = store[id] else {
            throw ClientError.notFound
        }
        return Record(id: id, model: model)
    }

    public func save(_ model: Model) throws -> Record<Model> {
        let element = Record(id: nextId(), model: model)
        store[element.id] = model
        return element
    }

    public func update(id: String, model: Model) throws -> Record<Model> {
        if store[id] == nil {
            throw ClientError.notFound
        }
        let element = Record(id: id, model: model)
        store[id] = model
        return element
    }

    public func remove(id: String) throws -> Record<Model> {
        guard let model = store[id] else {
            throw ClientError.notFound
        }
        store[id] = nil
        return Record(id: id, model: model)
    }
}
