public struct Todo {
    public let title: String
    public let done: Bool
    public let user: User

    public init(title: String, done: Bool, user: User) {
        self.title = title
        self.done = done
        self.user = user
    }
}
