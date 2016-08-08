import XCTest
import Quark

class InitializableTests : XCTestCase {
    func testInt() {
        let structuredData: StructuredData = 5
        let int = try! Int(structuredData: structuredData)
        XCTAssertEqual(int, 5)
    }

    func testString() {
        let structuredData: StructuredData = "Some"
        let string = try! String(structuredData: structuredData)
        XCTAssertEqual(string, "Some")
    }

    func testDouble() {
        let structuredData: StructuredData = 17.0
        let double = try! Double(structuredData: structuredData)
        XCTAssertEqual(double, 17.0)
    }
}

extension InitializableTests {
    static var allTests: [(String, (InitializableTests) -> () throws -> Void)] {
        return [
            ("testInt", testInt),
            ("testString", testString),
            ("testDouble", testDouble)
        ]
    }
}
