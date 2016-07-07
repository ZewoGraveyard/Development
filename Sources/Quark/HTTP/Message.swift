extension Message {
    public var contentType: MediaType? {
        get {
            return headers["Content-Type"].flatMap({try? MediaType(string: $0)})
        }

        set(contentType) {
            headers["Content-Type"] = contentType?.description
        }
    }

    public var contentLength: Int? {
        get {
            return headers["Content-Length"].flatMap({Int($0)})
        }

        set(contentLength) {
            headers["Content-Length"] = contentLength?.description
        }
    }

    public var transferEncoding: String? {
        get {
            return headers["Transfer-Encoding"]
        }

        set(transferEncoding) {
            headers["Transfer-Encoding"] = transferEncoding
        }
    }

    public var isChunkEncoded: Bool {
        return transferEncoding == "chunked"
    }

    public var connection: String? {
        get {
            return headers["Connection"]
        }

        set(connection) {
            headers["Connection"] = connection
        }
    }

    public var isKeepAlive: Bool {
        if version.minor == 0 {
            return connection?.lowercased() == "keep-alive"
        }

        return connection?.lowercased() == "close"
    }

    public var isUpgrade: Bool {
        return connection?.lowercased() == "upgrade"
    }

    public var upgrade: String? {
        get {
            return headers["Upgrade"]
        }

        set(upgrade) {
            headers["Upgrade"] = upgrade
        }
    }
}

extension Message {
    public var storageDescription: String {
        var string = "Storage:\n"

        if storage.count == 0 {
            string += "-"
        }

        for (offset: index, element: (key: key, value: value)) in storage.enumerated() {
            string += "\(key): \(value)"

            if index < storage.count - 1 {
                string += "\n"
            }
        }

        return string
    }
}
