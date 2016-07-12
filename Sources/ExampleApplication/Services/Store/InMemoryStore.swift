public final class InMemoryStore : Store {
    public let todos: Repository<Todo> = Repository(InMemoryRepository())
    public let users: Repository<User> = Repository(InMemoryRepository())

    public func fetchAllDoneTodos() throws -> [Record<Todo>] {
        return try todos.fetchAll().filter({ $0.model.done })
    }
}
