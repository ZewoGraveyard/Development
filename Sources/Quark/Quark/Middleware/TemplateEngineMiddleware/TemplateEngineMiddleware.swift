public struct TemplateEngineMiddleware : Middleware {
    let serializer: StructuredDataSerializer

    public init(serializer: StructuredDataSerializer) {
        self.serializer = serializer
    }

    private var htmlMediaType: MediaType {
        return MediaType(
            type: "text",
            subtype: "html",
            parameters: ["charset": "utf-8"]
        )
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        var response = try next.respond(to: request)

        if let content = response.content {
            let mediaType = htmlMediaType
            if request.accept.matches(other: mediaType) {
                let body = try serializer.serialize(content)
                response.content = nil
                response.contentType = mediaType
                response.body = .buffer(body)
                response.contentLength = body.count
            }
        }

        return response
    }
}
