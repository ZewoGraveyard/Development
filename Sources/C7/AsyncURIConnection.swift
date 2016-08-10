public protocol AsyncURIConnection : AsyncConnection {
    init(uri: URI) throws
    var uri: URI { get }
}
