public struct TodoController : Controller {
    let store: Store

    public func list() throws -> [Todo] {
        return try store.todos.getAll()
    }

    public func listDone() throws -> [Todo] {
        return try store.todos.getAll().filter({$0.done})
    }

    public func create(element todo: Todo) throws -> Todo {
        return try store.todos.save(todo)
    }

    public func detail(id: String) throws -> Todo {
        return try store.todos.get(id: id)
    }

    public func update(id: String, element todo: Todo) throws -> Todo {
        return try store.todos.update(id: id, element: todo)
    }

    public func destroy(id: String) throws {
        try store.todos.remove(id: id)
    }
}
