// TemplateEngineMiddleware.swift
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

@_exported import HTTP
@_exported import Mapper



public struct TemplateEngineMiddleware: Middleware {
    let serializer: StructuredDataSerializer

    public init(serializer: StructuredDataSerializer) {
        self.serializer = serializer
    }

    private var htmlMediaType: MediaType {
        return MediaType(
            type: "text",
            subtype: "html",
            parameters: ["charset": "utf-8"]
        )
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        var response = try next.respond(to: request)

        if let content = response.content {
            let mediaType = htmlMediaType
            if request.accept.matches(other: mediaType) {
                let body = try serializer.serialize(content)
                response.content = nil
                response.contentType = mediaType
                response.body = .buffer(body)
                response.contentLength = body.count
            }
        }

        return response
    }
}

extension Response {
    public var content: StructuredData? {
        get {
            return storage["content"] as? StructuredData
        }

        set(content) {
            storage["content"] = content
        }
    }
}
