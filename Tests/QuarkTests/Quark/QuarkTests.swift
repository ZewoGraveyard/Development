import XCTest
@testable import Quark

struct TestServer : ConfigurableServer {
    let middleware: [Middleware]
    let responder: Responder

    init(middleware: [Middleware], responder: Responder, configuration: Map) throws {
        self.middleware = middleware
        self.responder = responder
        XCTAssertEqual(configuration["server", "log"], true)
    }

    func start() throws {
        let request = Request()
        let response = try middleware.chain(to: responder).respond(to: request)
        XCTAssertEqual(response.status, .ok)
        serverStartCalled = true
    }
}

struct TestResponderRepresentable : ResponderRepresentable {
    var responder: Responder {
        return BasicResponder { _ in
            return Response()
        }
    }
}

var serverStartCalled = false

class QuarkTests : XCTestCase {
    func testConfiguration() throws {
        let file = try File(path: "/tmp/TestConfiguration.swift", mode: .truncateWrite)
        try file.write("import Quark\n\nconfiguration = [\"server\": [\"log\": true]]")
        Quark.configure(configurationFile: "/tmp/TestConfiguration.swift", arguments: [], server: TestServer.self) { (configuration: Map) in
            XCTAssertEqual(configuration["server", "log"], true)
            return TestResponderRepresentable()
        }
        XCTAssertTrue(serverStartCalled)
    }

    func testConfigurationFailure() throws {
        let file = try File(path: "/tmp/TestConfiguration.swift", mode: .truncateWrite)
        try file.write("import Quark\n\nconfiguration = [\"server\": [\"log\": true]]")
        configure(configurationFile: "/tmp/TestConfiguration.swift", server: TestServer.self) { (configuration: Map) in
            XCTAssertEqual(configuration["server", "log"], true)
            throw ServerError.internalServerError
        }
    }

    func testQuarkErrorDescription() throws {
        XCTAssertEqual(String(describing: QuarkError.invalidConfiguration(description: "foo")), "foo")
        XCTAssertEqual(String(describing: QuarkError.invalidArgument(description: "foo")), "foo")
    }

    func testConfigurationProperty() throws {
        Quark.configuration = ["foo": "bar"]
        let file = try File(path: "/tmp/QuarkConfiguration")
        let parser = JSONMapParser()
        let data = try file.readAll()
        let configuration = try parser.parse(data)
        XCTAssertEqual(configuration, ["foo": "bar"])
    }

    func testLoadCommandLineArguments() throws {
        var arguments = ["-server.log", "-server.host", "127.0.0.1", "-server.port", "8080"]
        var parsed = try Quark.load(commandLineArguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.host", "127.0.0.1", "-server.log", "-server.port", "8080"]
        parsed = try Quark.load(commandLineArguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.host", "127.0.0.1", "-server.port", "8080", "-server.log"]
        parsed = try Quark.load(commandLineArguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.log", "-server.port", "8080", "-server.host", "127.0.0.1"]
        parsed = try Quark.load(commandLineArguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.port", "8080", "-server.log", "-server.host", "127.0.0.1"]
        parsed = try Quark.load(commandLineArguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.port", "8080", "-server.host", "127.0.0.1", "-server.log"]
        parsed = try Quark.load(commandLineArguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["foo"]
        XCTAssertThrowsError(try Quark.load(commandLineArguments: arguments))

        arguments = ["-foo", "bar", "baz"]
        XCTAssertThrowsError(try Quark.load(commandLineArguments: arguments))

        arguments = ["-foo", "-bar", "baz", "buh"]
        XCTAssertThrowsError(try Quark.load(commandLineArguments: arguments))
    }

    func testLoadEnvironmentVariables() throws {
        let variables = ["FOO_BAR": "fuu", "_": "baz"]
        let parsed = try Quark.load(environmentVariables: variables)
        XCTAssertEqual(parsed, ["fooBar": "fuu", "_": "baz"])
    }

    func testParseValues() throws {
        XCTAssertEqual(parse(value: ""), "")
        XCTAssertEqual(parse(value: "NULL"), nil)
        XCTAssertEqual(parse(value: "Null"), nil)
        XCTAssertEqual(parse(value: "null"), nil)
        XCTAssertEqual(parse(value: "NIL"), nil)
        XCTAssertEqual(parse(value: "Nil"), nil)
        XCTAssertEqual(parse(value: "nil"), nil)
        XCTAssertEqual(parse(value: "1964"), 1964)
        XCTAssertEqual(parse(value: "4.20"), 4.2)
        XCTAssertEqual(parse(value: "TRUE"), true)
        XCTAssertEqual(parse(value: "True"), true)
        XCTAssertEqual(parse(value: "true"), true)
        XCTAssertEqual(parse(value: "FALSE"), false)
        XCTAssertEqual(parse(value: "False"), false)
        XCTAssertEqual(parse(value: "false"), false)
        XCTAssertEqual(parse(value: "foo"), "foo")
    }

    func testBuildConfigurationBuildPath() throws {
        XCTAssertEqual(BuildConfiguration.debug.buildPath, "debug")
        XCTAssertEqual(BuildConfiguration.release.buildPath, "release")
        XCTAssertEqual(BuildConfiguration.fast.buildPath, "release")
    }

    func testSpawnErorDescription() throws {
        XCTAssertEqual(String(describing: SpawnError.exitStatus(0, [])), "exit(0): []")
    }

    func testSystemFailure() throws {
        XCTAssertThrowsError(try sys([]))
        XCTAssertThrowsError(try sys(["foo"]))
        XCTAssertThrowsError(try sys(["cd", "foo"]))
    }
}

extension QuarkTests {
    static var allTests : [(String, (QuarkTests) -> () throws -> Void)] {
        return [
            ("testConfiguration", testConfiguration),
            ("testConfigurationFailure", testConfigurationFailure),
            ("testQuarkErrorDescription", testQuarkErrorDescription),
            ("testConfigurationProperty", testConfigurationProperty),
            ("testLoadCommandLineArguments", testLoadCommandLineArguments),
            ("testLoadEnvironmentVariables", testLoadEnvironmentVariables),
            ("testParseValues", testParseValues),
            ("testBuildConfigurationBuildPath", testBuildConfigurationBuildPath),
            ("testSpawnErorDescription", testSpawnErorDescription),
            ("testSystemFailure", testSystemFailure),
        ]
    }
}
