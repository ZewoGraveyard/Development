public protocol PathParameterInitializable {
    init(pathParameter: String) throws
}

extension String : PathParameterInitializable {
    public init(pathParameter: String) throws {
        self.init(pathParameter)
    }
}

extension Int : PathParameterInitializable {
    public init(pathParameter: String) throws {
        guard let int = Int(pathParameter) else {
            throw ClientError.badRequest
        }
        self.init(int)
    }
}
