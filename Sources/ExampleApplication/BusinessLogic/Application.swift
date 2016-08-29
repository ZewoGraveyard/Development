public struct Application {
    public let store: Store
    public let todoController: TodoController

    public init(store: Store) {
        self.store = store
        self.todoController = TodoController(store: store)
    }

    public func signIn(email: String, password: String) throws -> String {
        let user = try store.fetchUser(email: email)
        if user.model.password != password {
            throw HTTPError.badRequest
        }
        return user.id
    }

    public func signUp(email: String, password: String) throws -> String {
        let user = User(email: email, password: password)
        return try store.users.save(user).id
    }
}

public protocol Store {
    var todos: Repository<Todo> { get }
    var users: Repository<User> { get }
    func fetchUser(email: String) throws -> Record<User>
    func fetchDoneTodos() throws -> [Record<Todo>]
}
