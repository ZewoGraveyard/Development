public protocol URIConnection: Connection {
    init(uri: URI) throws
    var uri: URI { get }
}
