@_exported import Quark
@_exported import ExampleDomain

struct ServerConfiguration : Configuration {
    let host: String
    let port: Int
}

struct AppConfiguration : Configuration {
    let server: ServerConfiguration
}

configure { (configuration: AppConfiguration) in
    let store = InMemoryStore()
    let app = Application(store: store)
    return Router(app: app)
}
