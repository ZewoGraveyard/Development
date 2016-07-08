public struct UserController : SingularController {
    let store: Store

    public func create(element user: User) throws -> User {
        return try store.user.save(user)
    }

    public func detail() throws -> User {
        return try store.user.get()
    }

    public func update(element user: User) throws -> User {
        return try store.user.update(user)
    }

    public func destroy() throws {
        try store.user.remove()
    }
}
