public protocol CRUDController : Controller {
    associatedtype Model
    var repository: Repository<Model> { get }

    func list() throws -> [Model]
    func create(_ model: Model) throws -> Model
    func detail(id: String) throws -> Model
    func update(id: String, _ model: Model) throws -> Model
    func destroy(id: String) throws -> Model
}

public extension CRUDController {
    var `default`: DefaultCRUDController<Model> {
        return DefaultCRUDController(repository: self.repository)
    }

    func list() throws -> [Model] {
        return try self.default.list()
    }

    func create(model: Model) throws -> Model {
        return try self.default.create(model: model)
    }

    func detail(id: String) throws -> Model {
        return try self.default.detail(id: id)
    }

    func update(id: String, model: Model) throws -> Model {
        return try self.default.update(id: id, model: model)
    }

    func destroy(id: String) throws -> Model {
        return try self.default.destroy(id: id)
    }
}

public struct DefaultCRUDController<M where M : StructuredDataInitializable, M : StructuredDataFallibleRepresentable> : CRUDController {
    public typealias Model = M
    public let repository: Repository<Model>

    public func list() throws -> [Model] {
        return try repository.fetchAll().map { $0.model }
    }

    public func create(model: Model) throws -> Model {
        return try repository.save(model).model
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
