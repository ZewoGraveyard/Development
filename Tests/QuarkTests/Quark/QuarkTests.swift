import XCTest
@testable import Quark

class QuarkTests : XCTestCase {
    func testConfiguration() throws {
        let file = try File(path: "/tmp/TestConfiguration", mode: .truncateWrite)
        try file.write("import QuarkConfiguration\n\nconfiguration = [\"server\": [\"log\": true]]")
        try file.flush()
        let configuration = try loadConfiguration(configurationFile: "/tmp/TestConfiguration", arguments: [])
        XCTAssertEqual(configuration["server", "log"], true)
    }

    func testQuarkErrorDescription() throws {
        XCTAssertEqual(String(describing: QuarkError.invalidArgument(description: "foo")), "foo")
    }

//    func testConfigurationProperty() throws {
//        QuarkConfiguration.configuration = ["foo": "bar"]
//        let file = try File(path: "/tmp/QuarkConfiguration")
//        let parser = JSONMapParser()
//        let data = try file.readAll()
//        let configuration = try parser.parse(data)
//        XCTAssertEqual(configuration, ["foo": "bar"])
//    }

    func testLoadCommandLineArguments() throws {
        var arguments = ["-server.log", "-server.host", "127.0.0.1", "-server.port", "8080"]
        var parsed = try Quark.load(arguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.host", "127.0.0.1", "-server.log", "-server.port", "8080"]
        parsed = try Quark.load(arguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.host", "127.0.0.1", "-server.port", "8080", "-server.log"]
        parsed = try Quark.load(arguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.log", "-server.port", "8080", "-server.host", "127.0.0.1"]
        parsed = try Quark.load(arguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.port", "8080", "-server.log", "-server.host", "127.0.0.1"]
        parsed = try Quark.load(arguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["-server.port", "8080", "-server.host", "127.0.0.1", "-server.log"]
        parsed = try Quark.load(arguments: arguments)
        XCTAssertEqual(parsed, ["server": ["log": true, "host": "127.0.0.1", "port": 8080]])

        arguments = ["foo"]
        XCTAssertThrowsError(try Quark.load(arguments: arguments))

        arguments = ["-foo", "bar", "baz"]
        XCTAssertThrowsError(try Quark.load(arguments: arguments))

        arguments = ["-foo", "-bar", "baz", "buh"]
        XCTAssertThrowsError(try Quark.load(arguments: arguments))
    }

    func testLoadEnvironmentVariables() throws {
        let variables = ["FOO_BAR": "fuu", "_": "baz"]
        let parsed = Quark.load(environmentVariables: variables)
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
            ("testQuarkErrorDescription", testQuarkErrorDescription),
//            ("testConfigurationProperty", testConfigurationProperty),
            ("testLoadCommandLineArguments", testLoadCommandLineArguments),
            ("testLoadEnvironmentVariables", testLoadEnvironmentVariables),
            ("testParseValues", testParseValues),
            ("testBuildConfigurationBuildPath", testBuildConfigurationBuildPath),
            ("testSpawnErorDescription", testSpawnErorDescription),
            ("testSystemFailure", testSystemFailure),
        ]
    }
}
