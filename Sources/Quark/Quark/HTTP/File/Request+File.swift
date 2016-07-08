extension Request {
    public init(method: Method = .get, uri: URI = URI(path: "/"), headers: Headers = [:], filePath: String, file: FileProtocol.Type) throws {
        do {
            let file = try file.init(path: filePath, mode: .read)
            self.init(method: method, uri: uri, headers: headers, body: file.stream)

            if let fileExtension = file.fileExtension, mediaType = mediaType(forFileExtension: fileExtension) {
                    self.contentType = mediaType
            }
        } catch {
            throw ClientError.notFound
        }
    }
}
