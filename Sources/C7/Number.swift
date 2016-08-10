public enum Number {
    case int(Int)
    case int8(Int8)
    case int16(Int16)
    case int32(Int32)
    case int64(Int64)

    case uint(UInt)
    case uint8(UInt8)
    case uint16(UInt16)
    case uint32(UInt32)
    case uint64(UInt64)

    case float(Float)
    case double(Double)
}

extension Number {
    init(_ value: Int) {
        self = .int(value)
    }

    init(_ value: Int8) {
        self = .int8(value)
    }

    init(_ value: Int16) {
        self = .int16(value)
    }

    init(_ value: Int32) {
        self = .int32(value)
    }

    init(_ value: Int64) {
        self = .int64(value)
    }

    init(_ value: UInt) {
        self = .uint(value)
    }

    init(_ value: UInt8) {
        self = .uint8(value)
    }

    init(_ value: UInt16) {
        self = .uint16(value)
    }

    init(_ value: UInt32) {
        self = .uint32(value)
    }

    init(_ value: UInt64) {
        self = .uint64(value)
    }

    init(_ value: Float) {
        self = .float(value)
    }

    init(_ value: Double) {
        self = .double(value)
    }
}

extension Int {
    init?(_ number: Number) {
        switch number {
        case let .int(value)                                           : self.init(value)
        case let .int8(value)                                          : self.init(value)
        case let .int16(value)                                         : self.init(value)
        case let .int32(value)                                         : self.init(value)
        case let .int64(value)  where value <= Int64(Int.max)          : self.init(value)
        case let .uint(value)   where value <= UInt(Int.max)           : self.init(value)
        case let .uint8(value)                                         : self.init(value)
        case let .uint16(value)                                        : self.init(value)
        case let .uint32(value) where UInt64(value) <= UInt64(Int.max) : self.init(value)
        case let .uint64(value) where value <= UInt64(Int.max)         : self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(Int16.max)        : self.init(value)
        case let .double(value) where value <= Double(Int32.max)       : self.init(value)
        default: return nil
        }
    }
}

extension Int8 {
    init?(_ number: Number) {
        switch number {
        case let .int(value)    where value <= Int(Int8.max)   : self.init(value)
        case let .int8(value)                                  : self.init(value)
        case let .int16(value)  where value <= Int16(Int8.max) : self.init(value)
        case let .int32(value)  where value <= Int32(Int8.max) : self.init(value)
        case let .int64(value)  where value <= Int64(Int8.max) : self.init(value)
        case let .uint(value)   where value <= UInt(Int8.max)  : self.init(value)
        case let .uint8(value)                                 : self.init(value)
        case let .uint16(value) where value <= UInt16(Int8.max): self.init(value)
        case let .uint32(value) where value <= UInt32(Int8.max): self.init(value)
        case let .uint64(value) where value <= UInt64(Int8.max): self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(Int8.max) : self.init(value)
        case let .double(value) where value <= Double(Int8.max): self.init(value)
        default: return nil
        }
    }
}

extension Int16 {
    public init?(_ number: Number) {
        switch number {
        case let .int(value)    where value <= Int(Int16.max)    : self.init(value)
        case let .int8(value)                                    : self.init(value)
        case let .int16(value)                                   : self.init(value)
        case let .int32(value)  where value <= Int32(Int16.max)  : self.init(value)
        case let .int64(value)  where value <= Int64(Int16.max)  : self.init(value)
        case let .uint(value)   where value <= UInt(Int16.max)   : self.init(value)
        case let .uint8(value)                                   : self.init(value)
        case let .uint16(value)                                  : self.init(value)
        case let .uint32(value) where value <= UInt32(Int16.max) : self.init(value)
        case let .uint64(value) where value <= UInt64(Int16.max) : self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(Int16.max)  : self.init(value)
        case let .double(value) where value <= Double(Int16.max) : self.init(value)
        default: return nil
        }
    }
}

extension Int32 {
    init?(_ number: Number) {
        switch number {
        case let .int(value)    where value <= Int(Int32.max)    : self.init(value)
        case let .int8(value)                                    : self.init(value)
        case let .int16(value)                                   : self.init(value)
        case let .int32(value)                                   : self.init(value)
        case let .int64(value)  where value <= Int64(Int32.max)  : self.init(value)
        case let .uint(value)   where value <= UInt(Int32.max)   : self.init(value)
        case let .uint8(value)                                   : self.init(value)
        case let .uint16(value)                                  : self.init(value)
        case let .uint32(value)                                  : self.init(value)
        case let .uint64(value) where value <= UInt64(Int32.max) : self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(Int16.max)  : self.init(value)
        case let .double(value) where value <= Double(Int32.max) : self.init(value)
        default: return nil
        }
    }
}

extension Int64 {
    init?(_ number: Number) {
        switch number {
        case let .int(value)                                             : self.init(value)
        case let .int8(value)                                            : self.init(value)
        case let .int16(value)                                           : self.init(value)
        case let .int32(value)                                           : self.init(value)
        case let .int64(value)                                           : self.init(value)
        case let .uint(value)   where UInt64(value) <= UInt64(Int64.max) : self.init(value)
        case let .uint8(value)                                           : self.init(value)
        case let .uint16(value)                                          : self.init(value)
        case let .uint32(value)                                          : self.init(value)
        case let .uint64(value) where value <= UInt64(Int64.max)         : self.init(value)
        // TODO: review
        case let .float(value)  where Double(value) <= Double(Int32.max) : self.init(value)
        case let .double(value) where value <= Double(Int32.max)         : self.init(value)
        default: return nil
        }
    }
}

extension UInt {
    init?(_ number: Number) {
        switch number {
        case let .int(value)    where value >= 0                                      : self.init(value)
        case let .int8(value)   where value >= 0                                      : self.init(value)
        case let .int16(value)  where value >= 0                                      : self.init(value)
        case let .int32(value)  where value >= 0                                      : self.init(value)
        case let .int64(value)  where value >= 0 && UInt64(value) <= UInt64(UInt.max) : self.init(value)
        case let .uint(value)                                                         : self.init(value)
        case let .uint8(value)                                                        : self.init(value)
        case let .uint16(value)                                                       : self.init(value)
        case let .uint32(value)                                                       : self.init(value)
        case let .uint64(value) where value <= UInt64(UInt.max)                       : self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(UInt16.max)                      : self.init(value)
        case let .double(value) where value <= Double(UInt32.max)                     : self.init(value)
        default: return nil
        }
    }
}

extension UInt8 {
    init?(_ number: Number) {
        switch number {
        case let .int(value)    where value >= 0 && UInt(value) <= UInt(UInt8.max) : self.init(value)
        case let .int8(value)   where value >= 0                                   : self.init(value)
        case let .int16(value)  where value >= 0 && value <= Int16(UInt8.max)      : self.init(value)
        case let .int32(value)  where value >= 0 && value <= Int32(UInt8.max)      : self.init(value)
        case let .int64(value)  where value >= 0 && value <= Int64(UInt8.max)      : self.init(value)
        case let .uint(value)   where value <= UInt(UInt8.max)                     : self.init(value)
        case let .uint8(value)                                                     : self.init(value)
        case let .uint16(value) where value <= UInt16(UInt8.max)                   : self.init(value)
        case let .uint32(value) where value <= UInt32(UInt8.max)                   : self.init(value)
        case let .uint64(value) where value <= UInt64(UInt8.max)                   : self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(UInt8.max)                    : self.init(value)
        case let .double(value) where value <= Double(UInt8.max)                   : self.init(value)
        default: return nil
        }
    }
}

extension UInt16 {
    init?(_ number: Number) {
        switch number {
        case let .int(value)    where value >= 0 && UInt(value) <= UInt(UInt16.max) : self.init(value)
        case let .int8(value)   where value >= 0                                    : self.init(value)
        case let .int16(value)  where value >= 0                                    : self.init(value)
        case let .int32(value)  where value >= 0 && value <= Int32(UInt16.max)      : self.init(value)
        case let .int64(value)  where value >= 0 && value <= Int64(UInt16.max)      : self.init(value)
        case let .uint(value)   where value <= UInt(UInt16.max)                     : self.init(value)
        case let .uint8(value)                                                      : self.init(value)
        case let .uint16(value)                                                     : self.init(value)
        case let .uint32(value) where value <= UInt32(UInt16.max)                   : self.init(value)
        case let .uint64(value) where value <= UInt64(UInt16.max)                   : self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(UInt16.max)                    : self.init(value)
        case let .double(value) where value <= Double(UInt16.max)                   : self.init(value)
        default: return nil
        }
    }
}

extension UInt32 {
    init?(_ number: Number) {
        switch number {
        case let .int(value)    where value >= 0 && UInt(value) <= UInt(UInt32.max) : self.init(value)
        case let .int8(value)   where value >= 0                                    : self.init(value)
        case let .int16(value)  where value >= 0                                    : self.init(value)
        case let .int32(value)  where value >= 0                                    : self.init(value)
        case let .int64(value)  where value >= 0 && value <= Int64(UInt32.max)      : self.init(value)
        case let .uint(value)   where value <= UInt(UInt32.max)                     : self.init(value)
        case let .uint8(value)                                                      : self.init(value)
        case let .uint16(value)                                                     : self.init(value)
        case let .uint32(value)                                                     : self.init(value)
        case let .uint64(value) where value <= UInt64(UInt32.max)                   : self.init(value)
        // TODO: review
        case let .float(value)  where value <= Float(UInt16.max)                    : self.init(value)
        case let .double(value) where value <= Double(UInt32.max)                   : self.init(value)
        default: return nil
        }
    }
}

extension UInt64 {
    init?(_ number: Number) {
        switch number {
        case let .int(value)    where value >= 0                         : self.init(value)
        case let .int8(value)   where value >= 0                         : self.init(value)
        case let .int16(value)  where value >= 0                         : self.init(value)
        case let .int32(value)  where value >= 0                         : self.init(value)
        case let .int64(value)  where value >= 0                         : self.init(value)
        case let .uint(value)                                            : self.init(value)
        case let .uint8(value)                                           : self.init(value)
        case let .uint16(value)                                          : self.init(value)
        case let .uint32(value)                                          : self.init(value)
        case let .uint64(value)                                          : self.init(value)
        // TODO: review
        case let .float(value)  where Double(value) <= Double(Int32.max) : self.init(value)
        case let .double(value) where value <= Double(Int32.max)         : self.init(value)
        default: return nil
        }
    }
}

extension Float {
    init(_ number: Number) {
        switch number {
        case let .int(value)    : self.init(value)
        case let .int8(value)   : self.init(value)
        case let .int16(value)  : self.init(value)
        case let .int32(value)  : self.init(value)
        case let .int64(value)  : self.init(value)
        case let .uint(value)   : self.init(value)
        case let .uint8(value)  : self.init(value)
        case let .uint16(value) : self.init(value)
        case let .uint32(value) : self.init(value)
        case let .uint64(value) : self.init(value)
        // TODO: review
        case let .float(value)  : self.init(value)
        case let .double(value) : self.init(value)
        }
    }
}

extension Double {
    init(_ number: Number) {
        switch number {
        case let .int(value)    : self.init(value)
        case let .int8(value)   : self.init(value)
        case let .int16(value)  : self.init(value)
        case let .int32(value)  : self.init(value)
        case let .int64(value)  : self.init(value)
        case let .uint(value)   : self.init(value)
        case let .uint8(value)  : self.init(value)
        case let .uint16(value) : self.init(value)
        case let .uint32(value) : self.init(value)
        case let .uint64(value) : self.init(value)
        // TODO: review
        case let .float(value)  : self.init(value)
        case let .double(value) : self.init(value)
        }
    }
}
