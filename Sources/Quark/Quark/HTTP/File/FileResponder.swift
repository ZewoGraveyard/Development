public struct FileResponder : Responder {
    let path: String
    let headers: Headers
    let fileType: FileProtocol.Type

    public init(path: String, headers: Headers = [:], fileType: FileProtocol.Type) {
        self.path = path
        self.headers = headers
        self.fileType = fileType
    }

    public func respond(to request: Request) throws -> Response {
        if request.method != .get {
            throw ClientError.methodNotAllowed
        }

        guard let path = request.path else {
            throw ServerError.internalServerError
        }

        return try Response(status: .ok, headers: headers, filePath: self.path + path, fileType: fileType)
    }
}
