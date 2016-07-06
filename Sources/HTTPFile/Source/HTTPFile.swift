// FileResponder.swift
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

@_exported import File
@_exported import HTTP

public struct FileResponder: Responder {
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
