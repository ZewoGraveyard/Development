extension Response {
    public init(status: Status = .ok, headers: Headers = [:], filePath: String, fileType: FileProtocol.Type) throws {
        do {
            var filePath = filePath
            let file: FileProtocol

            if filePath.split(separator: ".").count == 1 {
                filePath += ".html"
            }

            do {
                file = try fileType.init(path: filePath, mode: .read)
            } catch {
                file = try fileType.init(path: filePath + "html", mode: .read)
            }

            self.init(status: status, headers: headers, body: file.stream)

            if let fileExtension = file.fileExtension, mediaType = mediaType(forFileExtension: fileExtension) {
                self.contentType = mediaType
            }
        } catch {
            throw ClientError.notFound
        }
    }
}
