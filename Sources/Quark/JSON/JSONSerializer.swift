// This file has been modified from its original project Swift-JsonSerializer

public class JSONSerializer {
    public init() {}

    public func serialize(json: JSON) -> Data {
        return serializeToString(json: json).data
    }

    public func serializeToString(json: JSON) -> String {
        switch json {
        case .nullValue: return "null"
        case .booleanValue(let b): return b ? "true" : "false"
        case .numberValue(let n): return serialize(number: n)
        case .stringValue(let s): return escapeAsJSON(s)
        case .arrayValue(let a): return serialize(array: a)
        case .objectValue(let o): return serialize(object: o)
        }
    }

    func serialize(number: Double) -> String {
        if number == Double(Int64(number)) {
            return Int64(number).description
        } else {
            return number.description
        }
    }

    func serialize(array: [JSON]) -> String {
        var s = "["

        for i in 0 ..< array.count {
            s += serializeToString(json: array[i])

            if i != (array.count - 1) {
                s += ","
            }
        }

        return s + "]"
    }

    func serialize(object: [String: JSON]) -> String {
        var s = "{"
        var i = 0

        for entry in object {
            s += "\(escapeAsJSON(entry.0)):\(serialize(json: entry.1))"
            if i != (object.count - 1) {
                s += ","
            }
            i += 1
        }

        return s + "}"
    }
}

public final class PrettyJSONSerializer : JSONSerializer {
    var indentLevel = 0

    override public func serialize(array: [JSON]) -> String {
        var s = "["
        indentLevel += 1

        for i in 0 ..< array.count {
            s += "\n"
            s += indent()
            s += serializeToString(json: array[i])

            if i != (array.count - 1) {
                s += ","
            }
        }

        indentLevel -= 1
        return s + "\n" + indent() + "]"
    }

    override public func serialize(object: [String: JSON]) -> String {
        var s = "{"
        indentLevel += 1
        var i = 0

        for (key, value) in object {
            s += "\n"
            s += indent()
            s += "\(escapeAsJSON(key)): \(serialize(json: value))"

            if i != (object.count - 1) {
                s += ","
            }

            i += 1
        }

        indentLevel -= 1
        return s + "\n" + indent() + "}"
    }

    func indent() -> String {
        var s = ""

        for _ in 0 ..< indentLevel {
            s += "    "
        }

        return s
    }
}
