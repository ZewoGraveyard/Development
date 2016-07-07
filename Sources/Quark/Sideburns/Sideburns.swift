public typealias TemplateData = MustacheBoxable

public enum SideburnsError: ErrorProtocol {
	case unsupportedTemplateEncoding
}

extension Response {
    public init(status: Status = .ok, headers: Headers = [:], templatePath: String, templateData: TemplateData) throws {
        let templateFile = try File(path: templatePath, mode: .read)

        guard let templateString = try? String(data: templateFile.readAllBytes()) else {
            throw SideburnsError.unsupportedTemplateEncoding
        }

        let template = try Template(string: templateString)
        let rendering = try template.render(box: Box(boxable: templateData))

        self.init(status: status, headers: headers, body: rendering)

        if let fileExtension = templateFile.fileExtension, mediaType = mediaType(forFileExtension: fileExtension) {
            self.contentType = mediaType
        }
    }
}
