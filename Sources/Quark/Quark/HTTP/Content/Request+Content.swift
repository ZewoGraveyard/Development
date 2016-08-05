extension Request {
    public var content: StructuredData? {
        get {
            return storage["content"] as? StructuredData
        }

        set(content) {
            storage["content"] = content
        }
    }
}

extension Request {
    public init<T : StructuredDataRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: T) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: T?) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: [T]) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: [String: T]) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T : StructuredDataFallibleRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: T) throws {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: []
        )

        self.content = try content.asStructuredData()
    }
}

extension Request {
    public init<T : StructuredDataRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: T) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: T?) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: [T]) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: [String: T]) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T : StructuredDataFallibleRepresentable>(method: Method = .get, uri: String, headers: Headers = [:], content: T) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            body: []
        )

        self.content = try content.asStructuredData()
    }
}
