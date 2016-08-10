// MARK: MapError

public enum MapError : Error {
    case incompatibleType
    case outOfBounds
    case valueNotFound
    case notMapInitializable(Any.Type)
    case notMapRepresentable(Any.Type)
    case notMapDictionaryKeyInitializable(Any.Type)
    case notMapDictionaryKeyRepresentable(Any.Type)
    case cannotInitialize(type: Any.Type, from: Any.Type)
}

// MARK: Mappable

public protocol Mappable : MapInitializable, MapFallibleRepresentable {}

// MARK: Parser/Serializer Protocols

public protocol MapParser {
    func parse(_ data: Data) throws -> Map
}

extension MapParser {
    public func parse(_ convertible: DataConvertible) throws -> Map {
        return try parse(convertible.data)
    }
}

public protocol MapSerializer {
    func serialize(_ map: Map) throws -> Data
}

// MARK: Initializers

extension Map {
    public init<T: MapRepresentable>(_ value: T?) {
        self = value?.map ?? .null
    }

    public init<T: MapRepresentable>(_ values: [T]?) {
        if let values = values {
            self = .array(values.map({$0.map}))
        } else {
            self = .null
        }
    }

    public init<T: MapRepresentable>(_ values: [T?]?) {
        if let values = values {
            self = .array(values.map({$0?.map ?? .null}))
        } else {
            self = .null
        }
    }

    public init<T: MapRepresentable>(_ values: [String: T]?) {
        if let values = values {
            var dictionary: [String: Map] = [:]

            for (key, value) in values.map({($0.key, $0.value.map)}) {
                dictionary[key] = value
            }

            self = .dictionary(dictionary)
        } else {
            self = .null
        }
    }

    public init<T: MapRepresentable>(_ values: [String: T?]?) {
        if let values = values {
            var dictionary: [String: Map] = [:]

            for (key, value) in values.map({($0.key, $0.value?.map ?? .null)}) {
                dictionary[key] = value
            }

            self = .dictionary(dictionary)
        } else {
            self = .null
        }
    }
}

// MARK: Type Inference

extension Map {
    public static func infer<T: MapRepresentable>(_ value: T?) -> Map {
        return Map(value)
    }

    public static func infer<T: MapRepresentable>(_ values: [T]?) -> Map {
        return Map(values)
    }

    public static func infer<T: MapRepresentable>(_ values: [T?]?) -> Map {
        return Map(values)
    }

    public static func infer<T: MapRepresentable>(_ values: [String: T]?) -> Map {
        return Map(values)
    }

    public static func infer<T: MapRepresentable>(_ values: [String: T?]?) -> Map {
        return Map(values)
    }
}

// MARK: is<Type>

extension Map {
    public var isNull: Bool {
        if case .null = self {
            return true
        }
        return false
    }

    public var isBool: Bool {
        if case .bool = self {
            return true
        }
        return false
    }

    public var isDouble: Bool {
        if case .double = self {
            return true
        }
        return false
    }

    public var isInt: Bool {
        if case .int = self {
            return true
        }
        return false
    }

    public var isString: Bool {
        if case .string = self {
            return true
        }
        return false
    }

    public var isData: Bool {
        if case .data = self {
            return true
        }
        return false
    }

    public var isArray: Bool {
        if case .array = self {
            return true
        }
        return false
    }

    public var isDictionary: Bool {
        if case .dictionary = self {
            return true
        }
        return false
    }
}

// MARK: as<type>?

extension Map {
    public var asBool: Bool? {
        return try? get()
    }

    public var asDouble: Double? {
        return try? get()
    }

    public var asInt: Int? {
        return try? get()
    }

    public var asString: String? {
        return try? get()
    }

    public var asData: Data? {
        return try? get()
    }

    public var asArray: [Map]? {
        return try? get()
    }

    public var asDictionary: [String: Map]? {
        return try? get()
    }
}

// MARK: try as<type>()

extension Map {
    public func asBool(converting: Bool = false) throws -> Bool {
        guard converting else {
            return try get()
        }

        switch self {
        case .bool(let value):
            return value

        case .int(let value):
            return value != 0

        case .double(let value):
            return value != 0

        case .string(let value):
            switch value.lowercased() {
            case "true": return true
            case "false": return false
            default: throw MapError.incompatibleType
            }

        case .data(let value):
            return !value.isEmpty

        case .array(let value):
            return !value.isEmpty

        case .dictionary(let value):
            return !value.isEmpty

        case .null:
            return false
        }
    }

    public func asInt(converting: Bool = false) throws -> Int {
        guard converting else {
            return try get()
        }

        switch self {
        case .bool(let value):
            return value ? 1 : 0

        case .int(let value):
            return value

        case .double(let value):
            return Int(value)

        case .string(let value):
            if let int = Int(value) {
                return int
            }
            throw MapError.incompatibleType

        case .null:
            return 0

        default:
            throw MapError.incompatibleType
        }
    }

    public func asDouble(converting: Bool = false) throws -> Double {
        guard converting else {
            return try get()
        }

        switch self {
        case .bool(let value):
            return value ? 1.0 : 0.0

        case .int(let value):
            return Double(value)

        case .double(let value):
            return value

        case .string(let value):
            if let double = Double(value) {
                return double
            }
            throw MapError.incompatibleType

        case .null:
            return 0

        default:
            throw MapError.incompatibleType
        }
    }

    public func asString(converting: Bool = false) throws -> String {
        guard converting else {
            return try get()
        }

        switch self {
        case .bool(let value):
            return String(value)

        case .int(let value):
            return String(value)

        case .double(let value):
            return String(value)

        case .string(let value):
            return value

        case .data(let value):
            return String(describing: value)

        case .array:
            throw MapError.incompatibleType

        case .dictionary:
            throw MapError.incompatibleType

        case .null:
            return "null"
        }
    }

    public func asData(converting: Bool = false) throws -> Data {
        guard converting else {
            return try get()
        }

        switch self {
        case .bool(let value):
            return value ? [0xff] : [0x00]

        case .string(let value):
            return Data(value)

        case .data(let value):
            return value

        case .null:
            return []

        default:
            throw MapError.incompatibleType
        }
    }

    public func asArray(converting: Bool = false) throws -> [Map] {
        guard converting else {
            return try get()
        }

        switch self {
        case .array(let value):
            return value

        case .null:
            return []

        default:
            throw MapError.incompatibleType
        }
    }
    
    public func asDictionary(converting: Bool = false) throws -> [String: Map] {
        guard converting else {
            return try get()
        }
        
        switch self {
        case .dictionary(let value):
            return value
            
        case .null:
            return [:]
            
        default:
            throw MapError.incompatibleType
        }
    }
}

// MARK: IndexPath

public typealias IndexPath = [IndexPathElement]

extension String {
    public func indexPath() -> IndexPath {
        return self.split(separator: ".").map {
            if let index = Int($0) {
                return index as IndexPathElement
            }
            return $0 as IndexPathElement
        }
    }
}

public enum IndexPathValue {
    case index(Int)
    case key(String)
}

public protocol IndexPathElement {
    var indexPathValue: IndexPathValue { get }
}

extension IndexPathElement {
    var constructEmptyContainer: Map {
        switch indexPathValue {
        case .index: return []
        case .key: return [:]
        }
    }
}

extension Int : IndexPathElement {
    public var indexPathValue: IndexPathValue {
        return .index(self)
    }
}

extension String : IndexPathElement {
    public var indexPathValue: IndexPathValue {
        return .key(self)
    }
}

// MARK: Get

extension Map {
    public func get<T>(at indexPath: IndexPathElement...) throws -> T {
        if indexPath.isEmpty {
            switch self {
            case .bool(let value as T): return value
            case .int(let value as T): return value
            case .double(let value as T): return value
            case .string(let value as T): return value
            case .data(let value as T): return value
            case .array(let value as T): return value
            case .dictionary(let value as T): return value
            default: throw MapError.incompatibleType
            }
        }
        return try get(at: indexPath).get()
    }

    public func get(at indexPath: IndexPathElement...) throws -> Map {
        return try get(at: indexPath)
    }

    public func get(at indexPath: IndexPath) throws -> Map {
        var value: Map = self

        for element in indexPath {
            switch element.indexPathValue {
            case .index(let index):
                let array = try value.asArray()
                if array.indices.contains(index) {
                    value = array[index]
                } else {
                    throw MapError.outOfBounds
                }

            case .key(let key):
                let dictionary = try value.asDictionary()
                if let newValue = dictionary[key] {
                    value = newValue
                } else {
                    throw MapError.valueNotFound
                }
            }
        }
        
        return value
    }
}

// MARK: Set

extension Map {
    public mutating func set<T : MapRepresentable>(value: T, at indexPath: IndexPathElement...) throws {
        try set(value: value, at: indexPath)
    }

    public mutating func set<T : MapRepresentable>(value: T, at indexPath: [IndexPathElement]) throws {
        try set(value: value, merging: true, at: indexPath)
    }

    fileprivate mutating func set<T : MapRepresentable>(value: T, merging: Bool, at indexPath: [IndexPathElement]) throws {
        var indexPath = indexPath

        guard let first = indexPath.first else {
            return self = value.map
        }

        indexPath.removeFirst()

        if indexPath.isEmpty {
            switch first.indexPathValue {
            case .index(let index):
                if case .array(var array) = self {
                    if !array.indices.contains(index) {
                        throw MapError.outOfBounds
                    }
                    array[index] = value.map
                    self = .array(array)
                } else {
                    throw MapError.incompatibleType
                }
            case .key(let key):
                if case .dictionary(var dictionary) = self {
                    let newValue = value.map
                    if let existingDictionary = dictionary[key]?.asDictionary,
                        let newDictionary = newValue.asDictionary,
                        merging {
                        var combinedDictionary: [String: Map] = [:]

                        for (key, value) in existingDictionary {
                            combinedDictionary[key] = value
                        }
    
                        for (key, value) in newDictionary {
                            combinedDictionary[key] = value
                        }
    
                        dictionary[key] = .dictionary(combinedDictionary)
                    } else {
                        dictionary[key] = newValue
                    }
                    self = .dictionary(dictionary)
                } else {
                    throw MapError.incompatibleType
                }
            }
        } else {
            var next = (try? self.get(at: first)) ?? first.constructEmptyContainer
            try next.set(value: value, at: indexPath)
            try self.set(value: next, at: [first])
        }
    }
}

// MARK: Remove

extension Map {
    public mutating func remove(at indexPath: IndexPathElement...) throws {
        try self.remove(at: indexPath)
    }

    public mutating func remove(at indexPath: [IndexPathElement]) throws {
        var indexPath = indexPath

        guard let first = indexPath.first else {
            return self = .null
        }

        indexPath.removeFirst()

        if indexPath.isEmpty {
            guard case .dictionary(var dictionary) = self, case .key(let key) = first.indexPathValue else {
                throw MapError.incompatibleType
            }

            dictionary[key] = nil
            self = .dictionary(dictionary)
        } else {
            guard var next = try? self.get(at: first) else {
                throw MapError.valueNotFound
            }
            try next.remove(at: indexPath)
            try self.set(value: next, merging: false, at: [first])
        }
    }
}

// MARK: Subscripts

extension Map {
    public subscript(indexPath: IndexPathElement...) -> Map? {
        get {
            return self[indexPath]
        }

        set(value) {
            self[indexPath] = value
        }
    }

    public subscript(indexPath: [IndexPathElement]) -> Map? {
        get {
            return try? self.get(at: indexPath)
        }

        set(value) {
            do {
                if let value = value {
                    try self.set(value: value, at: indexPath)
                } else {
                    try self.remove(at: indexPath)
                }
            } catch {
                fatalError(String(describing: error))
            }
        }
    }
}

// MARK: Equatable

extension Map : Equatable {}

public func == (lhs: Map, rhs: Map) -> Bool {
    switch (lhs, rhs) {
    case (.null, .null): return true
    case let (.int(l), .int(r)) where l == r: return true
    case let (.bool(l), .bool(r)) where l == r: return true
    case let (.string(l), .string(r)) where l == r: return true
    case let (.data(l), .data(r)) where l == r: return true
    case let (.double(l), .double(r)) where l == r: return true
    case let (.array(l), .array(r)) where l == r: return true
    case let (.dictionary(l), .dictionary(r)) where l == r: return true
    default: return false
    }
}

// MARK: Literal Convertibles

extension Map : ExpressibleByNilLiteral {
    public init(nilLiteral value: Void) {
        self = .null
    }
}

extension Map : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .bool(value)
    }
}

extension Map : ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .int(value)
    }
}

extension Map : ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self = .double(value)
    }
}

extension Map : ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: String) {
        self = .string(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self = .string(value)
    }

    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

extension Map : ExpressibleByStringInterpolation {
    public init(stringInterpolation strings: Map...) {
        self = .string(strings.reduce("") { $0 + $1.asString! })
    }

    public init<T>(stringInterpolationSegment expr: T) {
        self = .string(String(describing: expr))
    }
}

extension Map : ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Map...) {
        self = .array(elements)
    }
}

extension Map : ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Map)...) {
        var dictionary = [String: Map](minimumCapacity: elements.count)

        for (key, value) in elements {
            dictionary[key] = value
        }

        self = .dictionary(dictionary)
    }
}

// MARK: CustomStringConvertible

extension Map : CustomStringConvertible {
    public var description: String {
        let escapeMapping: [Character: String] = [
             "\r": "\\r",
             "\n": "\\n",
             "\t": "\\t",
             "\\": "\\\\",
             "\"": "\\\"",

             "\u{2028}": "\\u2028",
             "\u{2029}": "\\u2029",

             "\r\n": "\\r\\n"
        ]

        func escape(_ source: String) -> String {
            var string = "\""

            for character in source.characters {
                if let escapedSymbol = escapeMapping[character] {
                    string.append(escapedSymbol)
                } else {
                    string.append(character)
                }
            }
            
            string.append("\"")
            return string
        }

        func serialize(map: Map) -> String {
            switch map {
            case .null: return "null"
            case .bool(let bool): return String(bool)
            case .double(let number): return String(number)
            case .int(let number): return String(number)
            case .string(let string): return escape(string)
            case .data(let data): return "0x" + data.hexadecimalString()
            case .array(let array): return serialize(array: array)
            case .dictionary(let dictionary): return serialize(dictionary: dictionary)
            }
        }

        func serialize(array: [Map]) -> String {
            var string = "["

            for index in 0 ..< array.count {
                string += serialize(map: array[index])

                if index != array.count - 1 {
                    string += ","
                }
            }

            return string + "]"
        }

        func serialize(dictionary: [String: Map]) -> String {
            var string = "{"
            var index = 0

            for (key, value) in dictionary.sorted(by: {$0.0 < $1.0}) {
                string += escape(key) + ":" + serialize(map: value)

                if index != dictionary.count - 1 {
                    string += ","
                }

                index += 1
            }

            return string + "}"
        }

        return serialize(map: self)
    }
}
