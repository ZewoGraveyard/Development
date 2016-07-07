extension Request {
    public var content: StructuredData? {
        get {
            return storage["content"] as? StructuredData
        }

        set(content) {
            storage["content"] = content
        }
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: StructuredData, didUpgrade: DidUpgrade? = nil) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: [],
            didUpgrade: didUpgrade
        )

        self.content = content
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: StructuredDataRepresentable, didUpgrade: DidUpgrade? = nil) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: [],
            didUpgrade: didUpgrade
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: T?, didUpgrade: DidUpgrade? = nil) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: [],
            didUpgrade: didUpgrade
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: [T], didUpgrade: DidUpgrade? = nil) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: [],
            didUpgrade: didUpgrade
        )

        self.content = content.structuredData
    }

    public init<T: StructuredDataRepresentable>(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: [String: T], didUpgrade: DidUpgrade? = nil) {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: [],
            didUpgrade: didUpgrade
        )

        self.content = content.structuredData
    }

    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], content: StructuredDataFallibleRepresentable, didUpgrade: DidUpgrade? = nil) throws {
        self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: [],
            didUpgrade: didUpgrade
        )

        self.content = try content.asStructuredData()
    }
}
