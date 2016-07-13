public struct User {
    public let email: String
    public let password: String
    public let todos: [Todo]

    public init(email: String, password: String, todos: [Todo] = []) {
        self.email = email
        self.password = password
        self.todos = todos
    }
}
