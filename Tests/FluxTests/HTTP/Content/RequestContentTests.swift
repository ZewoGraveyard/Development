import XCTest
@testable import Quark

struct Foo : MapFallibleRepresentable {
    let content: Map
    func asMap() throws -> Map {
        return content
    }
}

class RequestContentTests : XCTestCase {
    func testContent() throws {
        let content = 1969
        let request = Request(content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testOptionalContent() throws {
        let content: Int? = 1969
        let request = Request(content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testArrayContent() throws {
        let content = [1969]
        let request = Request(content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testDictionaryContent() throws {
        let content = ["Woodstock": 1969]
        let request = Request(content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testFallibleContent() throws {
        let content = 1969
        let foo = Foo(content: 1969)
        let request = try Request(content: foo)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testContentStringURI() throws {
        let content = 1969
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testOptionalContentStringURI() throws {
        let content: Int? = 1969
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testArrayContentStringURI() throws {
        let content = [1969]
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testDictionaryContentStringURI() throws {
        let content = ["Woodstock": 1969]
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }

    func testFallibleContentStringURI() throws {
        let content = 1969
        let foo = Foo(content: 1969)
        let request = try Request(uri: "/", content: foo)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer(Data()))
        XCTAssertEqual(request.content, Map(content))
    }
}

extension RequestContentTests {
    static var allTests : [(String, (RequestContentTests) -> () throws -> Void)] {
        return [
            ("testContent", testContent),
            ("testOptionalContent", testOptionalContent),
            ("testArrayContent", testArrayContent),
            ("testDictionaryContent", testDictionaryContent),
            ("testFallibleContent", testFallibleContent),
            ("testContentStringURI", testContentStringURI),
            ("testOptionalContentStringURI", testOptionalContentStringURI),
            ("testArrayContentStringURI", testArrayContentStringURI),
            ("testDictionaryContentStringURI", testDictionaryContentStringURI),
            ("testFallibleContentStringURI", testFallibleContentStringURI),
        ]
    }
}
