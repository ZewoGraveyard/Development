extension Request {
    public typealias DidUpgrade = (Response, Stream) throws -> Void

    public var didUpgrade: DidUpgrade? {
        get {
            return storage["request-connection-upgrade"] as? DidUpgrade
        }

        set(didUpgrade) {
            storage["request-connection-upgrade"] = didUpgrade
        }
    }
}

extension Request {
    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: Data = []) {
        self.init(
            method: method,
            uri: uri,
            version: Version(major: 1, minor: 1),
            headers: headers,
            body: .buffer(body)
        )

        self.headers["Content-Length"] = body.count.description
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: Stream) {
        self.init(
            method: method,
            uri: uri,
            version: Version(major: 1, minor: 1),
            headers: headers,
            body: .receiver(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: (SendingStream) throws -> Void) {
        self.init(
            method: method,
            uri: uri,
            version: Version(major: 1, minor: 1),
            headers: headers,
            body: .sender(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: AsyncStream) {
        self.init(
            method: method,
            uri: uri,
            version: Version(major: 1, minor: 1),
            headers: headers,
            body: .asyncReceiver(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: (AsyncSendingStream, ((Void) throws -> Void) -> Void) -> Void) {
        self.init(
            method: method,
            uri: uri,
            version: Version(major: 1, minor: 1),
            headers: headers,
            body: .asyncSender(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: Stream, didUpgrade: DidUpgrade?) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: body
        )

        self.didUpgrade = didUpgrade
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: Data = Data(), didUpgrade: DidUpgrade?) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: body
        )

        self.didUpgrade = didUpgrade
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: DataConvertible, didUpgrade: DidUpgrade? = nil) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: body.data,
            didUpgrade: didUpgrade
        )
    }

    public init(method: Method = .get, uri: String, headers: Headers = [:], body: Data = Data(), didUpgrade: DidUpgrade? = nil) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: body,
            didUpgrade: didUpgrade
        )
    }

    public init(method: Method = .get, uri: String, headers: Headers = [:], body: DataConvertible, didUpgrade: DidUpgrade? = nil) throws {
        try self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: body.data,
            didUpgrade: didUpgrade
        )
    }

    public init(method: Method = .get, uri: String, headers: Headers = [:], body: Stream, didUpgrade: DidUpgrade? = nil) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: body,
            didUpgrade: didUpgrade
        )
    }
}

extension Request {
    public var path: String? {
        return uri.path
    }

    public var query: String? {
        return uri.query
    }
}

extension Request {
    public var accept: [MediaType] {
        get {
            var acceptedMediaTypes: [MediaType] = []

            if let acceptString = headers["Accept"] {
                let acceptedTypesString = acceptString.split(separator: ",")

                for acceptedTypeString in acceptedTypesString {
                    let acceptedTypeTokens = acceptedTypeString.split(separator: ";")

                    if acceptedTypeTokens.count >= 1 {
                        let mediaTypeString = acceptedTypeTokens[0].trim()
                        if let acceptedMediaType = try? MediaType(string: mediaTypeString) {
                            acceptedMediaTypes.append(acceptedMediaType)
                        }
                    }
                }
            }

            return acceptedMediaTypes
        }

        set(accept) {
            headers["Accept"] = accept.map({"\($0.type)/\($0.subtype)"}).joined(separator: ", ")
        }
    }

    public var cookies: Set<Cookie> {
        get {
            return headers["Cookie"].flatMap(Cookie.parse) ?? []
        }

        set(cookies) {
            headers["Cookie"] = cookies.map({$0.description}).joined(separator: ", ")
        }
    }

    public var host: String? {
        get {
            return headers["Host"]
        }

        set(host) {
            headers["Host"] = host
        }
    }

    public var userAgent: String? {
        get {
            return headers["User-Agent"]
        }

        set(userAgent) {
            headers["User-Agent"] = userAgent
        }
    }

    public var authorization: String? {
        get {
            return headers["Authorization"]
        }

        set(authorization) {
            headers["Authorization"] = authorization
        }
    }
}

extension Request {
    public var pathParameters: [String: String] {
        get {
            return storage["pathParameters"] as? [String: String] ?? [:]
        }

        set(pathParameters) {
            storage["pathParameters"] = pathParameters
        }
    }
}

extension Request : CustomStringConvertible {
    public var requestLineDescription: String {
        return "\(method) \(uri) HTTP/\(version.major).\(version.minor)\n"
    }

    public var description: String {
        return requestLineDescription +
            headers.description
    }
}

extension Request : CustomDebugStringConvertible {
    public var debugDescription: String {
        return description + "\n\n" + storageDescription
    }
}
