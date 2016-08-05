import XCTest
@testable import Quark

struct Foo : StructuredDataFallibleRepresentable {
    let content: StructuredData
    func asStructuredData() throws -> StructuredData {
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
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testOptionalContent() throws {
        let content: Int? = 1969
        let request = Request(content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testArrayContent() throws {
        let content = [1969]
        let request = Request(content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testDictionaryContent() throws {
        let content = ["Woodstock": 1969]
        let request = Request(content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testFallibleContent() throws {
        let content = 1969
        let foo = Foo(content: 1969)
        let request = try Request(content: foo)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testContentStringURI() throws {
        let content = 1969
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testOptionalContentStringURI() throws {
        let content: Int? = 1969
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testArrayContentStringURI() throws {
        let content = [1969]
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testDictionaryContentStringURI() throws {
        let content = ["Woodstock": 1969]
        let request = try Request(uri: "/", content: content)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
    }

    func testFallibleContentStringURI() throws {
        let content = 1969
        let foo = Foo(content: 1969)
        let request = try Request(uri: "/", content: foo)
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.uri.path, "/")
        XCTAssertEqual(request.headers, ["Content-Length": "0"])
        XCTAssertEqual(request.body, .buffer([]))
        XCTAssertEqual(request.content, StructuredData(content))
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
