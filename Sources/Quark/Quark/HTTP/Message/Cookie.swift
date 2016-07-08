public struct Cookie {
    public var name: String
    public var value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension Cookie : Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

public func ==(lhs: Cookie, rhs: Cookie) -> Bool {
    return lhs.name == rhs.name
}

extension Cookie : CustomStringConvertible {
    public var description: String {
        return "\(name)=\(value)"
    }
}

extension Cookie {
    public static func parse(string: String) -> Set<Cookie>? {
        var cookies = Set<Cookie>()
        let tokens = string.split(separator: ";")

        for token in tokens {
            let cookieTokens = token.split(separator: "=", maxSplits: 1)

            guard cookieTokens.count == 2 else {
                return nil
            }

            cookies.insert(Cookie(name: cookieTokens[0].trim(), value: cookieTokens[1].trim()))
        }

        return cookies
    }
}
