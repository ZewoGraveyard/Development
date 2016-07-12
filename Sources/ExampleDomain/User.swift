public struct User {
    public let username: String
    public let password: String
    public let todos: [Todo]

    public init(username: String, password: String, todos: [Todo]) {
        self.username = username
        self.password = password
        self.todos = todos
    }
}
