struct TodoResource : Resource {
    let controller: TodoController

    func list() throws -> Response {
        let todos = try controller.list()
        return try Response(content: todos)
    }

    func create(content todo: Todo) throws -> Response {
        let (_, todo) = try controller.create(model: todo)
        return try Response(content: todo)
    }

    func detail(id: String) throws -> Response {
        let todo = try controller.detail(id: id)
        return try Response(content: todo)
    }

    func update(id: String, content todo: Todo) throws -> Response {
        let todo = try controller.update(id: id, model: todo)
        return try Response(content: todo)
    }

    func destroy(id: String) throws -> Response {
        let todo = try controller.destroy(id: id)
        return try Response(content: todo)
    }

    func custom(routes: ResourceRoutes) {
        routes.get("/done") { _ in
            let todos = try self.controller.listDone()
            return try Response(content: todos)
        }
    }
}
