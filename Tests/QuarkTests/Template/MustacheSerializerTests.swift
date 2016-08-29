import XCTest
@testable import Quark

class MustacheSerializerTests : XCTestCase {
    func testSerialization() throws {
        let templateFile = try File(path: "/tmp/ZewoTemplate", mode: .truncateWrite)
        try templateFile.write("{{null}}\n{{bool}}\n{{double}}\n{{int}}\n{{string}}\n{{data}}\n{{#array}}{{.}}{{/array}}\n{{#dictionary}}{{foo}}{{/dictionary}}")
        try templateFile.flush()
        let serializer = MustacheSerializer(templatePath: "/tmp/ZewoTemplate")
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
        print(try String(data: data))
        XCTAssertEqual(data.count, 28)
        XCTAssertEqual(data, Data("\n1\n4.2\n1969\nfoo\nYmFy\nfoo\nbar"))
    }

    func testInvalidEncoding() throws {
        let templateFile = try File(path: "/tmp/ZewoTemplate", mode: .truncateWrite)
        try templateFile.write(Data([0xFF]))
        try templateFile.flush()
        let serializer = MustacheSerializer(templatePath: "/tmp/ZewoTemplate")
        XCTAssertThrowsError(try serializer.serialize([]))
    }
}

extension MustacheSerializerTests {
    static var allTests : [(String, (MustacheSerializerTests) -> () throws -> Void)] {
        return [
            ("testSerialization", testSerialization),
            //("testInvalidEncoding", testInvalidEncoding),
        ]
    }
}
