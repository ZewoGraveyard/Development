import XCTest
@testable import Quark

class SerializerTestStream : C7.Stream {
    let input: String
    var output = ""
    var receivedText = false
    var closed: Bool = false

    init(input: String? = nil) {
        self.input = input ?? ""
    }

    func close() throws {}

    func flush(deadline: Double) throws {}

    func write(_ data: C7.Data, deadline: Double) throws {
        self.output += String(describing: data)
    }

    func read(upTo byteCount: Int, deadline: Double) throws -> C7.Data {
        guard receivedText else {
            receivedText = true
            return Data(input)
        }
        return Data()
    }
}

class HTTPSerializerTests: XCTestCase {
    func testResponseSerializeBuffer() throws {
        let outStream = SerializerTestStream()
        let serializer = ResponseSerializer(stream: outStream)
        var response = Response(body: "foo")
        response.cookies = [AttributedCookie(name: "foo", value: "bar")]

        try serializer.serialize(response)
        XCTAssertEqual(outStream.output, "HTTP/1.1 200 OK\r\nContent-Length: 3\r\nSet-Cookie: foo=bar\r\n\r\nfoo")
    }

    func testResponseSerializeReaderStream() throws {
        let inStream = SerializerTestStream(input: "foo")
        let outStream = SerializerTestStream()
        let serializer = ResponseSerializer(stream: outStream)
        let response = Response(body: inStream)

        try serializer.serialize(response)
        XCTAssertEqual(outStream.output, "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n3\r\nfoo\r\n0\r\n\r\n")
    }

    func testResponseSerializeWriterStream() throws {
        let outStream = SerializerTestStream()
        let serializer = ResponseSerializer(stream: outStream)

        let response = Response { (stream: C7.OutputStream) in
            try stream.write("foo")
        }

        try serializer.serialize(response)
        XCTAssertEqual(outStream.output, "HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n3\r\nfoo\r\n0\r\n\r\n")
    }

    func testResponseAsyncStreamFails() throws {
        let outStream = SerializerTestStream()
        let serializer = ResponseSerializer(stream: outStream)
        var response = Response()
        response.body = .asyncReader(AsyncDrain())
        XCTAssertThrowsError(try serializer.serialize(response))
    }

    func testRequestSerializeBuffer() throws {
        let outStream = SerializerTestStream()
        let serializer = RequestSerializer(stream: outStream)
        let request = Request(body: "foo")

        try serializer.serialize(request)
        XCTAssertEqual(outStream.output, "GET / HTTP/1.1\r\nContent-Length: 3\r\n\r\nfoo")
    }

    func testRequestSerializeReaderStream() throws {
        let inStream = SerializerTestStream(input: "foo")
        let outStream = SerializerTestStream()
        let serializer = RequestSerializer(stream: outStream)
        let request = Request(body: inStream)

        try serializer.serialize(request)
        XCTAssertEqual(outStream.output, "GET / HTTP/1.1\r\nTransfer-Encoding: chunked\r\n\r\n3\r\nfoo\r\n0\r\n\r\n")
    }

    func testRequestSerializeWriterStream() throws {
        let outStream = SerializerTestStream()
        let serializer = RequestSerializer(stream: outStream)

        let request = Request { (stream: C7.OutputStream) in
            try stream.write("foo")
        }

        try serializer.serialize(request)
        XCTAssertEqual(outStream.output, "GET / HTTP/1.1\r\nTransfer-Encoding: chunked\r\n\r\n3\r\nfoo\r\n0\r\n\r\n")
    }

    func testRequestAsyncStreamFails() throws {
        let outStream = SerializerTestStream()
        let serializer = RequestSerializer(stream: outStream)
        var request = Request()
        request.body = .asyncReader(AsyncDrain())
        XCTAssertThrowsError(try serializer.serialize(request))
    }

    func testBodyStream() throws {
        let transport = Drain()
        let bodyStream = BodyStream(transport)
        bodyStream.close()
        XCTAssertEqual(bodyStream.closed, true)
        do {
            try bodyStream.write([], deadline: .never)
            XCTFail()
        } catch {}
        bodyStream.closed = false
        XCTAssertThrowsError(try bodyStream.read(upTo: 0))
        try bodyStream.flush()
    }
}

extension HTTPSerializerTests {
    static var allTests: [(String, (HTTPSerializerTests) -> () throws -> Void)] {
        return [
            ("testResponseSerializeBuffer", testResponseSerializeBuffer),
            ("testResponseSerializeBuffer", testResponseSerializeReaderStream),
            ("testResponseSerializeBuffer", testResponseSerializeWriterStream),
            ("testResponseSerializeBuffer", testResponseAsyncStreamFails),
            ("testResponseSerializeBuffer", testRequestSerializeBuffer),
            ("testResponseSerializeBuffer", testRequestSerializeReaderStream),
            ("testResponseSerializeBuffer", testRequestSerializeWriterStream),
            ("testResponseSerializeBuffer", testRequestAsyncStreamFails),
            ("testResponseSerializeBuffer", testBodyStream),
        ]
    }
}
