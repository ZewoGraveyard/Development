extension Response {
    public init(status: Status = .ok, headers: Headers = [:], body: Data = []) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: [],
            body: .buffer(body)
        )

        self.headers["Content-Length"] = body.count.description
    }

    public init(status: Status = .ok, headers: Headers = [:], body: InputStream) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: [],
            body: .reader(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(status: Status = .ok, headers: Headers = [:], body: (C7.OutputStream) throws -> Void) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: [],
            body: .writer(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }
}

extension Response {
    public init(status: Status = .ok, headers: Headers = [:], body: DataConvertible) {
        self.init(
            status: status,
            headers: headers,
            body: body.data
        )
    }
}

extension Response {
    public var statusCode: Int {
        return status.statusCode
    }

    public var reasonPhrase: String {
        return status.reasonPhrase
    }
}

extension Response {
    public var cookies: Set<AttributedCookie> {
        get {
            var cookies = Set<AttributedCookie>()

            for header in cookieHeaders {
                if let cookie = AttributedCookie(header) {
                    cookies.insert(cookie)
                }
            }

            return cookies
        }

        set(cookies) {
            var headers = Set<String>()

            for cookie in cookies {
                let header = String(cookie)
                headers.insert(header)
            }

            cookieHeaders = headers
        }
    }
}

extension Response {
    public typealias UpgradeConnection = (Request, Stream) throws -> Void

    public var upgradeConnection: UpgradeConnection? {
        return storage["response-connection-upgrade"] as? UpgradeConnection
    }

    public mutating func upgradeConnection(_ upgrade: UpgradeConnection)  {
        storage["response-connection-upgrade"] = upgrade
    }
}

extension Response : CustomStringConvertible {
    public var statusLineDescription: String {
        return "HTTP/" + String(version.major) + "." + String(version.minor) + " " + String(statusCode) + " " + reasonPhrase + "\n"
    }

    public var description: String {
        return statusLineDescription +
            headers.description
    }
}

extension Response : CustomDebugStringConvertible {
    public var debugDescription: String {
        return description + "\n" + storageDescription
    }
}
