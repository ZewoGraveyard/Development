public struct FileResponder : Responder {
    let path: String
    let headers: Headers
    let file: FileProtocol.Type

    public init(path: String, headers: Headers = [:], file: FileProtocol.Type) {
        self.path = path
        self.headers = headers
        self.file = file
    }

    public func respond(to request: Request) throws -> Response {
        if request.method != .get {
            throw ClientError.methodNotAllowed
        }

        guard let requestPath = request.path else {
            throw ServerError.internalServerError
        }

        var path = requestPath

        if path.ends(with: "/") {
            path += "index.html"
        }
        return try Response(status: .ok, headers: headers, filePath: self.path + path, file: file)
    }
}
