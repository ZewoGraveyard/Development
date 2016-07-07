// Pure business logic

struct TodoApplication {
    let todoController: TodoController

    init(store: Store) {
        todoController = TodoController(store: store)
    }
}

// TODO: Provide an AnyStore<T> service to kill this boilerplate
protocol Store {
    func getAllTodos() throws -> [Todo]
    func save(todo: Todo) throws -> Todo
    func get(todoWithID: String) throws -> Todo
    func update(todoWithID: String, todo: Todo) throws -> Todo
    func remove(todoWithID: String) throws
}

// TODO: Provide a CRUDController<T> service to kill this boilerplate
struct TodoController {
    let store: Store

    func list() throws -> [Todo] {
        return try store.getAllTodos()
    }

    func listDone() throws -> [Todo] {
        return try store.getAllTodos().filter({$0.done})
    }

    func create(element todo: Todo) throws -> Todo {
        return try store.save(todo: todo)
    }

    func detail(id: String) throws -> Todo {
        return try store.get(todoWithID: id)
    }

    func update(id: String, element todo: Todo) throws -> Todo {
        return try store.update(todoWithID: id, todo: todo)
    }

    func destroy(id: String) throws {
        try store.remove(todoWithID: id)
    }
}
