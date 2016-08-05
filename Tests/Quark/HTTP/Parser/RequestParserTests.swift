import XCTest
@testable import Quark
import CHTTPParser

let requestCount = [
    1,
    2,
    5
]

let bufferSizes = [
    1,
    2,
    4,
    32,
    512,
    2048
]

let methods: [S4.Method] = [
    .delete,
    .get,
    .head,
    .post,
    .put,
    .options,
    .trace,
    .patch,
    .other(method: "COPY"),
    .other(method: "LOCK"),
    .other(method: "MKCOL"),
    .other(method: "MOVE"),
    .other(method: "PROPFIND"),
    .other(method: "PROPPATCH"),
    .other(method: "SEARCH"),
    .other(method: "UNLOCK"),
    .other(method: "BIND"),
    .other(method: "REBIND"),
    .other(method: "UNBIND"),
    .other(method: "ACL"),
    .other(method: "REPORT"),
    .other(method: "MKACTIVITY"),
    .other(method: "CHECKOUT"),
    .other(method: "MERGE"),
    .other(method: "M-SEARCH"),
    .other(method: "NOTIFY"),
    .other(method: "SUBSCRIBE"),
    .other(method: "UNSUBSCRIBE"),
    .other(method: "PURGE"),
    .other(method: "MKCALENDAR"),
    .other(method: "LINK"),
    .other(method: "UNLINK"),
]

class RequestParserTests : XCTestCase {
    func testInvalidMethod() {
        var called = false
        do {
            let data = "INVALID / HTTP/1.1\r\n\r\n"
            let stream = Drain(buffer: data)
            let parser = RequestParser(stream: stream)
            _ = try parser.parse()
            XCTFail("Invalid method should fail.")
        } catch {
            called = true
        }
        XCTAssert(called)
    }

    func testInvalidURI() {
        var called = false
        do {
            let data = "GET huehue HTTP/1.1\r\n\r\n"
            let stream = Drain(buffer: data)
            let parser = RequestParser(stream: stream)
            _ = try parser.parse()
            XCTFail("Invalid URI should fail.")
        } catch {
            called = true
        }
        XCTAssert(called)
    }

    func testNoURI() {
        var called = false
        do {
            let data = "GET HTTP/1.1\r\n\r\n"
            let stream = Drain(buffer: data)
            let parser = RequestParser(stream: stream)
            _ = try parser.parse()
            XCTFail("Invalid URI should fail.")
        } catch {
            called = true
        }
        XCTAssert(called)
    }

    func testInvalidHTTPVersion() {
        var called = false
        do {
            let data = "GET / HUEHUE\r\n\r\n"
            let stream = Drain(buffer: data)
            let parser = RequestParser(stream: stream)
            _ = try parser.parse()
            XCTFail("Invalid HTTP version should fail.")
        } catch {
            called = true
        }
        XCTAssert(called)
    }

    func testInvalidDoubleConnectMethod() {
        var called = false
        do {
            let data = "CONNECT / HTTP/1.1\r\n\r\nCONNECT / HTTP/1.1\r\n\r\n"
            let stream = Drain(buffer: data)
            let parser = RequestParser(stream: stream)
            _ = try parser.parse()
            XCTFail("Connect method should only happen once.")
        } catch {
            called = true
        }
        XCTAssert(called)
    }

    func testConnectMethod() {
        do {
            let data = "CONNECT / HTTP/1.1\r\n\r\n"
            let stream = Drain(buffer: data)
            let parser = RequestParser(stream: stream)
            let request = try parser.parse()
            XCTAssert(request.method == .connect)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.version.major == 1)
            XCTAssert(request.version.minor == 1)
            XCTAssert(request.headers.count == 0)
        } catch {
            XCTFail(String(error))
        }
    }

    func check(request: String, count: Int, bufferSize: Int, test: (Request) -> Void) {
        do {
            var data = ""

            for _ in 0 ..< count {
                data += request
            }

            let stream = Drain(buffer: data)
            let parser = RequestParser(stream: stream, bufferSize: bufferSize)

            for _ in 0 ..< count {
                try test(parser.parse())
            }
        } catch {
            XCTFail(String(error))
        }
    }

    func testShortRequests() {
        for bufferSize in bufferSizes {
            for count in requestCount {
                for method in methods {
                    let request = "\(method) / HTTP/1.1\r\n\r\n"
                    check(request: request, count: count, bufferSize: bufferSize) { request in
                        XCTAssert(request.method == method)
                        XCTAssert(request.uri.path == "/")
                        XCTAssert(request.version.major == 1)
                        XCTAssert(request.version.minor == 1)
                        XCTAssert(request.headers.count == 0)
                    }
                }
            }
        }
    }

    func testMediumRequests() {
        for bufferSize in bufferSizes {
            for count in requestCount {
                for method in methods {
                    let request = "\(method) / HTTP/1.1\r\nHost: zewo.co\r\n\r\n"
                    check(request: request, count: count, bufferSize: bufferSize) { request in
                        XCTAssert(request.method == method)
                        XCTAssert(request.uri.path == "/")
                        XCTAssert(request.version.major == 1)
                        XCTAssert(request.version.minor == 1)
                        XCTAssert(request.headers["Host"] == "zewo.co")
                    }
                }
            }
        }
    }

    func testCookiesRequest() {
        for bufferSize in bufferSizes {
            for count in requestCount {
                for method in methods {
                    let request = "\(method) / HTTP/1.1\r\nHost: zewo.co\r\nCookie: server=zewo, lang=swift\r\n\r\n"
                    check(request: request, count: count, bufferSize: bufferSize) { request in
                        XCTAssert(request.method == method)
                        XCTAssert(request.uri.path == "/")
                        XCTAssert(request.version.major == 1)
                        XCTAssert(request.version.minor == 1)
                        XCTAssert(request.headers["Host"] == "zewo.co")
                        XCTAssert(request.headers["Cookie"] == "server=zewo, lang=swift")
                    }
                }
            }
        }
    }

    func testBodyRequest() {
        for bufferSize in bufferSizes {
            for count in requestCount {
                for method in methods {
                    let request = "\(method) / HTTP/1.1\r\nContent-Length: 4\r\n\r\nZewo"
                    check(request: request, count: count, bufferSize: bufferSize) { request in
                        XCTAssert(request.method == method)
                        XCTAssert(request.uri.path == "/")
                        XCTAssert(request.version.major == 1)
                        XCTAssert(request.version.minor == 1)
                        XCTAssert(request.headers["Content-Length"] == "4")
                        XCTAssert(request.body == .buffer("Zewo"))
                    }
                }
            }
        }
    }

    func testManyRequests() {
        var request = ""

        for _ in 0 ..< 1_000 {
            request += "POST / HTTP/1.1\r\nContent-Length: 4\r\n\r\nZewo"
        }

        measure {
            self.check(request: request, count: 1, bufferSize: 4096) { request in
                XCTAssert(request.method == .post)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers["Content-Length"] == "4")
                XCTAssert(request.body == .buffer("Zewo"))
            }
        }
    }

    func testErrorDescription() {
        XCTAssertEqual(String(HPE_OK), "success")
    }

    func testUnknownMethod() {
        XCTAssertEqual(Method(code: 1969), .other(method: "UNKNOWN"))
    }

    func testDuplicateHeaders() {
        for bufferSize in bufferSizes {
            for count in requestCount {
                for method in methods {
                    let request = "\(method) / HTTP/1.1\r\nX-Custom-Header: foo\r\nX-Custom-Header: bar\r\n\r\n"
                    check(request: request, count: count, bufferSize: bufferSize) { request in
                        XCTAssert(request.method == method)
                        XCTAssert(request.uri.path == "/")
                        XCTAssert(request.version.major == 1)
                        XCTAssert(request.version.minor == 1)
                        XCTAssert(request.headers["X-Custom-Header"] == "foo, bar")
                    }
                }
            }
        }
    }
}

extension RequestParserTests {
    static var allTests: [(String, (RequestParserTests) -> () throws -> Void)] {
        return [
            ("testInvalidMethod", testInvalidMethod),
            ("testInvalidURI", testInvalidURI),
            ("testNoURI", testNoURI),
            ("testInvalidHTTPVersion", testInvalidHTTPVersion),
            ("testInvalidDoubleConnectMethod", testInvalidDoubleConnectMethod),
            ("testConnectMethod", testConnectMethod),
            ("testShortRequests", testShortRequests),
            ("testMediumRequests", testMediumRequests),
            ("testCookiesRequest", testCookiesRequest),
            ("testBodyRequest", testBodyRequest),
            ("testManyRequests", testManyRequests),
            ("testManyRequests", testErrorDescription),
            ("testManyRequests", testUnknownMethod),
            ("testManyRequests", testDuplicateHeaders),
        ]
    }
}
