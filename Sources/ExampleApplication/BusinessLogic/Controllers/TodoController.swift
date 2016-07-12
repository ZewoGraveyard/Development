public struct TodoController : Controller {
    let store: Store

    public func list() throws -> [Todo] {
        return try store.todos.fetchAll().map({ $0.model })
    }

    public func listDone() throws -> [Todo] {
        return try store.fetchAllDoneTodos().map({ $0.model })
    }

    public func create(_ todo: Todo) throws -> Todo {
        return try store.todos.save(todo).model
    }

    public func detail(id: String) throws -> Todo {
        return try store.todos.fetch(id: id).model
    }

    public func update(id: String, _ todo: Todo) throws -> Todo {
        return try store.todos.update(id: id, model: todo).model
    }

    public func destroy(id: String) throws -> Todo {
        return try store.todos.remove(id: id).model
    }
}
