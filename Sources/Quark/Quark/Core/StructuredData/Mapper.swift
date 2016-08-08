public enum MapperError : Error {
    case cantInitFromRawValue
    case noStrutcuredData(key: String)
    case incompatibleSequence
}

public final class Mapper {
    public init(structuredData: StructuredData) {
        self.structuredData = structuredData
    }

    fileprivate let structuredData: StructuredData
}

extension Mapper {
    public func map<T>(from key: String) throws -> T {
        let value: T = try structuredData.get(at: key)
        return value
    }

    public func map<T: StructuredDataInitializable>(from key: String) throws -> T {
        if let nested = structuredData[key] {
            return try unwrap(T(structuredData: nested))
        }
        throw MapperError.noStrutcuredData(key: key)
    }

    public func map<T: RawRepresentable>(from key: String) throws -> T where T.RawValue: StructuredDataInitializable {
        guard let rawValue = try structuredData[key].flatMap({ try T.RawValue(structuredData: $0) }) else {
            throw MapperError.cantInitFromRawValue
        }
        if let value = T(rawValue: rawValue) {
            return value
        }
        throw MapperError.cantInitFromRawValue
    }
}

extension Mapper {
    public func map<T>(arrayFrom key: String) throws -> [T] {
        return try structuredData.flatMapThrough(key) { try $0.get() as T }
    }

    public func map<T>(arrayFrom key: String) throws -> [T] where T: StructuredDataInitializable {
        return try structuredData.flatMapThrough(key) { try? T(structuredData: $0) }
    }

    public func map<T: RawRepresentable>(arrayFrom key: String) throws -> [T] where
        T.RawValue: StructuredDataInitializable {
        return try structuredData.flatMapThrough(key) {
            return (try? T.RawValue(structuredData: $0)).flatMap({ T(rawValue: $0) })
        }
    }
}

extension Mapper {
    public func map<T>(optionalFrom key: String) -> T? {
        do {
            return try map(from: key)
        } catch {
            return nil
        }
    }

    public func map<T: StructuredDataInitializable>(optionalFrom key: String) -> T? {
        if let nested = structuredData[key] {
            return try? T(structuredData: nested)
        }
        return nil
    }

    public func map<T: RawRepresentable>(optionalFrom key: String) -> T? where T.RawValue: StructuredDataInitializable {
        do {
            if let rawValue = try structuredData[key].flatMap({ try T.RawValue(structuredData: $0) }),
                let value = T(rawValue: rawValue) {
                return value
            }
            return nil
        } catch {
            return nil
        }
    }
}

extension Mapper {
    public func map<T>(optionalArrayFrom key: String) -> [T]? {
        return try? structuredData.flatMapThrough(key) { try $0.get() as T }
    }

    public func map<T>(optionalArrayFrom key: String) -> [T]? where T: StructuredDataInitializable {
        return try?  structuredData.flatMapThrough(key) { try? T(structuredData: $0) }
    }

    public func map<T: RawRepresentable>(optionalArrayFrom key: String) -> [T]? where
        T.RawValue: StructuredDataInitializable {
        return try? structuredData.flatMapThrough(key) {
            return (try? T.RawValue(structuredData: $0)).flatMap({ T(rawValue: $0) })
        }
    }
}

public enum UnwrapError: Error {
    case tryingToUnwrapNil
}

extension Mapper {
    fileprivate func unwrap<T>(_ optional: T?) throws -> T {
        if let nonoptional = optional {
            return nonoptional
        }
        throw UnwrapError.tryingToUnwrapNil
    }
}
