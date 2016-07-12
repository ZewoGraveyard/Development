public struct Router : MainRouter {
    let todos: TodoResource
    let users: UserResource

    public init(app: Application) {
        todos = TodoResource(controller: app.todoController)
        users = UserResource(controller: app.userController)
    }

    public func build(router: RouterBuilder) {
        router.compose("/todos", resource: todos)
        router.compose("/users", resource: users)
    }
}
