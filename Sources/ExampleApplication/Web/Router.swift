// This is where you configure your routes

public struct Router : MainRouter {
    let todos: TodoResource
    let user: UserResource

    public init(app: Application) {
        todos = TodoResource(controller: app.todoController)
        user = UserResource(controller: app.userController)
    }

    public func build(router: RouterBuilder) {
        router.compose("/todos", resource: todos)
        router.compose("/user", resource: user)
    }
}
