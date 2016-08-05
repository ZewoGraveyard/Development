enum URLEncodedFormStructuredDataSerializerError : ErrorProtocol {
    case invalidStructuredData
}

public struct URLEncodedFormStructuredDataSerializer : StructuredDataSerializer {
    public init() {}

    public func serialize(_ structuredData: StructuredData) throws -> Data {
        return try serializeToString(structuredData).data
    }

    public func serializeToString(_ structuredData: StructuredData) throws -> String {
        switch structuredData {
        case .dictionary(let dictionary): return try serializeDictionary(dictionary)
        default: throw URLEncodedFormStructuredDataSerializerError.invalidStructuredData
        }
    }

    func serializeDictionary(_ object: [String: StructuredData]) throws -> String {
        var string = ""

        for (offset: index, element: (key: key, value: structuredData)) in object.enumerated() {
            if index != 0 {
                string += "&"
            }
            string += String(key) + "="
            let value = try structuredData.asString(converting: true)
            string += value.percentEncoded(allowing: .uriQueryAllowed)
        }

        return string
    }
}
