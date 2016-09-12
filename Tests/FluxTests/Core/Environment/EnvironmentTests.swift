import XCTest
@testable import Flux

class EnvironmentTests : XCTestCase {
    func testEnvironment() throws {
        environment["FOO"] = "bar"
        XCTAssertEqual(environment["FOO"], "bar")
        environment.set(value: "baz", to: "FOO", replace: false)
        XCTAssertEqual(environment["FOO"], "bar")
        environment["FOO"] = nil
        XCTAssertNil(environment["FOO"])
    }
}

extension EnvironmentTests {
    static var allTests : [(String, (EnvironmentTests) -> () throws -> Void)] {
        return [
            ("testEnvironment", testEnvironment),
        ]
    }
}
