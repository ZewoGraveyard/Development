public struct ResponseSerializer : S4.ResponseSerializer {
    let stream: Stream

    public init(stream: Stream) {
        self.stream = stream
    }

    public func serialize(_ response: Response) throws {
        let newLine: Data = [13, 10]

        try stream.write("HTTP/\(response.version.major).\(response.version.minor) \(response.status.statusCode) \(response.status.reasonPhrase)")
        try stream.write(newLine)

        for (name, value) in response.headers.headers {
            try stream.write("\(name): \(value)")
            try stream.write(newLine)
        }

        for cookie in response.cookieHeaders {
            try stream.write("Set-Cookie: \(cookie)".data)
            try stream.write(newLine)
        }

        try stream.write(newLine)

        switch response.body {
        case .buffer(let buffer):
            try stream.write(buffer)
        case .reader(let reader):
            while !reader.closed {
                let data = try reader.read(upTo: 2014)

                if data.isEmpty {
                    break
                }
                
                try stream.write(String(data.count, radix: 16).data)
                try stream.write(newLine)
                try stream.write(data)
                try stream.write(newLine)
            }

            try stream.write("0")
            try stream.write(newLine)
            try stream.write(newLine)
        case .writer(let writer):
            let body = BodyStream(stream)
            try writer(body)

            try stream.write("0")
            try stream.write(newLine)
            try stream.write(newLine)
        default:
            throw BodyError.inconvertibleType
        }

        try stream.flush()
    }
}
