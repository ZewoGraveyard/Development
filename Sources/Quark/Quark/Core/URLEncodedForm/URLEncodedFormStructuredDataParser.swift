enum URLEncodedFormStructuredDataParserError : Error {
    case unsupportedEncoding
    case malformedURLEncodedForm
}

public struct URLEncodedFormStructuredDataParser : StructuredDataParser {
    public init() {}

    public func parse(_ data: Data) throws -> StructuredData {
        guard let string = try? String(data: data) else {
            throw URLEncodedFormStructuredDataParserError.unsupportedEncoding
        }

        var structuredData: StructuredData = [:]

        for parameter in string.split(separator: "&") {
            let tokens = parameter.split(separator: "=")

            if tokens.count == 2 {
                let key = try String(percentEncoded: tokens[0])
                let value = try String(percentEncoded: tokens[1])

                structuredData[key] = .string(value)
            } else {
                throw URLEncodedFormStructuredDataParserError.malformedURLEncodedForm
            }
        }

        return structuredData
    }
}
