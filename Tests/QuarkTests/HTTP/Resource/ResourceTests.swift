import XCTest
@testable import Quark

enum TestResourceError : Error {
    case error
}

struct EmptyResource : Resource {}

struct CustomResource : Resource {
    func custom(routes: ResourceRoutes) {
        routes.get("/foo") { _ in
            return Response()
        }
    }
}

struct CustomRecoverResource : Resource {
    func custom(routes: ResourceRoutes) {
        routes.get("/foo") { _ in
            throw TestRouterError.error
        }
    }

    func recover(error: Error) throws -> Response {
        return Response()
    }
}

struct TestResource : Resource {
    func list(request: Request) throws -> Response {
        return Response()
    }

    func create(request: Request, content: Map) throws -> Response {
        XCTAssertEqual(content, 420)
        return Response()
    }

    func detail(request: Request, id: String) throws -> Response {
        XCTAssertEqual(id, "foo")
        return Response()
    }

    func update(request: Request, id: String, content: Map) throws -> Response {
        XCTAssertEqual(id, "foo")
        XCTAssertEqual(content, 420)
        return Response()
    }

    func destroy(request: Request, id: Int) throws -> Response {
        XCTAssertEqual(id, 1969)
        return Response()
    }
}

class ResourceTests : XCTestCase {
    func testEmptyResource() throws {
        let resource = EmptyResource()
        var request = Request()
        var response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .notFound)

        request = Request(method: .post)
        request.content = 420
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .notFound)

        request = try Request(method: .get, uri: "/foo")
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .notFound)

        request = try Request(method: .patch, uri: "/foo")
        request.content = 420
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .notFound)

        request = try Request(method: .delete, uri: "/foo")
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .notFound)
    }

    func testCustomResource() throws {
        let resource = CustomResource()
        let request = try Request(method: .get, uri: "/foo")
        let response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)
    }

    func testCustomRecoverResource() throws {
        let resource = CustomRecoverResource()
        let request = try Request(method: .get, uri: "/foo")
        let response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)
    }

    func testResource() throws {
        let resource = TestResource()

        var request = Request()
        var response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)

        request = Request(method: .post)
        request.content = 420
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)

        request = try Request(method: .get, uri: "/foo")
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)

        request = try Request(method: .patch, uri: "/foo")
        request.content = 420
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)

        request = try Request(method: .delete, uri: "/1969")
        response = try resource.router.respond(to: request)
        XCTAssertEqual(response.status, .ok)
    }
}

extension ResourceTests {
    static var allTests: [(String, (ResourceTests) -> () throws -> Void)] {
        return [
            ("testEmptyResource", testEmptyResource),
            ("testCustomResource", testCustomResource),
            ("testCustomRecoverResource", testCustomRecoverResource),
            ("testResource", testResource),
        ]
    }
}
