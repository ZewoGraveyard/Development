// Glue between business logic and web

import Quark

extension TodoController : Controller {}

struct TodoResource : Resource {
    let controller: TodoController

    func build(resource: ResourceBuilder) {
        resource.get(
            "/done",
            action: controller.listDone,
            render: renderListDone,
            view: "list-done.html"
        )
    }

    func renderListDone(input: [Todo]) throws -> [String] {
        return input.map({$0.title})
    }
}

struct TodoRouter : Router {
    let todos: TodoResource

    init(app: TodoApplication) {
        todos = TodoResource(controller: app.todoController)
    }

    func build(router: RouterBuilder) {
        router.compose("/todos", resource: todos)
    }
}
