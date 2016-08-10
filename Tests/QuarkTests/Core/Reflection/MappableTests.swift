import XCTest
import Quark

struct Human : Mappable {
    var firstName: String
    var lastName: String
    var age: Int
    var phoneNumber: PhoneNumber
}

struct PhoneNumber : Mappable {
    var number: String
    var type: String
}

struct ServerConfiguration : Configuration {
    let host: String
    let port: Int
}

struct AppConfiguration : Configuration {
    let server: ServerConfiguration
}

class MappableTests : XCTestCase {
    func testMappable() throws {
        let map: Map = [
            "firstName": "Jane",
            "lastName": "Miller",
            "age": 54,
            "phoneNumber": [
                "number": "924-555-0294",
                "type": "work"
            ]
        ]

        let person = try Human(map: map)
        XCTAssertEqual(person.firstName, "Jane")
        XCTAssertEqual(person.lastName, "Miller")
        XCTAssertEqual(person.age, 54)
        XCTAssertEqual(person.phoneNumber.number, "924-555-0294")
        XCTAssertEqual(person.phoneNumber.type, "work")
    }

    func testMappableMissingValues() throws {
        var map: Map

        map = [
            "firstName": "Jane",
            "age": 54,
            "phoneNumber": [
                "number": "924-555-0294",
                "type": "work"
            ]
        ]

        XCTAssertThrowsError(try Human(map: map))

        map = [
            "firstName": "Jane",
            "lastName": "Miller",
            "age": 54,
            "phoneNumber": [
                "type": "work"
            ]
        ]

        XCTAssertThrowsError(try Human(map: map))
    }

    func testMappableExtraValues() throws {
        let map: Map = [
            "firstName": "Jane",
            "lastName": "Miller",
            "age": 54,
            "city": "San Francisco",
            "phoneNumber": [
                "number": "924-555-0294",
                "type": "work",
                 "color": "pink",
            ]
        ]

        let person = try Human(map: map)
        XCTAssertEqual(person.firstName, "Jane")
        XCTAssertEqual(person.lastName, "Miller")
        XCTAssertEqual(person.age, 54)
        XCTAssertEqual(person.phoneNumber.number, "924-555-0294")
        XCTAssertEqual(person.phoneNumber.type, "work")
    }

    func testGenericMappable() throws {
        func getValues() -> Map {
            return [
                "CfUserTextEncoding": "0x1F5:0x0:0x0",
                "XcodeBuiltProductsDirPaths": "/Users/dude/Library/Developer/Xcode/DerivedData/Quark-hkcyzsovmmswmkddaxwoabfvvagf/Build/Products/Debug",
                "XpcDyldFrameworkPath": "/Users/dude/Library/Developer/Xcode/DerivedData/Quark-hkcyzsovmmswmkddaxwoabfvvagf/Build/Products/Debug",
                "XpcDyldLibraryPath": "/Users/dude/Library/Developer/Xcode/DerivedData/Quark-hkcyzsovmmswmkddaxwoabfvvagf/Build/Products/Debug",
                "applePubsubSocketRender": "/private/tmp/com.apple.launchd.6RKihybP7b/Render",
                "dyldFrameworkPath": "/Users/dude/Library/Developer/Xcode/DerivedData/Quark-hkcyzsovmmswmkddaxwoabfvvagf/Build/Products/Debug",
                "dyldLibraryPath": "/Users/dude/Library/Developer/Xcode/DerivedData/Quark-hkcyzsovmmswmkddaxwoabfvvagf/Build/Products/Debug:/usr/lib/system/introspection",
                "home": "/Users/dude",
                "logname": "dude",
                "nsunbufferedio": true,
                "osActivityDtMode": true,
                "path": "/Applications/Xcode-beta.app/Contents/Developer/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin",
                "pwd": "/Users/dude/Library/Developer/Xcode/DerivedData/Quark-hkcyzsovmmswmkddaxwoabfvvagf/Build/Products/Debug",
                "server": [
                    "host": "127.0.0.1",
                    "port": 8087
                ],
                "shell": "/bin/zsh",
                "sshAuthSock": "/private/tmp/com.apple.launchd.dVdg78a0Dg/Listeners",
                "tmpdir": "/var/folders/_9/5x73ldqs4zd6h322pc0rzgxc0000gn/T/",
                "user": "dude",
                "workingDirectory": "/Users/dude/Development/Quark/Quark",
                "xpcFlags": 0.0,
                "xpcServiceName": "com.apple.dt.Xcode.362592",
            ]
        }

        func construct<T : Configuration>(construct: (T) -> Void) throws {
            let map = getValues()
            try construct(T(map: map))
        }

        try construct { (configuration: AppConfiguration) in
            XCTAssertEqual(configuration.server.host, "127.0.0.1")
            XCTAssertEqual(configuration.server.port, 8087)
        }
    }
}

extension MappableTests {
    static var allTests: [(String, (MappableTests) -> () throws -> Void)] {
        return [
            ("testMappable", testMappable),
            ("testGenericMappable", testGenericMappable),
        ]
    }
}
