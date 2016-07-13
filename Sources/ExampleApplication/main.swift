@_exported import Quark
@_exported import ExampleDomain

Quark.run { parameters in
    let store = InMemoryStore()
    let app = Application(store: store)
    let router = Router(app: app)
    return router
}
