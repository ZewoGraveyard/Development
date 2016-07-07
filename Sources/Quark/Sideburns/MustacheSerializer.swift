extension StructuredData : MustacheBoxable {
    public var mustacheBox: MustacheBox {
        switch self {
        case .null:
            return Box()
        case .bool(let bool):
            return Box(boxable: bool)
        case .double(let double):
            return Box(boxable: double)
        case .int(let int):
            return Box(boxable: int)
        case .string(let string):
            return Box(boxable: string)
        case .data(let data):
            return Box(boxable: String(data))
        case .array(let array):
            return Box(boxable: array)
        case .dictionary(let dictionary):
            return Box(boxable: dictionary)
        }
    }
}

public struct MustacheSerializer : StructuredDataSerializer {
    public let templatePath: String

    public init(templatePath: String) {
        self.templatePath = templatePath
    }

    public func serialize(_ structuredData: StructuredData) throws -> Data {
        let templateFile = try File(path: templatePath)

        guard let templateString = try? String(data: templateFile.readAllBytes()) else {
            throw SideburnsError.unsupportedTemplateEncoding
        }

        let template = try Template(string: templateString)
        let rendering = try template.render(box: structuredData.mustacheBox)
        return rendering.data
    }
}
