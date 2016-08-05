extension Response {
    public var content: StructuredData? {
        get {
            return storage["content"] as? StructuredData
        }

        set(content) {
            storage["content"] = content
        }
    }
}

extension Response {
    public init<T : StructuredDataRepresentable>(status: Status = .ok, headers: Headers = [:], content: T) {
        self.init(
            status: status,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T : StructuredDataRepresentable>(status: Status = .ok, headers: Headers = [:], content: T?) {
        self.init(
            status: status,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T : StructuredDataRepresentable>(status: Status = .ok, headers: Headers = [:], content: [T]) {
        self.init(
            status: status,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T : StructuredDataRepresentable>(status: Status = .ok, headers: Headers = [:], content: [String: T]) {
        self.init(
            status: status,
            headers: headers,
            body: []
        )

        self.content = content.structuredData
    }

    public init<T : StructuredDataFallibleRepresentable>(status: Status = .ok, headers: Headers = [:], content: T) throws {
        self.init(
            status: status,
            headers: headers,
            body: []
        )

        self.content = try content.asStructuredData()
    }
}
