/*
 https://tools.ietf.org/html/rfc3986#section-1

 3.  Syntax Components

 The generic URI syntax consists of a hierarchical sequence of
 components referred to as the scheme, authority, path, query, and
 fragment.

 URI         = scheme ":" hier-part [ "?" query ] [ "#" fragment ]

 hier-part   = "//" authority path-abempty
 / path-absolute
 / path-rootless
 / path-empty

 The scheme and path components are required, though the path may be
 empty (no characters).  When authority is present, the path must
 either be empty or begin with a slash ("/") character.  When
 authority is not present, the path cannot begin with two slash
 characters ("//").  These restrictions result in five different ABNF
 rules for a path (Section 3.3), only one of which will match any
 given URI reference.

 The following are two example URIs and their component parts:

 foo://example.com:8042/over/there?name=ferret#nose
 \_/   \______________/\_________/ \_________/ \__/
 |           |            |            |        |
 scheme     authority       path        query   fragment
 |   _____________________|__
 / \ /                        \
 urn:example:animal:ferret:nose
 */
public struct URI {
    public struct UserInfo {
        public var username: String
        public var password: String

        public init(username: String, password: String) {
            self.username = username
            self.password = password
        }
    }

    public var scheme: String?
    public var userInfo: UserInfo?
    public var host: String?
    public var port: Int?
    public var path: String?
    public var query:  String?
    public var fragment: String?

    public init(scheme: String? = nil,
                userInfo: UserInfo? = nil,
                host: String? = nil,
                port: Int? = nil,
                path: String? = nil,
                query: String? = nil,
                fragment: String? = nil) {
        self.scheme = scheme
        self.userInfo = userInfo
        self.host = host
        self.port = port
        self.path = path
        self.query = query
        self.fragment = fragment
    }
}
