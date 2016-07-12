public struct UserController : CRUDController {
    public typealias Model = User
    let store: Store

    public var repository: Repository<User> {
        return store.users
    }
}
