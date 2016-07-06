// MustacheSerializer.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

public struct MustacheSerializer: StructuredDataSerializer {
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
