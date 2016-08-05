public struct TodoController : Controller {
    let store: Store

    public var repository: Repository<Todo> {
        return store.todos
    }

    public func list() throws -> [Todo] {
        return try self.super.list()
    }

    public func listDone() throws -> [Todo] {
        return try store.fetchDoneTodos().map({ $0.model })
    }

    public func create(model todo: Todo) throws -> (String, Todo) {
        return try self.super.create(model: todo)
    }

    public func detail(id: String) throws -> Todo {
        return try self.super.detail(id: id)
    }

    public func update(id: String, model todo: Todo) throws -> Todo {
        return try self.super.update(id: id, model: todo)
    }

    public func destroy(id: String) throws -> Todo {
        return try self.super.destroy(id: id)
    }
}
