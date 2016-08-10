import Mustache

public enum MustacheSerializerError : Error {
    case unsupportedTemplateEncoding
}

extension Map : MustacheBoxable {
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
            return Box(boxable: String(describing: data))
        case .array(let array):
            var arr: [MustacheBox] = []

            for element in array {
                arr.append(Box(boxable: element))
            }

            return Box(boxable: arr)
        case .dictionary(let dictionary):
            var dict: [String: MustacheBox] = [:]

            for (key, value) in dictionary {
                dict[key] = Box(boxable: value)
            }

            return Box(boxable: dict)
        }
    }
}

public struct MustacheSerializer : MapSerializer {
    public let templatePath: String
    let fileType: C7.File.Type

    public init(templatePath: String, fileType: C7.File.Type) {
        self.templatePath = templatePath
        self.fileType = fileType
    }

    public func serialize(_ map: Map) throws -> Data {
        let templateFile = try fileType.init(path: templatePath)

        guard let templateString = try? String(data: templateFile.readAll()) else {
            throw MustacheSerializerError.unsupportedTemplateEncoding
        }

        let template = try Template(string: templateString)
        let rendering = try template.render(box: Box(boxable: map))
        return rendering.data
    }
}
