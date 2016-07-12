public struct Application {
    public let todoController: TodoController
    public let userController: UserController

    public init(store: Store) {
        todoController = TodoController(store: store)
        userController = UserController(store: store)
    }
}

public protocol Store {
    var todos: Repository<Todo> { get }
    var users: Repository<User> { get }
    func fetchAllDoneTodos() throws -> [Record<Todo>]
}
