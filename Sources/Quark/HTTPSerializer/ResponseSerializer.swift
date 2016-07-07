public struct ResponseSerializer : S4.ResponseSerializer {
    let stream: Stream

    public init(stream: Stream) {
        self.stream = stream
    }

    public func serialize(_ response: Response) throws {
        let newLine: Data = [13, 10]

        try stream.send("HTTP/\(response.version.major).\(response.version.minor) \(response.status.statusCode) \(response.status.reasonPhrase)".data)
        try stream.send(newLine)

        for (name, value) in response.headers.headers {
            try stream.send("\(name): \(value)".data)
            try stream.send(newLine)
        }

        for cookie in response.cookieHeaders {
            try stream.send("Set-Cookie: \(cookie)".data)
            try stream.send(newLine)
        }

        try stream.send(newLine)

        switch response.body {
        case .buffer(let buffer):
            try stream.send(buffer)
        case .receiver(let receiver):
            while !receiver.closed {
                let data = try receiver.receive(upTo: 2014)
                try stream.send(String(data.count, radix: 16).data)
                try stream.send(newLine)
                try stream.send(data)
                try stream.send(newLine)
            }

            try stream.send("0".data)
            try stream.send(newLine)
            try stream.send(newLine)
        case .sender(let sender):
            let body = BodyStream(stream)
            try sender(body)

            try stream.send("0".data)
            try stream.send(newLine)
            try stream.send(newLine)
        default:
            throw BodyError.inconvertibleType
        }

        try stream.flush()
    }
}
