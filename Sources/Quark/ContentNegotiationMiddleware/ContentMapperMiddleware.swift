extension StructuredDataInitializable {
    public static var key: String {
        return String(reflecting: self)
    }
}

public struct ContentMapperMiddleware : Middleware {
    let type: StructuredDataInitializable.Type

    public init(mappingTo type: StructuredDataInitializable.Type) {
        self.type = type
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard let content = request.content else {
            return try next.respond(to: request)
        }

        var request = request

        do {
            let target = try type.init(structuredData: content)
            request.storage[type.key] = target
        } catch StructuredDataError.incompatibleType {
            throw ClientError.badRequest
        } catch {
            throw error
        }

        return try next.respond(to: request)
    }
}
