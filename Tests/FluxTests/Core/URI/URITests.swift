import XCTest
@testable import Flux

class URITests : XCTestCase {
    func testParseFailure() {
        XCTAssertThrowsError(try URI(""))
        XCTAssertThrowsError(try URI("http"))
        XCTAssertThrowsError(try URI("http:/"))
        XCTAssertThrowsError(try URI("http://"))
        XCTAssertThrowsError(try URI("http://username@zewo.io"))
    }

    func testSmallURI() throws {
        let uri = try URI("http://zewo.io")
        XCTAssertEqual(uri.scheme, "http")
        XCTAssertEqual(uri.host, "zewo.io")
    }

    func testComplexURI() throws {
        let uriString = "http://user%20name:pass%20word@www.example.com:80/dir/sub%20dir?par%20am=1&par%20am=2%203&par%20am=&par%20am&pan%20am#frag%20ment"
        let decodedURIString = "http://user name:pass word@www.example.com:80/dir/sub dir?par am=1&par am=2 3&par am=&par am&pan am#frag ment"
        let uri = try URI(uriString)

        XCTAssertEqual(uri.scheme, "http")
        XCTAssertEqual(uri.userInfo?.username, "user name")
        XCTAssertEqual(uri.userInfo?.password, "pass word")
        XCTAssertEqual(uri.host, "www.example.com")
        XCTAssertEqual(uri.port, 80)
        XCTAssertEqual(uri.path, "/dir/sub dir")
        XCTAssertEqual(uri.query, "par%20am=1&par%20am=2%203&par%20am=&par%20am&pan%20am")
        XCTAssertEqual(uri.singleValuedQuery, ["par am": "", "pan am": ""])
      

        XCTAssertEqual(uri.fragment, "frag ment")
        XCTAssertEqual(uri.percentEncoded(), uriString)
        XCTAssertEqual(String(describing: uri), decodedURIString)
    }

    func testEquality() throws {
        let uri = try URI("http://zewo.io")
        XCTAssert(uri == uri)
        let userInfo = URI.UserInfo(username: "username", password: "password")
        XCTAssert(userInfo == userInfo)
    }

    func testQuery() {
        var uri = URI(path: "/")
        XCTAssertEqual(uri.singleValuedQuery, [:])
        XCTAssert(uri.singleOptionalValuedQuery == [:])
        XCTAssert(uri.multipleValuedQuery == [:])
        XCTAssert(uri.multipleOptionalValuedQuery == [:])

        uri.query = "foo%20bar=fuu%20baz&foo%20bar=fou%20boy&foo%20bar=&foo%20bar&he%20llo=wo%20rld"
        XCTAssertEqual(uri.singleValuedQuery, ["foo bar": "", "he llo": "wo rld"])
        XCTAssert(uri.singleOptionalValuedQuery == ["foo bar": nil, "he llo": "wo rld"])
        XCTAssert(uri.multipleValuedQuery == ["foo bar": ["fuu baz", "fou boy", "", ""], "he llo": ["wo rld"]])
        XCTAssert(uri.multipleOptionalValuedQuery == ["foo bar": ["fuu baz", "fou boy", "", nil], "he llo": ["wo rld"]])

        uri.singleValuedQuery = ["f oo": "b ar", "f uu": "b az"]
        XCTAssert(
            uri.query == "f%20oo=b%20ar&f%20uu=b%20az" ||
            uri.query == "f%20uu=b%20az&f%20oo=b%20ar"
        )
        uri.singleOptionalValuedQuery = ["f oo": "b ar", "f uu": nil]
        XCTAssert(
            uri.query == "f%20oo=b%20ar&f%20uu" ||
            uri.query == "f%20uu&f%20oo=b%20ar"
        )
        uri.multipleValuedQuery = ["f oo": ["b ar", "ba r"], "f uu": ["b az"]]
        XCTAssert(
            uri.query == "f%20oo=b%20ar&f%20oo=ba%20r&f%20uu=b%20az" ||
            uri.query == "f%20uu=b%20az&f%20oo=b%20ar&f%20oo=ba%20r"
        )
        uri.multipleOptionalValuedQuery = ["f oo": ["b ar", nil], "f uu": ["b az"]]
        XCTAssert(
            uri.query == "f%20oo=b%20ar&f%20oo&f%20uu=b%20az" ||
            uri.query == "f%20uu=b%20az&f%20oo=b%20ar&f%20oo"
        )

        uri.query = "foo%20bar&foo%20bar&fuu%20baz&fuu%20baz"
        XCTAssert(uri.multipleValuedQuery == ["foo bar": ["", ""], "fuu baz": ["", ""]])
        XCTAssert(uri.multipleOptionalValuedQuery == ["foo bar": [nil, nil], "fuu baz": [nil, nil]])
    }
}

func == (lhs: [String?], rhs: [String?]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    for i in 0 ..< lhs.count {
        if lhs[i] != rhs[i] {
            return false
        }
    }
    return true
}

func == (lhs: [String: String?], rhs: [String: String?]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    for (key, lhsValue) in lhs {
        guard let rhsValue = rhs[key] else {
            return false
        }
        if lhsValue != rhsValue {
            return false
        }
    }
    return true
}

func == (lhs: [String: [String]], rhs: [String: [String]]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    for (key, lhsValue) in lhs {
        guard let rhsValue = rhs[key] else {
            return false
        }
        if lhsValue != rhsValue {
            return false
        }
    }
    return true
}

func == (lhs: [String: [String?]], rhs: [String: [String?]]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    for (key, lhsValue) in lhs {
        guard let rhsValue = rhs[key] else {
            return false
        }
        if !(lhsValue == rhsValue) {
            return false
        }
    }
    return true
}

extension URITests {
    static var allTests: [(String, (URITests) -> () throws -> Void)] {
        return [
            ("testParseFailure", testParseFailure),
            ("testSmallURI", testSmallURI),
            ("testComplexURI", testComplexURI),
            ("testEquality", testEquality),
            ("testQuery", testQuery),
        ]
    }
}
