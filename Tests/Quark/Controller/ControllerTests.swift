import XCTest
@testable import Quark

struct TestController : Controller {
    let repository: Repository<Int>
}

class ControllerTests : XCTestCase {
    func testController() throws {
        let repository: Repository<Int> = Repository(InMemoryRepository())
        let controller = TestController(repository: repository)
        XCTAssertEqual(try controller.list(), [])
        let (id, _) = try controller.create(model: 1969)
        XCTAssertEqual(try controller.list(), [1969])
        XCTAssertEqual(try controller.detail(id: id), 1969)
        _ = try controller.update(id: id, model: 420)
        XCTAssertEqual(try controller.list(), [420])
        XCTAssertEqual(try controller.detail(id: id), 420)
        _ = try controller.destroy(id: id)
        XCTAssertEqual(try controller.list(), [])
        XCTAssertThrowsError(try controller.detail(id: id))
        XCTAssertThrowsError(try controller.update(id: id, model: 1969))
        XCTAssertThrowsError(try controller.destroy(id: id))
    }
}

extension ControllerTests {
    static var allTests : [(String, (ControllerTests) -> () throws -> Void)] {
        return [
            ("testController", testController),
        ]
    }
}
