public struct FileResponder : Responder {
    let path: String
    let headers: Headers
    let fileType: C7.File.Type

    public init(path: String, headers: Headers = [:], fileType: C7.File.Type) {
        self.path = path
        self.headers = headers
        self.fileType = fileType
    }

    public func respond(to request: Request) throws -> Response {
        if request.method != .get {
            throw ClientError.methodNotAllowed
        }

        guard let filepath = request.path else {
            throw ServerError.internalServerError
        }

        return try Response(status: .ok, headers: headers, filePath: self.path + filepath, fileType: fileType)
    }
}
