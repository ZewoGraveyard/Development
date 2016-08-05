extension StructuredDataFallibleRepresentable {
    public func asStructuredData() throws -> StructuredData {
        let props = try properties(self)
        var dictionary = [String: StructuredData](minimumCapacity: props.count)
        for property in props {
            guard let representable = property.value as? StructuredDataFallibleRepresentable else {
                throw StructuredDataError.notStructuredDataRepresentable(property.value.dynamicType)
            }
            dictionary[property.key] = try representable.asStructuredData()
        }
        return .dictionary(dictionary)
    }
}

extension StructuredData : StructuredDataRepresentable {
    public var structuredData: StructuredData {
        return self
    }
}

extension Bool : StructuredDataRepresentable {
    public var structuredData: StructuredData {
        return .bool(self)
    }
}

extension Double : StructuredDataRepresentable {
    public var structuredData: StructuredData {
        return .double(self)
    }
}

extension Int : StructuredDataRepresentable {
    public var structuredData: StructuredData {
        return .int(self)
    }
}

extension String : StructuredDataRepresentable {
    public var structuredData: StructuredData {
        return .string(self)
    }
}

extension Data : StructuredDataRepresentable {
    public var structuredData: StructuredData {
        return .data(self)
    }
}

extension Optional where Wrapped : StructuredDataRepresentable {
    public var structuredData: StructuredData {
        switch self {
        case .some(let wrapped): return wrapped.structuredData
        case .none: return .null
        }
    }
}

extension Array where Element : StructuredDataRepresentable {
    public var structuredDataArray: [StructuredData] {
        return self.map({$0.structuredData})
    }

    public var structuredData: StructuredData {
        return .array(structuredDataArray)
    }
}

public protocol StructuredDataDictionaryKeyRepresentable {
    var structuredDataDictionaryKey: String { get }
}

extension String : StructuredDataDictionaryKeyRepresentable {
    public var structuredDataDictionaryKey: String {
        return self
    }
}

extension Dictionary where Key : StructuredDataDictionaryKeyRepresentable, Value : StructuredDataRepresentable {
    public var structuredDataDictionary: [String: StructuredData] {
        var dictionary: [String: StructuredData] = [:]

        for (key, value) in self.map({($0.0.structuredDataDictionaryKey, $0.1.structuredData)}) {
            dictionary[key] = value
        }

        return dictionary
    }

    public var structuredData: StructuredData {
        return .dictionary(structuredDataDictionary)
    }
}

// MARK: StructuredDataFallibleRepresentable

extension Optional : StructuredDataFallibleRepresentable {
    public func asStructuredData() throws -> StructuredData {
        guard Wrapped.self is StructuredDataFallibleRepresentable.Type else {
            throw StructuredDataError.notStructuredDataRepresentable(Wrapped.self)
        }
        if case .some(let wrapped as StructuredDataFallibleRepresentable) = self {
            return try wrapped.asStructuredData()
        }
        return .null
    }
}

extension Array : StructuredDataFallibleRepresentable {
    public func asStructuredData() throws -> StructuredData {
        guard Element.self is StructuredDataFallibleRepresentable.Type else {
            throw StructuredDataError.notStructuredDataRepresentable(Element.self)
        }
        var array: [StructuredData] = []
        array.reserveCapacity(count)
        for element in self {
            let element = element as! StructuredDataFallibleRepresentable
            array.append(try element.asStructuredData())
        }
        return .array(array)
    }
}

extension Dictionary : StructuredDataFallibleRepresentable {
    public func asStructuredData() throws -> StructuredData {
        guard Key.self is StructuredDataDictionaryKeyRepresentable.Type else {
            throw StructuredDataError.notStructuredDataDictionaryKeyRepresentable(Value.self)
        }
        guard Value.self is StructuredDataFallibleRepresentable.Type else {
            throw StructuredDataError.notStructuredDataRepresentable(Value.self)
        }
        var dictionary = [String: StructuredData](minimumCapacity: count)
        for (key, value) in self {
            let value = value as! StructuredDataFallibleRepresentable
            let key = key as! StructuredDataDictionaryKeyRepresentable
            dictionary[key.structuredDataDictionaryKey] = try value.asStructuredData()
        }
        return .dictionary(dictionary)
    }
}
