public protocol MapInitializable {
    init(map: Map) throws
}

public protocol MapRepresentable : MapFallibleRepresentable {
    var map: Map { get }
}

public protocol MapFallibleRepresentable {
    func asMap() throws -> Map
}

extension MapRepresentable {
    public func asMap() throws -> Map {
        return map
    }
}

public protocol MapConvertible : MapInitializable, MapRepresentable {}

public enum Map {
    case null
    case bool(Bool)
    case double(Double)
    case int(Int)
    case string(String)
    case data(Data)
    case array([Map])
    case dictionary([String: Map])
}
