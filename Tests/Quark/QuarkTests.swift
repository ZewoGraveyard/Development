import XCTest
@testable import Quark

// TodoDomain

public struct Todo {
    public var id: String?
    public let title: String
    public let done: Bool

    public init(id: String?, title: String, done: Bool) {
        self.id = id
        self.title = title
        self.done = done
    }
}

public struct User {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

// TodoApplication

public struct TodoApplication {
    public let todoController: TodoController
    public let userController: UserController

    public init(store: Store) {
        todoController = TodoController(store: store)
        userController = UserController(store: store)
    }
}

public protocol Store {
    func getAllTodos() throws -> [Todo]
    func save(todo: Todo) throws -> Todo
    func get(todoWithID: String) throws -> Todo
    func update(todoWithID: String, todo: Todo) throws -> Todo
    func remove(todoWithID: String) throws

    func getUser() throws -> User
    func save(user: User) throws -> User
    func update(user: User) throws -> User
    func removeUser() throws
}

public struct TodoController {
    let store: Store

    public func list() throws -> [Todo] {
        return try store.getAllTodos()
    }

    public func listDone() throws -> [Todo] {
        return try store.getAllTodos().filter({$0.done})
    }

    public func create(element todo: Todo) throws -> Todo {
        return try store.save(todo: todo)
    }

    public func detail(id: String) throws -> Todo {
        return try store.get(todoWithID: id)
    }

    public func update(id: String, element todo: Todo) throws -> Todo {
        return try store.update(todoWithID: id, todo: todo)
    }

    public func destroy(id: String) throws {
        try store.remove(todoWithID: id)
    }
}

public struct UserController {
    let store: Store

    public func create(element user: User) throws -> User {
        return try store.save(user: user)
    }

    public func detail() throws -> User {
        return try store.getUser()
    }

    public func update(element user: User) throws -> User {
        return try store.update(user: user)
    }

    public func destroy() throws {
        try store.removeUser()
    }
}

// TodoMapping

extension Todo : ResourceConvertible {}
extension User : ResourceConvertible {}

// TodoWeb

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

extension UserController : SingularController {}

struct UserResource : SingularResource {
    let controller: UserController
}

public struct TodoRouter : Router {
    let todos: TodoResource
    let user: UserResource

    public init(app: TodoApplication) {
        todos = TodoResource(controller: app.todoController)
        user = UserResource(controller: app.userController)
    }

    public func build(router: RouterBuilder) {
        router.compose("/todos", resource: todos)
        router.compose("/user", resource: user)
    }
}

// TodoServer

func start() throws {
    let store = TodoInMemoryStore()
    let app = TodoApplication(store: store)
    let router = TodoRouter(app: app)
    
    try Server(router).start()
}

class QuarkTests: XCTestCase {
    func testExample() {
        try! start()
    }

    static var allTests : [(String, (QuarkTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

// TodoStore

extension Todo : UniquelyIdentifiable {
    public var uniqueIdentifier: String? {
        get { return id }
        set { id = newValue }
    }
}

public final class TodoInMemoryStore : Store {
    var todos = InMemoryStore<Todo>()
    var user: User?

    public init() {}

    public func getAllTodos() throws -> [Todo] {
        return try todos.getAll()
    }

    public func save(todo: Todo) throws -> Todo {
        return try todos.save(todo)
    }

    public func get(todoWithID id: String) throws -> Todo {
        return try todos.get(id: id)
    }

    public func update(todoWithID id: String, todo: Todo) throws -> Todo {
        return try todos.update(id: id, element: todo)
    }

    public func remove(todoWithID id: String) throws {
        try todos.remove(id: id)
    }



    public func getUser() throws -> User {
        guard let user = user else {
            throw ClientError.notFound
        }
        return user
    }

    public func save(user: User) throws -> User {
        self.user = user
        return user
    }

    public func update(user: User) throws -> User {
        self.user = user
        return user
    }

    public func removeUser() throws {
        guard user != nil else {
            throw ClientError.notFound
        }
        self.user = nil
    }
}

public protocol UniquelyIdentifiable {
    var uniqueIdentifier: String? { get set }
}

public final class InMemoryStore<T: UniquelyIdentifiable> {
    var store: [T] = []

    public init() {}

    public func getAll() throws -> [T] {
        return store
    }

    public func save(_ element :T) throws -> T {
        var element = element
        element.uniqueIdentifier = "\(store.count)"
        store.append(element)
        return element
    }

    public func get(id: String) throws -> T {
        let i = try index(id: id)
        return store[i]
    }

    public func update(id: String, element: T) throws -> T {
        let i = try index(id: id)
        if id != element.uniqueIdentifier {
            throw ClientError.notFound
        }
        store[i] = element
        return element
    }

    public func remove(id: String) throws {
        let i = try index(id: id)
        store.remove(at: i)
    }

    private func index(id: String) throws -> Int {
        guard let index = Int(id) where index >= 0 && index < store.count else {
            throw ClientError.notFound
        }
        return index
    }
}
