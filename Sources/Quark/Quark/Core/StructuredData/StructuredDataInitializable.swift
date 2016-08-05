extension StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .dictionary(let dictionary) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: Self.self, from: try structuredData.get().dynamicType)
        }
        self = try construct { property in
            guard let initializable = property.type as? StructuredDataInitializable.Type else {
                throw StructuredDataError.notStructuredDataInitializable(property.type)
            }
            switch dictionary[property.key] ?? .null {
            case .null:
                guard let nilLiteralConvertible = property.type as? NilLiteralConvertible.Type else {
                    throw ReflectionError.requiredValueMissing(key: property.key)
                }
                return nilLiteralConvertible.init(nilLiteral: ())
            case let x:
                return try initializable.init(structuredData: x)
            }
        }
    }
}

extension StructuredData : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        self = structuredData
    }
}

extension Bool : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .bool(let bool) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: Bool.self, from: try structuredData.get().dynamicType)
        }
        self = bool
    }
}

extension Double : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .double(let double) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: Double.self, from: try structuredData.get().dynamicType)
        }
        self = double
    }
}

extension Int : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .int(let int) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: Int.self, from: try structuredData.get().dynamicType)
        }
        self = int
    }
}

extension String : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .string(let string) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: String.self, from: try structuredData.get().dynamicType)
        }
        self = string
    }
}

extension Data : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .data(let data) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: Data.self, from: try structuredData.get().dynamicType)
        }
        self = data
    }
}

extension Optional : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard let initializable = Wrapped.self as? StructuredDataInitializable.Type else {
            throw StructuredDataError.notStructuredDataInitializable(Wrapped.self)
        }
        if case .null = structuredData {
            self = .none
        } else {
            self = try initializable.init(structuredData: structuredData) as? Wrapped
        }
    }
}

extension Array : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .array(let array) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: Array.self, from: try structuredData.get().dynamicType)
        }
        guard let initializable = Element.self as? StructuredDataInitializable.Type else {
            throw StructuredDataError.notStructuredDataInitializable(Element.self)
        }
        var this = Array()
        this.reserveCapacity(array.count)
        for element in array {
            if let value = try initializable.init(structuredData: element) as? Element {
                this.append(value)
            }
        }
        self = this
    }
}

public protocol StructuredDataDictionaryKeyInitializable {
    init(structuredDataDictionaryKey: String)
}

extension String : StructuredDataDictionaryKeyInitializable {
    public init(structuredDataDictionaryKey: String) {
        self = structuredDataDictionaryKey
    }
}

extension Dictionary : StructuredDataInitializable {
    public init(structuredData: StructuredData) throws {
        guard case .dictionary(let dictionary) = structuredData else {
            throw StructuredDataError.cannotInitialize(type: Dictionary.self, from: try structuredData.get().dynamicType)
        }
        guard let keyInitializable = Key.self as? StructuredDataDictionaryKeyInitializable.Type else {
            throw StructuredDataError.notStructuredDataDictionaryKeyInitializable(self.dynamicType)
        }
        guard let valueInitializable = Value.self as? StructuredDataInitializable.Type else {
            throw StructuredDataError.notStructuredDataInitializable(Element.self)
        }
        var this = Dictionary(minimumCapacity: dictionary.count)
        for (key, value) in dictionary {
            if let key = keyInitializable.init(structuredDataDictionaryKey: key) as? Key {
                this[key] = try valueInitializable.init(structuredData: value) as? Value
            }
        }
        self = this
    }
}
