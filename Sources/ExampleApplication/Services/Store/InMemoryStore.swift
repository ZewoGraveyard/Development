public final class InMemoryStore : Store {
    public let todos: Repository<Todo> = Repository(InMemoryRepository())
    public let users: Repository<User> = Repository(InMemoryRepository())

    public func fetchUser(email: String) throws -> Record<User> {
        guard let user = try users.fetchAll().filter({ $0.model.email == email }).first else {
            throw HTTPError.notFound
        }
        return user
    }

    public func fetchDoneTodos() throws -> [Record<Todo>] {
        return try todos.fetchAll().filter({ $0.model.done })
    }
}
