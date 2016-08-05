extension Headers : CustomStringConvertible {
    public var description: String {
        var string = ""

        for (header, value) in headers {
            string += "\(header): \(value)\n"
        }

        return string
    }
}

extension Headers : Equatable {}

public func == (lhs: Headers, rhs: Headers) -> Bool {
    return lhs.headers == rhs.headers
}
