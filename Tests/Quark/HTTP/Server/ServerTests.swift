import XCTest
@testable import Quark

class TestHost : C7.Host {
    let data: C7.Data

    init(data: C7.Data) {
        self.data = data
    }

    func accept(deadline: Double) throws -> C7.Stream {
        return Drain(buffer: data)
    }
}

enum CustomError :  ErrorProtocol {
    case error
}

class ServerTests : XCTestCase {
    func testServer() throws {
        var called = false

        let responder = BasicResponder { request in
            called = true
            XCTAssertEqual(request.method, .get)
            return Response()
        }

        let server = try Server(
            host: TestHost(data: "GET / HTTP/1.1\r\n\r\n"),
            port: 8080,
            parser: RequestParser.self,
            serializer: ResponseSerializer.self,
            middleware: [],
            responder: responder,
            failure: { _ in
                XCTFail()
            }
        )
        let stream = try server.host.accept()
        server.printHeader()
        try server.process(stream: stream)
        XCTAssert(String((stream as! Drain).data).contains(substring: "OK"))
        XCTAssert(called)
    }

    func testServerRecover() throws {
        var called = false
        var stream: C7.Stream = Drain()

        let responder = BasicResponder { request in
            called = true
            (stream as! Drain).closed = false
            XCTAssertEqual(request.method, .get)
            throw ClientError.badRequest
        }

        let server = try Server(
            host: TestHost(data: "GET / HTTP/1.1\r\n\r\n"),
            port: 8080,
            parser: RequestParser.self,
            serializer: ResponseSerializer.self,
            middleware: [],
            responder: responder,
            failure: { _ in
                XCTFail()
            }
        )
        stream = try server.host.accept()
        try server.process(stream: stream)
        XCTAssert(String((stream as! Drain).data).contains(substring: "Bad Request"))
        XCTAssert(called)
    }

    func testServerNoRecover() throws {
        var called = false
        var stream: C7.Stream = Drain()

        let responder = BasicResponder { request in
            called = true
            (stream as! Drain).closed = false
            XCTAssertEqual(request.method, .get)
            throw CustomError.error
        }

        let server = try Server(
            host: TestHost(data: "GET / HTTP/1.1\r\n\r\n"),
            port: 8080,
            parser: RequestParser.self,
            serializer: ResponseSerializer.self,
            middleware: [],
            responder: responder,
            failure: { _ in
                XCTFail()
            }
        )
        stream = try server.host.accept()
        XCTAssertThrowsError(try server.process(stream: stream))
        XCTAssert(String((stream as! Drain).data).contains(substring: "Internal Server Error"))
        XCTAssert(called)
    }

    func testBrokenPipe() throws {
        var called = false
        var stream: C7.Stream = Drain()

        let responder = BasicResponder { request in
            called = true
            (stream as! Drain).closed = false
            XCTAssertEqual(request.method, .get)
            throw SystemError.brokenPipe
        }

        let request: C7.Data = "GET / HTTP/1.1\r\n\r\n"

        let server = try Server(
            host: TestHost(data: request),
            port: 8080,
            parser: RequestParser.self,
            serializer: ResponseSerializer.self,
            middleware: [],
            responder: responder,
            failure: { _ in
                XCTFail()
            }
        )
        stream = try server.host.accept()
        try server.process(stream: stream)
        XCTAssertEqual((stream as! Drain).data, request)
        XCTAssert(called)
    }

    func testNotKeepAlive() throws {
        var called = false
        var stream: C7.Stream = Drain()

        let responder = BasicResponder { request in
            called = true
            (stream as! Drain).closed = false
            XCTAssertEqual(request.method, .get)
            return Response()
        }

        let request: C7.Data = "GET / HTTP/1.1\r\nConnection: close\r\n\r\n"

        let server = try Server(
            host: TestHost(data: request),
            port: 8080,
            parser: RequestParser.self,
            serializer: ResponseSerializer.self,
            middleware: [],
            responder: responder,
            failure: { _ in
                XCTFail()
            }
        )
        stream = try server.host.accept()
        try server.process(stream: stream)
        XCTAssert(String((stream as! Drain).data).contains(substring: "OK"))
        XCTAssertTrue(stream.closed)
        XCTAssert(called)
    }

    func testUpgradeConnection() throws {
        var called = false
        var upgradeCalled = false
        var stream: C7.Stream = Drain()

        let responder = BasicResponder { request in
            called = true
            (stream as! Drain).closed = false
            XCTAssertEqual(request.method, .get)
            var response = Response()
            response.upgradeConnection { request, stream in
                XCTAssertEqual(request.method, .get)
                XCTAssert(String((stream as! Drain).data).contains(substring: "OK"))
                XCTAssertFalse(stream.closed)
                upgradeCalled = true
            }
            return response
        }

        let request: C7.Data = "GET / HTTP/1.1\r\nConnection: close\r\n\r\n"

        let server = try Server(
            host: TestHost(data: request),
            port: 8080,
            parser: RequestParser.self,
            serializer: ResponseSerializer.self,
            middleware: [],
            responder: responder,
            failure: { _ in
                XCTFail()
            }
        )
        stream = try server.host.accept()
        try server.process(stream: stream)
        XCTAssert(String((stream as! Drain).data).contains(substring: "OK"))
        XCTAssertTrue(stream.closed)
        XCTAssert(called)
        XCTAssert(upgradeCalled)
    }

    func testLogError() {
        Server.logError(error: ClientError.badRequest)
    }
}

extension ServerTests {
    static var allTests : [(String, (ServerTests) -> () throws -> Void)] {
        return [
            ("testServer", testServer),
            ("testServerRecover", testServerRecover),
            ("testServerNoRecover", testServerNoRecover),
            ("testBrokenPipe", testBrokenPipe),
            ("testNotKeepAlive", testNotKeepAlive),
            ("testUpgradeConnection", testUpgradeConnection),
            ("testLogError", testLogError),
        ]
    }
}
