import XCTest
@testable import Quark

struct Fuu : StructuredDataFallibleRepresentable {
    let content: StructuredData
    func asStructuredData() throws -> StructuredData {
        return content
    }
}

class ResponseContentTests : XCTestCase {
    func testContent() throws {
        let content = 1969
        let response = Response(content: content)
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.headers, ["Content-Length": "0"])
        XCTAssertEqual(response.body, .buffer([]))
        XCTAssertEqual(response.content, StructuredData(content))
    }

    func testOptionalContent() throws {
        let content: Int? = 1969
        let response = Response(content: content)
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.headers, ["Content-Length": "0"])
        XCTAssertEqual(response.body, .buffer([]))
        XCTAssertEqual(response.content, StructuredData(content))
    }

    func testArrayContent() throws {
        let content = [1969]
        let response = Response(content: content)
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.headers, ["Content-Length": "0"])
        XCTAssertEqual(response.body, .buffer([]))
        XCTAssertEqual(response.content, StructuredData(content))
    }

    func testDictionaryContent() throws {
        let content = ["Woodstock": 1969]
        let response = Response(content: content)
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.headers, ["Content-Length": "0"])
        XCTAssertEqual(response.body, .buffer([]))
        XCTAssertEqual(response.content, StructuredData(content))
    }

    func testFallibleContent() throws {
        let content = 1969
        let fuu = Fuu(content: 1969)
        let response = try Response(content: fuu)
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.headers, ["Content-Length": "0"])
        XCTAssertEqual(response.body, .buffer([]))
        XCTAssertEqual(response.content, StructuredData(content))
    }
}

extension ResponseContentTests {
    static var allTests : [(String, (ResponseContentTests) -> () throws -> Void)] {
        return [
            ("testContent", testContent),
            ("testOptionalContent", testOptionalContent),
            ("testArrayContent", testArrayContent),
            ("testDictionaryContent", testDictionaryContent),
            ("testFallibleContent", testFallibleContent),
        ]
    }
}
