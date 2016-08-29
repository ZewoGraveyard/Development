@_exported import struct Foundation.Data

public typealias Byte = UInt8

public protocol DataInitializable {
    init(data: Data) throws
}

public protocol DataRepresentable {
    var data: Data { get }
}

extension Data : DataRepresentable {
    public var data: Data {
        return self
    }
}

public protocol DataConvertible : DataInitializable, DataRepresentable {}

#if os(Linux)
extension Data : RangeReplaceableCollection {
    public mutating func replaceSubrange<ByteCollection : Collection>(_ subrange: Range<Index>, with newElements: ByteCollection) where ByteCollection.Iterator.Element == Data.Iterator.Element {
        // Calculate this once, it may not be O(1)
        let replacementCount : Int = numericCast(newElements.count)
        let currentCount = self.count
        let subrangeCount = subrange.count

        if currentCount < subrange.lowerBound + subrangeCount {
            if subrangeCount == 0 {
                preconditionFailure("location \(subrange.lowerBound) exceeds data count \(currentCount)")
            } else {
                preconditionFailure("range \(subrange) exceeds data count \(currentCount)")
            }
        }

        let resultCount = currentCount - subrangeCount + replacementCount
        if resultCount != currentCount {
            // This may realloc.
            // In the future, if we keep the malloced pointer and count inside this struct/ref instead of deferring to NSData, we may be able to do this more efficiently.
            self.count = resultCount
        }

        let shift = resultCount - currentCount
        let start = subrange.lowerBound

        self.withUnsafeMutableBytes { (bytes : UnsafeMutablePointer<UInt8>) -> () in
            if shift != 0 {
                let destination = bytes + start + replacementCount
                let source = bytes + start + subrangeCount
                memmove(destination, source, currentCount - start - subrangeCount)
            }

            if replacementCount != 0 {
                newElements._copyContents(initializing: bytes + start)
            }
        }
    }
}
#endif

extension Data {
    public init(_ string: String) {
        self = Data(string.utf8)
    }
}

extension String : DataConvertible {
    public init(data: Data) throws {
        guard let string = String(data: data, encoding: String.Encoding.utf8) else {
            throw StringError.invalidString
        }
        self = string
    }

    public var data: Data {
        return Data(self)
    }
}

extension Data {
    public func hexadecimalString(inGroupsOf characterCount: Int = 0) -> String {
        var string = ""
        for (index, value) in self.enumerated() {
            if characterCount != 0 && index > 0 && index % characterCount == 0 {
                string += " "
            }
            string += (value < 16 ? "0" : "") + String(value, radix: 16)
        }
        return string
    }

    public var hexadecimalDescription: String {
        return hexadecimalString(inGroupsOf: 2)
    }
}
