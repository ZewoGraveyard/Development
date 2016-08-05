extension StructuredData {
    internal var mapper: Mapper {
        return Mapper(structuredData: self)
    }
}

extension StructuredData {
    internal func mapThrough<T>(_ transform: (@noescape (StructuredData) throws -> T)) throws -> [T] {
        if let array = self.asArray {
            return try array.map(transform)
        }
        throw StructuredDataError.incompatibleType
    }

    internal func mapThrough<T>(_ key: String, transform: (@noescape (StructuredData) throws -> T)) throws -> [T] {
        if let value = self[key] {
            return try value.mapThrough(transform)
        }
        throw StructuredDataError.incompatibleType
    }

//    internal func mapThrough<T>(index: Int, @noescape transform: (StructuredData throws -> T)) throws -> [T] {
//        if let value = self[index] {
//            return try value.mapThrough(transform)
//        }
//        throw StructuredData.Error.incompatibleType
//    }

    internal func flatMapThrough<T>(_ transform: (@noescape (StructuredData) throws -> T?)) throws -> [T] {
        if let array = self.asArray {
            return try array.flatMap(transform)
        }
        throw StructuredDataError.incompatibleType
    }

    internal func flatMapThrough<T>(_ key: String, transform: (@noescape (StructuredData) throws -> T?)) throws -> [T] {
        if let value = self[key] {
            return try value.flatMapThrough(transform)
        }
        throw StructuredDataError.incompatibleType
    }
}
