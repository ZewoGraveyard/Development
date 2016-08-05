import XCTest
import Quark

struct Person : Equatable {
    var firstName: String
    var lastName: String
    var age: Int

    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}

func == (lhs: Person, rhs: Person) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class ReferencePerson : Initializable, Equatable {
    var firstName: String
    var lastName: String
    var age: Int

    required init() {
        self.firstName = ""
        self.lastName = ""
        self.age = 0
    }

    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}

class SubclassedPerson : ReferencePerson {}

func == (lhs: ReferencePerson, rhs: ReferencePerson) -> Bool {
    return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
}

class PublicTests : XCTestCase {
    func testConstructType() {
        for _ in 0..<1000 {
            do {
                let person: Person = try construct {
                    (["firstName": "Brad", "lastName": "Hilton", "age": 27] as [String : Any])[$0.key]!
                }
                let other = Person(firstName: "Brad", lastName: "Hilton", age: 27)
                XCTAssert(person == other)
            } catch {
                XCTFail(String(error))
            }
        }
    }

    func testConstructReferenceType() {
        for _ in 0..<1000 {
            do {
                let person: ReferencePerson = try construct {
                    (["firstName": "Brad", "lastName": "Hilton", "age": 27] as [String : Any])[$0.key]!
                }
                let other = ReferencePerson(firstName: "Brad", lastName: "Hilton", age: 27)
                XCTAssert(person == other)
            } catch {
                XCTFail(String(error))
            }
        }
    }

    func testConstructFlags() {
        struct Flags {
            let x: Bool
            let y: Bool?
            let z: (Bool, Bool)
        }
        do {
            let flags: Flags = try construct(dictionary: [
                "x": false,
                "y": nil as Optional<Bool>,
                "z": (true, false)
            ] as [String : Any])
            XCTAssert(!flags.x)
            XCTAssert(flags.y == nil)
            XCTAssert(flags.z == (true, false))
        } catch {
            XCTFail(String(error))
        }
    }

    func testConstructObject() {
        struct Object {
            let flag: Bool
            let pair: (UInt8, UInt8)
            let float: Float?
            let integer: Int
            let string: String
        }
        do {
            let object: Object = try construct(dictionary: [
               "flag": true,
               "pair": (UInt8(1), UInt8(2)),
               "float": Optional(Float(89.0)),
               "integer": 123,
               "string": "Hello, world"
            ] as [String : Any])
            XCTAssert(object.flag)
            XCTAssert(object.pair == (1, 2))
            XCTAssert(object.float == 89.0)
            XCTAssert(object.integer == 123)
            XCTAssert(object.string == "Hello, world")
        } catch {
            XCTFail(String(error))
        }
    }

    func testPropertiesForInstance() {
        var props = [Property]()
        do {
            let person = Person(firstName: "Brad", lastName: "Hilton", age: 27)
            props = try properties(person)
            guard props.count == 3 else {
                XCTFail("Unexpected number of properties"); return
            }
            guard let firstName = props[0].value as? String, let lastName = props[1].value as? String, let age = props[2].value as? Int else {
                XCTFail("Unexpected properties"); return
            }
            XCTAssert(person.firstName == firstName)
            XCTAssert(person.lastName == lastName)
            XCTAssert(person.age == age)
        } catch {
            XCTFail(String(error))
        }
    }

    func testSetValueForKeyOfInstance() {
        do {
            var person = Person(firstName: "Brad", lastName: "Hilton", age: 27)
            try set("Lawrence", key: "firstName", for: &person)
            XCTAssert(person.firstName == "Lawrence")
        } catch {
            XCTFail(String(error))
        }
    }

    func testValueForKeyOfInstance() {
        do {
            let person = Person(firstName: "Brad", lastName: "Hilton", age: 29)
            let firstName: String = try get("firstName", from: person)
            XCTAssert(person.firstName == firstName)
        } catch {
            XCTFail(String(error))
        }
    }

    func testValueIs() {
        XCTAssert(Quark.value("John", is: String.self))
        XCTAssert(Quark.value(89, is: Int.self))
        XCTAssert(Quark.value(["Larry"], is: Array<String>.self))
        XCTAssert(!Quark.value("John", is: Array<String>.self))
        XCTAssert(!Quark.value(89, is: String.self))
        XCTAssert(!Quark.value(["Larry"], is: Int.self))

        let person = Person(firstName: "Hillary", lastName: "Mason", age: 32)
        let referencePerson = ReferencePerson()
        let subclassedPerson = SubclassedPerson()
        XCTAssert(Quark.value(person, is: Person.self))
        XCTAssert(Quark.value(referencePerson, is: ReferencePerson.self))
        XCTAssert(!Quark.value(person, is: ReferencePerson.self))
        XCTAssert(!Quark.value(referencePerson, is: Person.self))
        XCTAssert(Quark.value(subclassedPerson, is: SubclassedPerson.self))
        XCTAssert(Quark.value(subclassedPerson, is: ReferencePerson.self))
        XCTAssert(!Quark.value(referencePerson, is: SubclassedPerson.self))
    }

    func testMemoryProperties() {
        func testMemoryProperties<T>(_ type: T.Type) {
            XCTAssert(alignof(T.self as Any.Type) == Swift.alignof(T.self))
            XCTAssert(sizeof(T.self as Any.Type) == Swift.sizeof(T.self))
            XCTAssert(strideof(T.self as Any.Type) == Swift.strideof(T.self))
        }
        testMemoryProperties(Bool.self)
        testMemoryProperties(UInt8.self)
        testMemoryProperties(UInt16.self)
        testMemoryProperties(UInt32.self)
        testMemoryProperties(Float.self)
        testMemoryProperties(Double.self)
        testMemoryProperties(String.self)
        testMemoryProperties(Array<Int>.self)
    }
}

extension PublicTests {
    static var allTests: [(String, (PublicTests) -> () throws -> Void)] {
        return [
            ("testConstructType", testConstructType),
            ("testConstructReferenceType", testConstructReferenceType),
            ("testConstructFlags", testConstructFlags),
            ("testConstructObject", testConstructObject),
            ("testPropertiesForInstance", testPropertiesForInstance),
            ("testSetValueForKeyOfInstance", testSetValueForKeyOfInstance),
            ("testValueForKeyOfInstance", testValueForKeyOfInstance),
            ("testValueIs", testValueIs),
            ("testMemoryProperties", testMemoryProperties),
        ]
    }
}
