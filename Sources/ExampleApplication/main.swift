@_exported import Quark
@_exported import ExampleDomain

Server.run { _ in
    let store = InMemoryStore()
    let app = Application(store: store)
    return Router(app: app)
}
