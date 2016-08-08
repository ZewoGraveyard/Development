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

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: InputStream) {
        self.init(
            method: method,
            uri: uri,
            version: Version(major: 1, minor: 1),
            headers: headers,
            body: .reader(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: @escaping (C7.OutputStream) throws -> Void) {
        self.init(
            method: method,
            uri: uri,
            version: Version(major: 1, minor: 1),
            headers: headers,
            body: .writer(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }
}

extension Request {
    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], body: DataRepresentable) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: body.data
        )
    }
}

extension Request {
    public init(method: Method = .get, uri: String, headers: Headers = [:], body: Data = []) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: body
        )
    }

    public init(method: Method = .get, uri: String, headers: Headers = [:], body: InputStream) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: body
        )
    }

    public init(method: Method = .get, uri: String, headers: Headers = [:], body: @escaping (C7.OutputStream) throws -> Void) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: body
        )
    }
}

extension Request {
    public var path: String? {
        return uri.path
    }

    public var query: [String: String] {
        return uri.singleValuedQuery
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
            return headers["Cookie"].flatMap({Set<Cookie>(cookieHeader: $0)}) ?? []
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
    public typealias UpgradeConnection = (Response, Stream) throws -> Void

    public var upgradeConnection: UpgradeConnection? {
        return storage["request-connection-upgrade"] as? UpgradeConnection
    }

    public mutating func upgradeConnection(_ upgrade: UpgradeConnection)  {
        storage["request-connection-upgrade"] = upgrade
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
        return String(describing: method) + " " + String(describing: uri) + " HTTP/" + String(describing: version.major) + "." + String(describing: version.minor) + "\n"
    }

    public var description: String {
        return requestLineDescription +
            headers.description
    }
}

extension Request : CustomDebugStringConvertible {
    public var debugDescription: String {
        return description + "\n" + storageDescription
    }
}
