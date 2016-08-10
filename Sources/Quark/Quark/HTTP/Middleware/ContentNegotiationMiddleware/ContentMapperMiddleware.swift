extension MapInitializable {
    public static var key: String {
        return String(reflecting: self)
    }
}

public struct ContentMapperMiddleware : Middleware {
    let type: MapInitializable.Type

    public init(mappingTo type: MapInitializable.Type) {
        self.type = type
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard let content = request.content else {
            return try next.respond(to: request)
        }

        var request = request

        do {
            let target = try type.init(map: content)
            request.storage[type.key] = target
        } catch MapError.incompatibleType {
            throw ClientError.badRequest
        }

        return try next.respond(to: request)
    }
}
