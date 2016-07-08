public struct LocationInfo {
    public let file: String
    public let line: Int
    public let column: Int
    public let function: String
}

extension LocationInfo: CustomStringConvertible {
    public var description: String {
        return "\(file):\(function):\(line):\(column)"
    }
}
