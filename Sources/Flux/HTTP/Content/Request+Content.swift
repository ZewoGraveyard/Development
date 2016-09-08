extension Request {
    public var content: Map? {
        get {
            return storage["content"] as? Map
        }

        set(content) {
            storage["content"] = content
        }
    }
}

extension Request {
    public init<T : MapRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: T) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T: MapRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: T?) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T: MapRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: [T]) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T: MapRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: [String: T]) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T : MapFallibleRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: T) throws {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: Data()
        )

        self.content = try content.asMap()
    }
}

extension Request {
    public init<T : MapRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: T) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T: MapRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: T?) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T: MapRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: [T]) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T: MapRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: [String: T]) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: Data()
        )

        self.content = content.map
    }

    public init<T : MapFallibleRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: T) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: Data()
        )

        self.content = try content.asMap()
    }
}
