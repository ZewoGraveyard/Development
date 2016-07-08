public struct Application {
    public let todoController: TodoController
    public let userController: UserController

    public init(store: Store) {
        todoController = TodoController(store: store)
        userController = UserController(store: store)
    }
}

public protocol Store {
    var todos: Entity<Todo> { get }
    var user: SingularEntity<User> { get }
}
