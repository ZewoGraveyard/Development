extension Todo : UniquelyIdentifiable {
    public var uniqueIdentifier: String? {
        get { return id }
        set { id = newValue }
    }
}

public final class InMemoryStore : Store {
    public var todos: Entity<Todo>
    public var user: SingularEntity<User>

    public init() {
        todos = Entity(InMemoryEntity<Todo>())
        user = SingularEntity(InMemorySingularEntity<User>())
    }
}
