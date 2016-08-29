public protocol RepositoryProtocol {
    associatedtype Model
    func fetchAll() throws -> [Record<Model>]
    func fetch(id: String) throws -> Record<Model>
    func save(_ model: Model) throws -> Record<Model>
    func update(id: String, model: Model) throws -> Record<Model>
    func remove(id: String) throws -> Record<Model>
}

public final class Repository<Model> : RepositoryProtocol {
    private let erasedFetchAll: (Void) throws -> [Record<Model>]
    private let erasedFetch: (_ id: String) throws -> Record<Model>
    private let erasedSave: (Model) throws -> Record<Model>
    private let erasedUpdate: (_ id: String, _ model: Model) throws -> Record<Model>
    private let erasedRemove: (_ id: String) throws -> Record<Model>

    public init<R: RepositoryProtocol>(_ record: R) where R.Model == Model {
        self.erasedFetchAll = record.fetchAll
        self.erasedFetch = record.fetch
        self.erasedSave = record.save
        self.erasedUpdate = record.update
        self.erasedRemove = record.remove
    }

    public func fetchAll() throws -> [Record<Model>] {
        return try erasedFetchAll()
    }

    public func fetch(id: String) throws -> Record<Model> {
        return try erasedFetch(id)
    }

    public func save(_ model: Model) throws -> Record<Model> {
        return try erasedSave(model)
    }

    public func update(id: String, model: Model) throws -> Record<Model> {
        return try erasedUpdate(id, model)
    }

    public func remove(id: String) throws -> Record<Model> {
        return try erasedRemove(id)
    }
}
