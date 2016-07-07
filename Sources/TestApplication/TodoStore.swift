// Storage

import Quark

// TODO: Move this to TodoMapping?
extension Todo : UniquelyIdentifiable {
    var uniqueIdentifier: String? {
        get { return id }
        set { id = newValue }
    }
}

// TODO: Kill this boilerplate
final class TodoInMemoryStore : Store {
    var todos = InMemoryStore<Todo>()

    func getAllTodos() throws -> [Todo] {
        return try todos.getAll()
    }

    func save(todo: Todo) throws -> Todo {
        return try todos.save(todo)
    }

    func get(todoWithID id: String) throws -> Todo {
        return try todos.get(id: id)
    }

    func update(todoWithID id: String, todo: Todo) throws -> Todo {
        return try todos.update(id: id, element: todo)
    }

    func remove(todoWithID id: String) throws {
        try todos.remove(id: id)
    }
}

// TODO: Move this to Quark
protocol UniquelyIdentifiable {
    var uniqueIdentifier: String? { get set }
}

final class InMemoryStore<T: UniquelyIdentifiable> {
    var store: [T] = []

    func getAll() throws -> [T] {
        return store
    }

    func save(_ element :T) throws -> T {
        var element = element
        element.uniqueIdentifier = "\(store.count)"
        store.append(element)
        return element
    }

    func get(id: String) throws -> T {
        let i = try index(id: id)
        return store[i]
    }

    func update(id: String, element: T) throws -> T {
        let i = try index(id: id)
        if id != element.uniqueIdentifier {
            throw ClientError.notFound
        }
        store[i] = element
        return element
    }

    func remove(id: String) throws {
        let i = try index(id: id)
        store.remove(at: i)
    }

    private func index(id: String) throws -> Int {
        guard let index = Int(id) where store.indices.contains(index) else {
            throw ClientError.notFound
        }
        return index
    }
}
