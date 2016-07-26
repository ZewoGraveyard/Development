import Mustache

public enum MustacheSerializerError : ErrorProtocol {
    case unsupportedTemplateEncoding
}

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
    let fileType: FileProtocol.Type

    public init(templatePath: String, fileType: FileProtocol.Type) {
        self.templatePath = templatePath
        self.fileType = fileType
    }

    public func serialize(_ structuredData: StructuredData) throws -> Data {
        let templateFile = try fileType.init(path: templatePath)

        guard let templateString = try? String(data: templateFile.readAllBytes()) else {
            throw MustacheSerializerError.unsupportedTemplateEncoding
        }

        let template = try Template(string: templateString)
        let rendering = try template.render(box: structuredData.mustacheBox)
        return rendering.data
    }
}
