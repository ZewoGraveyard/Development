public struct Request: Message {
    public var method: Method
    public var uri: URI
    public var version: Version
    public var headers: Headers
    public var body: Body
    public var storage: [String: Any]

    public init(method: Method, uri: URI, version: Version, headers: Headers, body: Body) {
        self.method = method
        self.uri = uri
        self.version = version
        self.headers = headers
        self.body = body
        self.storage = [:]
    }
}

public protocol RequestInitializable {
    init(request: Request)
}

public protocol RequestRepresentable {
    var request: Request { get }
}

public protocol RequestConvertible: RequestInitializable, RequestRepresentable {}
