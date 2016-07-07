public struct FileResponder : Responder {
    let path: String
    let headers: Headers

    public init(path: String, headers: Headers = [:]) {
        self.path = path
        self.headers = headers
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
        return try Response(status: .ok, headers: headers, filePath: self.path + path)
    }
}

extension Response {
    public init(status: Status = .ok, headers: Headers = [:], filePath: String) throws {
        do {
            let file = try File(path: filePath, mode: .read)
            self.init(status: status, headers: headers, body: file.stream)

            if let fileExtension = file.fileExtension, mediaType = mediaType(forFileExtension: fileExtension) {
                    self.contentType = mediaType
            }
        } catch {
            throw ClientError.notFound
        }
    }
}
