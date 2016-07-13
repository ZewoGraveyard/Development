extension Response {
    public typealias DidUpgrade = (Request, Stream) throws -> Void

    public var didUpgrade: DidUpgrade? {
        get {
            return storage["response-connection-upgrade"] as? DidUpgrade
        }

        set(didUpgrade) {
            storage["response-connection-upgrade"] = didUpgrade
        }
    }
}

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

    public init(status: Status = .ok, headers: Headers = [:], body: Stream) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: [],
            body: .receiver(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(status: Status = .ok, headers: Headers = [:], body: (SendingStream) throws -> Void) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: [],
            body: .sender(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(status: Status = .ok, headers: Headers = [:], body: AsyncStream) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: [],
            body: .asyncReceiver(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(status: Status = .ok, headers: Headers = [:], body: (AsyncSendingStream, ((Void) throws -> Void) -> Void) -> Void) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: [],
            body: .asyncSender(body)
        )

        self.headers["Transfer-Encoding"] = "chunked"
    }

    public init(status: Status = .ok, headers: Headers = [:], body: Stream, didUpgrade: DidUpgrade?) {
        self.init(
            status: status,
            headers: headers,
            body: body
        )

        self.didUpgrade = didUpgrade
    }

    public init(status: Status = .ok, headers: Headers = [:], body: Data = Data(), didUpgrade: DidUpgrade?) {
        self.init(
            status: status,
            headers: headers,
            body: body
        )

        self.didUpgrade = didUpgrade
    }

    public init(status: Status = .ok, headers: Headers = [:], body: DataConvertible, didUpgrade: DidUpgrade? = nil) {
        self.init(
            status: status,
            headers: headers,
            body: body.data,
            didUpgrade: didUpgrade
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

    public var cookies: Set<AttributedCookie> {
        get {
            var cookies = Set<AttributedCookie>()

            for header in cookieHeaders {
                if let cookie = AttributedCookie.parse(header) {
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

extension Response : CustomStringConvertible {
    public var statusLineDescription: String {
        return "HTTP/1.1 " + statusCode.description + " " + reasonPhrase + "\n"
    }

    public var description: String {
        return statusLineDescription +
            headers.description
    }
}

extension Response : CustomDebugStringConvertible {
    public var debugDescription: String {
        return description + "\n\n" + storageDescription
    }
}
