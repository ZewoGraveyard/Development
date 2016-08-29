public struct TodoController {
    let store: Store

    public var repository: Repository<Todo> {
        return store.todos
    }

    public func list() throws -> [Todo] {
        return try repository.fetchAll().map({ $0.model })
    }

    public func listDone() throws -> [Todo] {
        return try store.fetchDoneTodos().map({ $0.model })
    }

    public func create(model todo: Todo) throws -> (String, Todo) {
        let record = try repository.save(todo)
        return (record.id, record.model)
    }

    public func detail(id: String) throws -> Todo {
        return try repository.fetch(id: id).model
    }

    public func update(id: String, model todo: Todo) throws -> Todo {
        return try repository.update(id: id, model: todo).model
    }

    public func destroy(id: String) throws -> Todo {
        return try repository.remove(id: id).model
    }
}
