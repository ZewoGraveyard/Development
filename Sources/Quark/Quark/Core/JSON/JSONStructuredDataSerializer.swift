// This file has been modified from its original project Swift-JsonSerializer

public struct JSONStructuredDataSerializer : StructuredDataSerializer {
    enum Error: ErrorProtocol {
        case invalidStructuredData
    }

    public init() {}

    public func serialize(_ data: StructuredData) throws -> Data {
        return try serializeToString(data).data
    }

    public func serializeToString(_ data: StructuredData) throws -> String {
        switch data {
        case .null: return "null"
        case .bool(let bool): return bool ? "true" : "false"
        case .double(let number): return serialize(number: number)
        case .int(let number): return serialize(number: Double(number))
        case .string(let text): return escapeAsJSON(text)
        case .array(let array): return try serialize(array: array)
        case .dictionary(let dictionary): return try serialize(dictionary: dictionary)
        default: throw Error.invalidStructuredData
        }
    }

    func serialize(number: Double) -> String {
        if number == Double(Int64(number)) {
            return Int64(number).description
        } else {
            return number.description
        }
    }

    func serialize(array: [StructuredData]) throws -> String {
        var s = "["

        for i in 0 ..< array.count {
            s += try serializeToString(array[i])

            if i != (array.count - 1) {
                s += ","
            }
        }

        return s + "]"
    }

    func serialize(dictionary: [String: StructuredData]) throws -> String {
        var s = "{"
        var i = 0

        for entry in dictionary {
            s += try "\(escapeAsJSON(entry.0)):\(serialize(entry.1))"
            if i != (dictionary.count - 1) {
                s += ","
            }
            i += 1
        }

        return s + "}"
    }
}
