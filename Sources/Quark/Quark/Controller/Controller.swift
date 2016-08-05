public protocol Controller {
    associatedtype Model
    var repository: Repository<Model> { get }

    func list() throws -> [Model]
    func create(model: Model) throws -> (String, Model)
    func detail(id: String) throws -> Model
    func update(id: String, model: Model) throws -> Model
    func destroy(id: String) throws -> Model
}

public extension Controller {
    var `super`: DefaultController<Model> {
        return DefaultController(repository: self.repository)
    }

    func list() throws -> [Model] {
        return try self.super.list()
    }

    func create(model: Model) throws -> (String, Model) {
        return try self.super.create(model: model)
    }

    func detail(id: String) throws -> Model {
        return try self.super.detail(id: id)
    }

    func update(id: String, model: Model) throws -> Model {
        return try self.super.update(id: id, model: model)
    }

    func destroy(id: String) throws -> Model {
        return try self.super.destroy(id: id)
    }
}

public struct DefaultController<M> : Controller {
    public typealias Model = M
    public let repository: Repository<Model>

    public func list() throws -> [Model] {
        return try repository.fetchAll().map { $0.model }
    }

    public func create(model: Model) throws -> (String, Model) {
        let record = try repository.save(model)
        return (record.id, record.model)
    }

    public func detail(id: String) throws -> Model {
        return try repository.fetch(id: id).model
    }

    public func update(id: String, model: Model) throws -> Model {
        return try repository.update(id: id, model: model).model
    }

    public func destroy(id: String) throws -> Model {
        return try repository.remove(id: id).model
    }
}
