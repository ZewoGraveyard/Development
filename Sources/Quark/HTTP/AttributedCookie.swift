public struct AttributedCookie {
    public var name: String
    public var value: String

    public var expires: String?
    public var maxAge: Int?
    public var domain: String?
    public var path: String?
    public var secure: Bool
    public var HTTPOnly: Bool

    public init(name: String, value: String, expires: String? = nil, maxAge: Int? = nil, domain: String? = nil, path: String? = nil, secure: Bool = false, HTTPOnly: Bool = false) {
        self.name = name
        self.value = value
        self.expires = expires
        self.maxAge = maxAge
        self.domain = domain
        self.path = path
        self.secure = secure
        self.HTTPOnly = HTTPOnly
    }

    init(name: String, value: String, attributes: [CaseInsensitiveString: String]) {
        let expires = attributes["Path"]
        let maxAge = attributes["Max-Age"].flatMap({Int($0)})
        let domain = attributes["Domain"]
        let path = attributes["Path"]
        let secure = attributes["Secure"] != nil
        let HTTPOnly = attributes["HttpOnly"] != nil

        self.init(
            name: name,
            value: value,
            domain: domain,
            path: path,
            expires: expires,
            maxAge: maxAge,
            secure: secure,
            HTTPOnly:  HTTPOnly
        )
    }
}

extension AttributedCookie : Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

public func ==(lhs: AttributedCookie, rhs: AttributedCookie) -> Bool {
    return lhs.name == rhs.name
}

extension AttributedCookie : CustomStringConvertible {
    public var description: String {
        var string = "\(name)=\(value)"

        if let expires = expires {
            string += "; Expires=\(expires)"
        }

        if let maxAge = maxAge {
            string += "; Max-Age=\(maxAge)"
        }

        if let domain = domain {
            string += "; Domain=\(domain)"
        }

        if let path = path {
            string += "; Path=\(path)"
        }

        if secure {
            string += "; Secure"
        }

        if HTTPOnly {
            string += "; HttpOnly"
        }

        return string
    }
}

extension AttributedCookie {
    public static func parse(_ string: String) -> AttributedCookie? {
        let cookieStringTokens = string.split(separator: ";")

        guard let cookieTokens = cookieStringTokens.first?.split(separator: "=") where cookieTokens.count == 2 else {
            return nil
        }

        let name = cookieTokens[0]
        let value = cookieTokens[1]

        var attributes: [CaseInsensitiveString: String] = [:]

        for i in 1 ..< cookieStringTokens.count {
            let attributeTokens = cookieStringTokens[i].split(separator: "=")

            switch attributeTokens.count {
                case 1:
                    attributes[CaseInsensitiveString(attributeTokens[0].trim())] = ""
                case 2:
                    attributes[CaseInsensitiveString(attributeTokens[0].trim())] = attributeTokens[1].trim()
                default:
                    return nil
            }
        }

        return AttributedCookie(name: name, value: value, attributes: attributes)
    }
}
