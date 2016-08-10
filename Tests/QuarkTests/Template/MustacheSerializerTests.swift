import XCTest
@testable import Quark

class MustacheSerializerTests : XCTestCase {
    func testSerialization() throws {
        let templateFile = try File(path: "/tmp/ZewoTemplate", mode: .truncateWrite)
        try templateFile.write("{{null}}\n{{bool}}\n{{double}}\n{{int}}\n{{string}}\n{{data}}\n{{#array}}{{.}}{{/array}}\n{{#dictionary}}{{foo}}{{/dictionary}}")
        let serializer = MustacheSerializer(templatePath: "/tmp/ZewoTemplate", fileType: File.self)
        let templateData: Map = [
            "null": nil,
            "bool": true,
            "double": 4.2,
            "int": 1969,
            "string": "foo",
            "data": .data(Data("bar")),
            "array": ["foo"],
            "dictionary": ["foo": "bar"]
        ]
        let data = try serializer.serialize(templateData)
        XCTAssertEqual(String(describing: data), "\n1\n4.2\n1969\nfoo\nbar\nfoo\nbar")
    }

    func testInvalidEncoding() throws {
        let templateFile = try File(path: "/tmp/ZewoTemplate", mode: .truncateWrite)
        try templateFile.write([0xFF])
        let serializer = MustacheSerializer(templatePath: "/tmp/ZewoTemplate", fileType: File.self)
        XCTAssertThrowsError(try serializer.serialize([]))
    }
}

extension MustacheSerializerTests {
    static var allTests : [(String, (MustacheSerializerTests) -> () throws -> Void)] {
        return [
            ("testSerialization", testSerialization),
            ("testInvalidEncoding", testInvalidEncoding),
        ]
    }
}
