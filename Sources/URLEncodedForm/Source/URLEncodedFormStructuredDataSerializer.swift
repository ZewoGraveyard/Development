// URLEncodedFormStructuredDataSerializer.swift
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

import StructuredData

public struct URLEncodedFormStructuredDataSerializer: StructuredDataSerializer {
    enum Error: ErrorProtocol {
        case invalidStructuredData
    }

    public init() {}

    public func serialize(_ structuredData: StructuredData) throws -> Data {
        return try serializeToString(structuredData).data
    }

    public func serializeToString(_ structuredData: StructuredData) throws -> String {
        switch structuredData {
        case .dictionary(let dictionary): return try serializeDictionary(dictionary)
        default: throw Error.invalidStructuredData
        }
    }

    func serializeDictionary(_ object: [String: StructuredData]) throws -> String {
        var string = ""

        for (offset: index, element: (key: key, value: structuredData)) in object.enumerated() {
            if index != 0 {
                string += "&"
            }
            string += "\(key)="
            let value = try structuredData.asString(converting: true)
            string += try value.percentEncoded(allowing: .uriQueryAllowed)
        }

        return string
    }
}
