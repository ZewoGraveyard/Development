public struct RequestSerializer : S4.RequestSerializer {
    let stream: Stream

    public init(stream: Stream) {
        self.stream = stream
    }

    public func serialize(_ request: Request) throws {
        let newLine: Data = [13, 10]

        try stream.write("\(request.method) \(request.uri.percentEncoded()) HTTP/\(request.version.major).\(request.version.minor)")
        try stream.write(newLine)

        for (name, value) in request.headers.headers {
            try stream.write("\(name): \(value)")
            try stream.write(newLine)
        }

        try stream.write(newLine)

        switch request.body {
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
