import XCTest
@testable import Quark

enum TestRouterError : ErrorProtocol {
    case error
}

struct EmptyRouter : Router {}

struct CustomRouter : Router {
    func custom(routes: Routes) {
        routes.get("/") { _ in
            return Response()
        }
    }
}

struct CustomRecoverRouter : Router {
    func custom(routes: Routes) {
        routes.get("/") { _ in
            throw TestRouterError.error
        }
    }

    func recover(error: ErrorProtocol) throws -> Response {
        return Response()
    }
}

class RouterTests : XCTestCase {
    func testEmptyRouter() throws {
        let router = EmptyRouter()
        let request = Request()
        let response = try router.router.respond(to: request)
        XCTAssertEqual(response.status, .notFound)
    }

    func testCustomRouter() throws {
        let router = CustomRouter()
        let request = Request()
        let response = try router.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)
    }

    func testCustomRecoverRouter() throws {
        let router = CustomRecoverRouter()
        let request = Request()
        let response = try router.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)
    }
}

extension RouterTests {
    static var allTests: [(String, (RouterTests) -> () throws -> Void)] {
        return [
            ("testEmptyRouter", testEmptyRouter),
            ("testCustomRouter", testCustomRouter),
            ("testCustomRecoverRouter", testCustomRecoverRouter),
        ]
    }
}
