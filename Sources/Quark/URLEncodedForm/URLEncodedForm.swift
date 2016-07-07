public struct URLEncodedForm {
    public var values: [String: String]
}

extension URLEncodedForm : DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (String, String)...) {
        var values: [String: String] = [:]

        for (key, value) in elements {
            values[key] = value
        }

        self.values = values
    }
}
