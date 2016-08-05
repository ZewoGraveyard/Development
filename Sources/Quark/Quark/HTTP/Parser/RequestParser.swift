import CHTTPParser

typealias RequestContext = UnsafeMutablePointer<RequestParserContext>

struct RequestParserContext {
    var method: Method! = nil
    var uri: URI! = nil
    var version: Version = Version(major: 0, minor: 0)
    var headers: Headers = Headers([:])
    var body: Data = []

    var currentURI = ""
    var buildingHeaderName = ""
    var currentHeaderName: CaseInsensitiveString = ""
    var completion: (Request) -> Void

    init(completion: (Request) -> Void) {
        self.completion = completion
    }
}

var requestSettings: http_parser_settings = {
    var settings = http_parser_settings()
    http_parser_settings_init(&settings)

    settings.on_url              = onRequestURL
    settings.on_header_field     = onRequestHeaderField
    settings.on_header_value     = onRequestHeaderValue
    settings.on_headers_complete = onRequestHeadersComplete
    settings.on_body             = onRequestBody
    settings.on_message_complete = onRequestMessageComplete

    return settings
}()

public final class RequestParser : S4.RequestParser {
    let stream: Stream
    let context: RequestContext
    var parser = http_parser()
    var requests: [Request] = []
    let bufferSize: Int

    convenience public init(stream: Stream) {
        self.init(stream: stream, bufferSize: 2048)
    }

    public init(stream: Stream, bufferSize: Int) {
        self.stream = stream
        self.bufferSize = bufferSize
        self.context = RequestContext(allocatingCapacity: 1)
        self.context.initialize(with: RequestParserContext { request in
            self.requests.insert(request, at: 0)
        })

        resetParser()
    }

    deinit {
        context.deallocateCapacity(1)
    }

    func resetParser() {
        http_parser_init(&parser, HTTP_REQUEST)
        parser.data = UnsafeMutablePointer<Void>(context)
    }

    public func parse() throws -> Request {
        while true {
            if let request = requests.popLast() {
                return request
            }

            let data = try stream.read(upTo: bufferSize)
            let bytesParsed = http_parser_execute(&parser, &requestSettings, UnsafePointer(data.bytes), data.count)

            guard bytesParsed == data.count else {
                defer { resetParser() }
                throw http_errno(parser.http_errno)
            }
        }
    }
}

func onRequestURL(_ parser: Parser?, data: UnsafePointer<Int8>?, length: Int) -> Int32 {
    return RequestContext(parser!.pointee.data).withPointee {
        let uri = String(cString: data!, length: length)
        $0.currentURI += uri
        return 0
    }
}

func onRequestHeaderField(_ parser: Parser?, data: UnsafePointer<Int8>?, length: Int) -> Int32 {
    return RequestContext(parser!.pointee.data).withPointee {
        let headerName = String(cString: data!, length: length)

        if $0.currentHeaderName != "" {
            $0.currentHeaderName = ""
        }

        $0.buildingHeaderName += headerName
        return 0
    }
}

func onRequestHeaderValue(_ parser: Parser?, data: UnsafePointer<Int8>?, length: Int) -> Int32 {
    return RequestContext(parser!.pointee.data).withPointee {
        let headerValue = String(cString: data!, length: length)

        if $0.currentHeaderName == "" {
            $0.currentHeaderName = CaseInsensitiveString($0.buildingHeaderName)
            $0.buildingHeaderName = ""

            if let previousHeaderValue = $0.headers[$0.currentHeaderName] {
                $0.headers[$0.currentHeaderName] = previousHeaderValue + ", "
            }
        }

        let previousHeaderValue = $0.headers[$0.currentHeaderName] ?? ""
        $0.headers[$0.currentHeaderName] = previousHeaderValue + headerValue

        return 0
    }
}

func onRequestHeadersComplete(_ parser: Parser?) -> Int32 {
    return RequestContext(parser!.pointee.data).withPointee {
        $0.method = Method(code: Int(parser!.pointee.method))
        let major = Int(parser!.pointee.http_major)
        let minor = Int(parser!.pointee.http_minor)
        $0.version = Version(major: major, minor: minor)

        $0.uri = try! URI($0.currentURI)
        $0.currentURI = ""
        $0.buildingHeaderName = ""
        $0.currentHeaderName = ""
        return 0
    }
}

func onRequestBody(_ parser: Parser?, data: UnsafePointer<Int8>?, length: Int) -> Int32 {
    RequestContext(parser!.pointee.data).withPointee {
        let buffer = UnsafeBufferPointer<UInt8>(start: UnsafePointer(data), count: length)
        $0.body += Data(Array(buffer))
        return
    }

    return 0
}

func onRequestMessageComplete(_ parser: Parser?) -> Int32 {
    return RequestContext(parser!.pointee.data).withPointee {
        let request = Request(
            method: $0.method,
            uri: $0.uri,
            version: $0.version,
            headers: $0.headers,
            body: .buffer($0.body)
        )

        $0.completion(request)

        $0.method = nil
        $0.uri = nil
        $0.version = Version(major: 0, minor: 0)
        $0.headers = Headers([:])
        $0.body = []
        return 0
    }
}
