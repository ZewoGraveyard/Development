@_exported import Quark
@_exported import ExampleDomain

// This is where you configure and inject your app's dependencies

Server.run { _ in
    let store = InMemoryStore()
    let app = Application(store: store)
    return Router(app: app)
}
