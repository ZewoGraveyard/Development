import XCTest
@testable import Core

public class MapTests : XCTestCase {
    func testCreation() {
        let nullValue: Bool? = nil
        let null = Map(nullValue)
        XCTAssertEqual(null, nil)
        XCTAssertEqual(null, .null)
        XCTAssert(null.isNull)
        XCTAssertFalse(null.isBool)
        XCTAssertFalse(null.isDouble)
        XCTAssertFalse(null.isInt)
        XCTAssertFalse(null.isString)
        XCTAssertFalse(null.isData)
        XCTAssertFalse(null.isArray)
        XCTAssertFalse(null.isDictionary)
        XCTAssertNil(null.bool)
        XCTAssertNil(null.double)
        XCTAssertNil(null.int)
        XCTAssertNil(null.string)
        XCTAssertNil(null.data)
        XCTAssertNil(null.array)
        XCTAssertNil(null.dictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullArrayValue: [Bool]? = nil
        let nullArray = Map(nullArrayValue)
        XCTAssertEqual(nullArray, nil)
        XCTAssertEqual(nullArray, .null)
        XCTAssert(nullArray.isNull)
        XCTAssertFalse(nullArray.isBool)
        XCTAssertFalse(nullArray.isDouble)
        XCTAssertFalse(nullArray.isInt)
        XCTAssertFalse(nullArray.isString)
        XCTAssertFalse(nullArray.isData)
        XCTAssertFalse(nullArray.isArray)
        XCTAssertFalse(nullArray.isDictionary)
        XCTAssertNil(nullArray.bool)
        XCTAssertNil(nullArray.double)
        XCTAssertNil(nullArray.int)
        XCTAssertNil(nullArray.string)
        XCTAssertNil(nullArray.data)
        XCTAssertNil(nullArray.array)
        XCTAssertNil(nullArray.dictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullArrayOfNullValue: [Bool?]? = nil
        let nullArrayOfNull = Map(nullArrayOfNullValue)
        XCTAssertEqual(nullArrayOfNull, nil)
        XCTAssertEqual(nullArrayOfNull, .null)
        XCTAssert(nullArrayOfNull.isNull)
        XCTAssertFalse(nullArrayOfNull.isBool)
        XCTAssertFalse(nullArrayOfNull.isDouble)
        XCTAssertFalse(nullArrayOfNull.isInt)
        XCTAssertFalse(nullArrayOfNull.isString)
        XCTAssertFalse(nullArrayOfNull.isData)
        XCTAssertFalse(nullArrayOfNull.isArray)
        XCTAssertFalse(nullArrayOfNull.isDictionary)
        XCTAssertNil(nullArrayOfNull.bool)
        XCTAssertNil(nullArrayOfNull.double)
        XCTAssertNil(nullArrayOfNull.int)
        XCTAssertNil(nullArrayOfNull.string)
        XCTAssertNil(nullArrayOfNull.data)
        XCTAssertNil(nullArrayOfNull.array)
        XCTAssertNil(nullArrayOfNull.dictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullDictionaryValue: [String: Bool]? = nil
        let nullDictionary = Map(nullDictionaryValue)
        XCTAssertEqual(nullDictionary, nil)
        XCTAssertEqual(nullDictionary, .null)
        XCTAssert(nullDictionary.isNull)
        XCTAssertFalse(nullDictionary.isBool)
        XCTAssertFalse(nullDictionary.isDouble)
        XCTAssertFalse(nullDictionary.isInt)
        XCTAssertFalse(nullDictionary.isString)
        XCTAssertFalse(nullDictionary.isData)
        XCTAssertFalse(nullDictionary.isArray)
        XCTAssertFalse(nullDictionary.isDictionary)
        XCTAssertNil(nullDictionary.bool)
        XCTAssertNil(nullDictionary.double)
        XCTAssertNil(nullDictionary.int)
        XCTAssertNil(nullDictionary.string)
        XCTAssertNil(nullDictionary.data)
        XCTAssertNil(nullDictionary.array)
        XCTAssertNil(nullDictionary.dictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullDictionaryOfNullValue: [String: Bool?]? = nil
        let nullDictionaryOfNull = Map(nullDictionaryOfNullValue)
        XCTAssertEqual(nullDictionaryOfNull, nil)
        XCTAssertEqual(nullDictionaryOfNull, .null)
        XCTAssert(nullDictionaryOfNull.isNull)
        XCTAssertFalse(nullDictionaryOfNull.isBool)
        XCTAssertFalse(nullDictionaryOfNull.isDouble)
        XCTAssertFalse(nullDictionaryOfNull.isInt)
        XCTAssertFalse(nullDictionaryOfNull.isString)
        XCTAssertFalse(nullDictionaryOfNull.isData)
        XCTAssertFalse(nullDictionaryOfNull.isArray)
        XCTAssertFalse(nullDictionaryOfNull.isDictionary)
        XCTAssertNil(nullDictionaryOfNull.bool)
        XCTAssertNil(nullDictionaryOfNull.double)
        XCTAssertNil(nullDictionaryOfNull.int)
        XCTAssertNil(nullDictionaryOfNull.string)
        XCTAssertNil(nullDictionaryOfNull.data)
        XCTAssertNil(nullDictionaryOfNull.array)
        XCTAssertNil(nullDictionaryOfNull.dictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let boolValue = true
        let bool = Map(boolValue)
        XCTAssertEqual(bool, true)
        XCTAssertEqual(bool, .bool(boolValue))
        XCTAssertFalse(bool.isNull)
        XCTAssert(bool.isBool)
        XCTAssertFalse(bool.isDouble)
        XCTAssertFalse(bool.isInt)
        XCTAssertFalse(bool.isString)
        XCTAssertFalse(bool.isData)
        XCTAssertFalse(bool.isArray)
        XCTAssertFalse(bool.isDictionary)
        XCTAssertEqual(bool.bool, boolValue)
        XCTAssertNil(bool.double)
        XCTAssertNil(bool.int)
        XCTAssertNil(bool.string)
        XCTAssertNil(bool.data)
        XCTAssertNil(bool.array)
        XCTAssertNil(bool.dictionary)
        XCTAssertEqual(try bool.asBool(), boolValue)
        XCTAssertThrowsError(try bool.asDouble())
        XCTAssertThrowsError(try bool.asInt())
        XCTAssertThrowsError(try bool.asString())
        XCTAssertThrowsError(try bool.asData())
        XCTAssertThrowsError(try bool.asArray())
        XCTAssertThrowsError(try bool.asDictionary())

        let doubleValue = 4.20
        let double = Map(doubleValue)
        XCTAssertEqual(double, 4.20)
        XCTAssertEqual(double, .double(doubleValue))
        XCTAssertFalse(double.isNull)
        XCTAssertFalse(double.isBool)
        XCTAssert(double.isDouble)
        XCTAssertFalse(double.isInt)
        XCTAssertFalse(double.isString)
        XCTAssertFalse(double.isData)
        XCTAssertFalse(double.isArray)
        XCTAssertFalse(double.isDictionary)
        XCTAssertNil(double.bool)
        XCTAssertEqual(double.double, doubleValue)
        XCTAssertNil(double.int)
        XCTAssertNil(double.string)
        XCTAssertNil(double.data)
        XCTAssertNil(double.array)
        XCTAssertNil(double.dictionary)
        XCTAssertThrowsError(try double.asBool())
        XCTAssertEqual(try double.asDouble(), doubleValue)
        XCTAssertThrowsError(try double.asInt())
        XCTAssertThrowsError(try double.asString())
        XCTAssertThrowsError(try double.asData())
        XCTAssertThrowsError(try double.asArray())
        XCTAssertThrowsError(try double.asDictionary())

        let intValue = 1969
        let int = Map(intValue)
        XCTAssertEqual(int, 1969)
        XCTAssertEqual(int, .int(intValue))
        XCTAssertFalse(int.isNull)
        XCTAssertFalse(int.isBool)
        XCTAssertFalse(int.isDouble)
        XCTAssert(int.isInt)
        XCTAssertFalse(int.isString)
        XCTAssertFalse(int.isData)
        XCTAssertFalse(int.isArray)
        XCTAssertFalse(int.isDictionary)
        XCTAssertNil(int.bool)
        XCTAssertNil(int.double)
        XCTAssertEqual(int.int, intValue)
        XCTAssertNil(int.string)
        XCTAssertNil(int.data)
        XCTAssertNil(int.array)
        XCTAssertNil(int.dictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertEqual(try int.asInt(), intValue)
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let stringValue = "foo"
        let string = Map(stringValue)
        XCTAssertEqual(string, "foo")
        XCTAssertEqual(string, .string(stringValue))
        XCTAssertFalse(string.isNull)
        XCTAssertFalse(string.isBool)
        XCTAssertFalse(string.isDouble)
        XCTAssertFalse(string.isInt)
        XCTAssert(string.isString)
        XCTAssertFalse(string.isData)
        XCTAssertFalse(string.isArray)
        XCTAssertFalse(string.isDictionary)
        XCTAssertNil(string.bool)
        XCTAssertNil(string.double)
        XCTAssertNil(string.int)
        XCTAssertEqual(string.string, stringValue)
        XCTAssertNil(string.data)
        XCTAssertNil(string.array)
        XCTAssertNil(string.dictionary)
        XCTAssertThrowsError(try string.asBool())
        XCTAssertThrowsError(try string.asDouble())
        XCTAssertThrowsError(try string.asInt())
        XCTAssertEqual(try string.asString(), stringValue)
        XCTAssertThrowsError(try string.asData())
        XCTAssertThrowsError(try string.asArray())
        XCTAssertThrowsError(try string.asDictionary())

        let dataValue = Data("foo")
        let data = Map(dataValue)
        XCTAssertEqual(data, .data(dataValue))
        XCTAssertFalse(data.isNull)
        XCTAssertFalse(data.isBool)
        XCTAssertFalse(data.isDouble)
        XCTAssertFalse(data.isInt)
        XCTAssertFalse(data.isString)
        XCTAssert(data.isData)
        XCTAssertFalse(data.isArray)
        XCTAssertFalse(data.isDictionary)
        XCTAssertNil(data.bool)
        XCTAssertNil(data.double)
        XCTAssertNil(data.int)
        XCTAssertNil(data.string)
        XCTAssertEqual(data.data, dataValue)
        XCTAssertNil(data.array)
        XCTAssertNil(data.dictionary)
        XCTAssertThrowsError(try data.asBool())
        XCTAssertThrowsError(try data.asDouble())
        XCTAssertThrowsError(try data.asInt())
        XCTAssertThrowsError(try data.asString())
        XCTAssertEqual(try data.asData(), dataValue)
        XCTAssertThrowsError(try data.asArray())
        XCTAssertThrowsError(try data.asDictionary())

        let arrayValue = 1969
        let array = Map([arrayValue])
        XCTAssertEqual(array, [1969])
        XCTAssertEqual(array, .array([.int(arrayValue)]))
        XCTAssertFalse(array.isNull)
        XCTAssertFalse(array.isBool)
        XCTAssertFalse(array.isDouble)
        XCTAssertFalse(array.isInt)
        XCTAssertFalse(array.isString)
        XCTAssertFalse(array.isData)
        XCTAssert(array.isArray)
        XCTAssertFalse(array.isDictionary)
        XCTAssertNil(array.bool)
        XCTAssertNil(array.double)
        XCTAssertNil(array.int)
        XCTAssertNil(array.string)
        XCTAssertNil(array.data)
        if let a = array.array {
            XCTAssertEqual(a, [.int(arrayValue)])
        } else {
            XCTAssertNotNil(array.array)
        }
        XCTAssertNil(array.dictionary)
        XCTAssertThrowsError(try array.asBool())
        XCTAssertThrowsError(try array.asDouble())
        XCTAssertThrowsError(try array.asInt())
        XCTAssertThrowsError(try array.asString())
        XCTAssertThrowsError(try array.asData())
        XCTAssertEqual(try array.asArray(), [.int(arrayValue)])
        XCTAssertThrowsError(try array.asDictionary())

        let arrayOfOptionalValue: Int? = arrayValue
        let arrayOfOptional = Map([arrayOfOptionalValue])
        XCTAssertEqual(arrayOfOptional, [1969])
        XCTAssertEqual(arrayOfOptional, .array([.int(arrayValue)]))
        XCTAssertFalse(arrayOfOptional.isNull)
        XCTAssertFalse(arrayOfOptional.isBool)
        XCTAssertFalse(arrayOfOptional.isDouble)
        XCTAssertFalse(arrayOfOptional.isInt)
        XCTAssertFalse(arrayOfOptional.isString)
        XCTAssertFalse(arrayOfOptional.isData)
        XCTAssert(arrayOfOptional.isArray)
        XCTAssertFalse(arrayOfOptional.isDictionary)
        XCTAssertNil(arrayOfOptional.bool)
        XCTAssertNil(arrayOfOptional.double)
        XCTAssertNil(arrayOfOptional.int)
        XCTAssertNil(arrayOfOptional.string)
        XCTAssertNil(arrayOfOptional.data)
        if let a = arrayOfOptional.array {
            XCTAssertEqual(a, [.int(arrayValue)])
        } else {
            XCTAssertNotNil(arrayOfOptional.array)
        }
        XCTAssertNil(arrayOfOptional.dictionary)
        XCTAssertThrowsError(try arrayOfOptional.asBool())
        XCTAssertThrowsError(try arrayOfOptional.asDouble())
        XCTAssertThrowsError(try arrayOfOptional.asInt())
        XCTAssertThrowsError(try arrayOfOptional.asString())
        XCTAssertThrowsError(try arrayOfOptional.asData())
        XCTAssertEqual(try arrayOfOptional.asArray(), [.int(arrayValue)])
        XCTAssertThrowsError(try arrayOfOptional.asDictionary())

        let arrayOfNullValue: Int? = nil
        let arrayOfNull = Map([arrayOfNullValue])
        XCTAssertEqual(arrayOfNull, [nil])
        XCTAssertEqual(arrayOfNull, .array([.null]))
        XCTAssertFalse(arrayOfNull.isNull)
        XCTAssertFalse(arrayOfNull.isBool)
        XCTAssertFalse(arrayOfNull.isDouble)
        XCTAssertFalse(arrayOfNull.isInt)
        XCTAssertFalse(arrayOfNull.isString)
        XCTAssertFalse(arrayOfNull.isData)
        XCTAssert(arrayOfNull.isArray)
        XCTAssertFalse(arrayOfNull.isDictionary)
        XCTAssertNil(arrayOfNull.bool)
        XCTAssertNil(arrayOfNull.double)
        XCTAssertNil(arrayOfNull.int)
        XCTAssertNil(arrayOfNull.string)
        XCTAssertNil(arrayOfNull.data)
        if let a = arrayOfNull.array {
            XCTAssertEqual(a, [.null])
        } else {
            XCTAssertNotNil(arrayOfNull.array)
        }
        XCTAssertNil(arrayOfNull.dictionary)
        XCTAssertThrowsError(try arrayOfNull.asBool())
        XCTAssertThrowsError(try arrayOfNull.asDouble())
        XCTAssertThrowsError(try arrayOfNull.asInt())
        XCTAssertThrowsError(try arrayOfNull.asString())
        XCTAssertThrowsError(try arrayOfNull.asData())
        XCTAssertEqual(try arrayOfNull.asArray(), [.null])
        XCTAssertThrowsError(try arrayOfNull.asDictionary())

        let dictionaryValue = 1969
        let dictionary = Map(["foo": dictionaryValue])
        XCTAssertEqual(dictionary, ["foo": 1969])
        XCTAssertEqual(dictionary, .dictionary(["foo": .int(dictionaryValue)]))
        XCTAssertFalse(dictionary.isNull)
        XCTAssertFalse(dictionary.isBool)
        XCTAssertFalse(dictionary.isDouble)
        XCTAssertFalse(dictionary.isInt)
        XCTAssertFalse(dictionary.isString)
        XCTAssertFalse(dictionary.isData)
        XCTAssertFalse(dictionary.isArray)
        XCTAssert(dictionary.isDictionary)
        XCTAssertNil(dictionary.bool)
        XCTAssertNil(dictionary.double)
        XCTAssertNil(dictionary.int)
        XCTAssertNil(dictionary.string)
        XCTAssertNil(dictionary.data)
        XCTAssertNil(dictionary.array)
        if let d = dictionary.dictionary {
            XCTAssertEqual(d, ["foo": .int(dictionaryValue)])
        } else {
            XCTAssertNotNil(dictionary.dictionary)
        }
        XCTAssertThrowsError(try dictionary.asBool())
        XCTAssertThrowsError(try dictionary.asDouble())
        XCTAssertThrowsError(try dictionary.asInt())
        XCTAssertThrowsError(try dictionary.asString())
        XCTAssertThrowsError(try dictionary.asData())
        XCTAssertThrowsError(try dictionary.asArray())
        XCTAssertEqual(try dictionary.asDictionary(), ["foo": .int(dictionaryValue)])

        let dictionaryOfOptionalValue: Int? = dictionaryValue
        let dictionaryOfOptional = Map(["foo": dictionaryOfOptionalValue])
        XCTAssertEqual(dictionaryOfOptional, ["foo": 1969])
        XCTAssertEqual(dictionaryOfOptional, .dictionary(["foo": .int(dictionaryValue)]))
        XCTAssertFalse(dictionaryOfOptional.isNull)
        XCTAssertFalse(dictionaryOfOptional.isBool)
        XCTAssertFalse(dictionaryOfOptional.isDouble)
        XCTAssertFalse(dictionaryOfOptional.isInt)
        XCTAssertFalse(dictionaryOfOptional.isString)
        XCTAssertFalse(dictionaryOfOptional.isData)
        XCTAssertFalse(dictionaryOfOptional.isArray)
        XCTAssert(dictionaryOfOptional.isDictionary)
        XCTAssertNil(dictionaryOfOptional.bool)
        XCTAssertNil(dictionaryOfOptional.double)
        XCTAssertNil(dictionaryOfOptional.int)
        XCTAssertNil(dictionaryOfOptional.string)
        XCTAssertNil(dictionaryOfOptional.data)
        XCTAssertNil(dictionaryOfOptional.array)
        if let d = dictionaryOfOptional.dictionary {
            XCTAssertEqual(d, ["foo": .int(dictionaryValue)])
        } else {
            XCTAssertNotNil(dictionaryOfOptional.dictionary)
        }
        XCTAssertThrowsError(try dictionaryOfOptional.asBool())
        XCTAssertThrowsError(try dictionaryOfOptional.asDouble())
        XCTAssertThrowsError(try dictionaryOfOptional.asInt())
        XCTAssertThrowsError(try dictionaryOfOptional.asString())
        XCTAssertThrowsError(try dictionaryOfOptional.asData())
        XCTAssertThrowsError(try dictionaryOfOptional.asArray())
        XCTAssertEqual(try dictionaryOfOptional.asDictionary(), ["foo": .int(dictionaryValue)])

        let dictionaryOfNullValue: Int? = nil
        let dictionaryOfNull = Map(["foo": dictionaryOfNullValue])
        XCTAssertEqual(dictionaryOfNull, ["foo": nil])
        XCTAssertEqual(dictionaryOfNull, .dictionary(["foo": .null]))
        XCTAssertFalse(dictionaryOfNull.isNull)
        XCTAssertFalse(dictionaryOfNull.isBool)
        XCTAssertFalse(dictionaryOfNull.isDouble)
        XCTAssertFalse(dictionaryOfNull.isInt)
        XCTAssertFalse(dictionaryOfNull.isString)
        XCTAssertFalse(dictionaryOfNull.isData)
        XCTAssertFalse(dictionaryOfNull.isArray)
        XCTAssert(dictionaryOfNull.isDictionary)
        XCTAssertNil(dictionaryOfNull.bool)
        XCTAssertNil(dictionaryOfNull.double)
        XCTAssertNil(dictionaryOfNull.int)
        XCTAssertNil(dictionaryOfNull.string)
        XCTAssertNil(dictionaryOfNull.data)
        XCTAssertNil(dictionaryOfNull.array)
        if let d = dictionaryOfNull.dictionary {
            XCTAssertEqual(d, ["foo": .null])
        } else {
            XCTAssertNotNil(dictionaryOfNull.dictionary)
        }
        XCTAssertThrowsError(try dictionaryOfNull.asBool())
        XCTAssertThrowsError(try dictionaryOfNull.asDouble())
        XCTAssertThrowsError(try dictionaryOfNull.asInt())
        XCTAssertThrowsError(try dictionaryOfNull.asString())
        XCTAssertThrowsError(try dictionaryOfNull.asData())
        XCTAssertThrowsError(try dictionaryOfNull.asArray())
        XCTAssertEqual(try dictionaryOfNull.asDictionary(), ["foo": .null])
    }

    func testConversion() {
        let null: Map = nil
        XCTAssertEqual(try null.asBool(converting: true), false)
        XCTAssertEqual(try null.asDouble(converting: true), 0)
        XCTAssertEqual(try null.asInt(converting: true), 0)
        XCTAssertEqual(try null.asString(converting: true), "null")
        XCTAssertEqual(try null.asData(converting: true), Data())
        XCTAssertEqual(try null.asArray(converting: true), [])
        XCTAssertEqual(try null.asDictionary(converting: true), [:])

        let `true`: Map = true
        XCTAssertEqual(try `true`.asBool(converting: true), true)
        XCTAssertEqual(try `true`.asDouble(converting: true), 1.0)
        XCTAssertEqual(try `true`.asInt(converting: true), 1)
        XCTAssertEqual(try `true`.asString(converting: true), "true")
        XCTAssertEqual(try `true`.asData(converting: true), Data([0xff]))
        XCTAssertThrowsError(try `true`.asArray(converting: true))
        XCTAssertThrowsError(try `true`.asDictionary(converting: true))

        let `false`: Map = false
        XCTAssertEqual(try `false`.asBool(converting: true), false)
        XCTAssertEqual(try `false`.asDouble(converting: true), 0.0)
        XCTAssertEqual(try `false`.asInt(converting: true), 0)
        XCTAssertEqual(try `false`.asString(converting: true), "false")
        XCTAssertEqual(try `false`.asData(converting: true), Data([0x00]))
        XCTAssertThrowsError(try `false`.asArray(converting: true))
        XCTAssertThrowsError(try `false`.asDictionary(converting: true))

        let double: Map = 4.20
        XCTAssertEqual(try double.asBool(converting: true), true)
        XCTAssertEqual(try double.asDouble(converting: true), 4.20)
        XCTAssertEqual(try double.asInt(converting: true), 4)
        XCTAssertEqual(try double.asString(converting: true), "4.2")
        XCTAssertThrowsError(try double.asData(converting: true))
        XCTAssertThrowsError(try double.asArray(converting: true))
        XCTAssertThrowsError(try double.asDictionary(converting: true))

        let doubleZero: Map = 0.0
        XCTAssertEqual(try doubleZero.asBool(converting: true), false)
        XCTAssertEqual(try doubleZero.asDouble(converting: true), 0.0)
        XCTAssertEqual(try doubleZero.asInt(converting: true), 0)
        XCTAssertEqual(try doubleZero.asString(converting: true), "0.0")
        XCTAssertThrowsError(try doubleZero.asData(converting: true))
        XCTAssertThrowsError(try doubleZero.asArray(converting: true))
        XCTAssertThrowsError(try doubleZero.asDictionary(converting: true))

        let int: Map = 1969
        XCTAssertEqual(try int.asBool(converting: true), true)
        XCTAssertEqual(try int.asDouble(converting: true), 1969.0)
        XCTAssertEqual(try int.asInt(converting: true), 1969)
        XCTAssertEqual(try int.asString(converting: true), "1969")
        XCTAssertThrowsError(try int.asData(converting: true))
        XCTAssertThrowsError(try int.asArray(converting: true))
        XCTAssertThrowsError(try int.asDictionary(converting: true))

        let intZero: Map = 0
        XCTAssertEqual(try intZero.asBool(converting: true), false)
        XCTAssertEqual(try intZero.asDouble(converting: true), 0.0)
        XCTAssertEqual(try intZero.asInt(converting: true), 0)
        XCTAssertEqual(try intZero.asString(converting: true), "0")
        XCTAssertThrowsError(try intZero.asData(converting: true))
        XCTAssertThrowsError(try intZero.asArray(converting: true))
        XCTAssertThrowsError(try intZero.asDictionary(converting: true))

        let string: Map = "foo"
        XCTAssertThrowsError(try string.asBool(converting: true))
        XCTAssertThrowsError(try string.asDouble(converting: true))
        XCTAssertThrowsError(try string.asInt(converting: true))
        XCTAssertEqual(try string.asString(converting: true), "foo")
        XCTAssertEqual(try string.asData(converting: true), Data("foo"))
        XCTAssertThrowsError(try string.asArray(converting: true))
        XCTAssertThrowsError(try string.asDictionary(converting: true))

        let stringTrue: Map = "TRUE"
        XCTAssertEqual(try stringTrue.asBool(converting: true), true)
        XCTAssertThrowsError(try stringTrue.asDouble(converting: true))
        XCTAssertThrowsError(try stringTrue.asInt(converting: true))
        XCTAssertEqual(try stringTrue.asString(converting: true), "TRUE")
        XCTAssertEqual(try stringTrue.asData(converting: true), Data("TRUE"))
        XCTAssertThrowsError(try stringTrue.asArray(converting: true))
        XCTAssertThrowsError(try stringTrue.asDictionary(converting: true))

        let stringFalse: Map = "FALSE"
        XCTAssertEqual(try stringFalse.asBool(converting: true), false)
        XCTAssertThrowsError(try stringFalse.asDouble(converting: true))
        XCTAssertThrowsError(try stringFalse.asInt(converting: true))
        XCTAssertEqual(try stringFalse.asString(converting: true), "FALSE")
        XCTAssertEqual(try stringFalse.asData(converting: true), Data("FALSE"))
        XCTAssertThrowsError(try stringFalse.asArray(converting: true))
        XCTAssertThrowsError(try stringFalse.asDictionary(converting: true))

        let stringDouble: Map = "4.20"
        XCTAssertThrowsError(try stringDouble.asBool(converting: true))
        XCTAssertEqual(try stringDouble.asDouble(converting: true), 4.20)
        XCTAssertThrowsError(try stringDouble.asInt(converting: true))
        XCTAssertEqual(try stringDouble.asString(converting: true), "4.20")
        XCTAssertEqual(try stringDouble.asData(converting: true), Data("4.20"))
        XCTAssertThrowsError(try stringDouble.asArray(converting: true))
        XCTAssertThrowsError(try stringDouble.asDictionary(converting: true))

        let stringInt: Map = "1969"
        XCTAssertThrowsError(try stringInt.asBool(converting: true))
        XCTAssertEqual(try stringInt.asDouble(converting: true), 1969.0)
        XCTAssertEqual(try stringInt.asInt(converting: true), 1969)
        XCTAssertEqual(try stringInt.asString(converting: true), "1969")
        XCTAssertEqual(try stringInt.asData(converting: true), Data("1969"))
        XCTAssertThrowsError(try stringInt.asArray(converting: true))
        XCTAssertThrowsError(try stringInt.asDictionary(converting: true))

        let data: Map = .data(Data("foo"))
        XCTAssertEqual(try data.asBool(converting: true), true)
        XCTAssertThrowsError(try data.asDouble(converting: true))
        XCTAssertThrowsError(try data.asInt(converting: true))
        XCTAssertEqual(try data.asString(converting: true), "foo")
        XCTAssertEqual(try data.asData(converting: true), Data("foo"))
        XCTAssertThrowsError(try data.asArray(converting: true))
        XCTAssertThrowsError(try data.asDictionary(converting: true))

        let dataEmpty: Map = .data(Data())
        XCTAssertEqual(try dataEmpty.asBool(converting: true), false)
        XCTAssertThrowsError(try dataEmpty.asDouble(converting: true))
        XCTAssertThrowsError(try dataEmpty.asInt(converting: true))
        XCTAssertEqual(try dataEmpty.asString(converting: true), "")
        XCTAssertEqual(try dataEmpty.asData(converting: true), Data())
        XCTAssertThrowsError(try dataEmpty.asArray(converting: true))
        XCTAssertThrowsError(try dataEmpty.asDictionary(converting: true))

        let array: Map = [1969]
        XCTAssertEqual(try array.asBool(converting: true), true)
        XCTAssertThrowsError(try array.asDouble(converting: true))
        XCTAssertThrowsError(try array.asInt(converting: true))
        XCTAssertThrowsError(try array.asString(converting: true))
        XCTAssertThrowsError(try array.asData(converting: true))
        XCTAssertEqual(try array.asArray(converting: true), [1969])
        XCTAssertThrowsError(try array.asDictionary(converting: true))

        let arrayEmpty: Map = []
        XCTAssertEqual(try arrayEmpty.asBool(converting: true), false)
        XCTAssertThrowsError(try arrayEmpty.asDouble(converting: true))
        XCTAssertThrowsError(try arrayEmpty.asInt(converting: true))
        XCTAssertThrowsError(try arrayEmpty.asString(converting: true))
        XCTAssertThrowsError(try arrayEmpty.asData(converting: true))
        XCTAssertEqual(try arrayEmpty.asArray(converting: true), [])
        XCTAssertThrowsError(try arrayEmpty.asDictionary(converting: true))

        let dictionary: Map = ["foo": "bar"]
        XCTAssertEqual(try dictionary.asBool(converting: true), true)
        XCTAssertThrowsError(try dictionary.asDouble(converting: true))
        XCTAssertThrowsError(try dictionary.asInt(converting: true))
        XCTAssertThrowsError(try dictionary.asString(converting: true))
        XCTAssertThrowsError(try dictionary.asData(converting: true))
        XCTAssertThrowsError(try dictionary.asArray(converting: true))
        XCTAssertEqual(try dictionary.asDictionary(converting: true), ["foo": "bar"])

        let dictionaryEmpty: Map = [:]
        XCTAssertEqual(try dictionaryEmpty.asBool(converting: true), false)
        XCTAssertThrowsError(try dictionaryEmpty.asDouble(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asInt(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asString(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asData(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asArray(converting: true))
        XCTAssertEqual(try dictionaryEmpty.asDictionary(converting: true), [:])
    }

    func testDescription() {
        let data: Map = [
            "array": [
                [],
                true,
                .data(Data("bar")),
                [:],
                4.20,
                1969,
                nil,
                "foo\nbar",
            ],
            "bool": true,
            "data": .data(Data("bar")),
            "dictionary": [
                "array": [],
                "bool": true,
                "data": .data(Data("bar")),
                "dictionary": [:],
                "double": 4.20,
                "int": 1969,
                "null": nil,
                "string": "foo\nbar",
            ],
            "double": 4.20,
            "int": 1969,
            "null": nil,
            "string": "foo\nbar",
        ]

        let description = "{\"array\":[[],true,0x626172,{},4.2,1969,null,\"foo\\nbar\"],\"bool\":true,\"data\":0x626172,\"dictionary\":{\"array\":[],\"bool\":true,\"data\":0x626172,\"dictionary\":{},\"double\":4.2,\"int\":1969,\"null\":null,\"string\":\"foo\\nbar\"},\"double\":4.2,\"int\":1969,\"null\":null,\"string\":\"foo\\nbar\"}"

        XCTAssertEqual(data.description, description)
    }

    func testEquality() {
        let a: Map = "foo"
        let b: Map = 1968
        XCTAssertNotEqual(a, b)
    }

    func testIndexPath() throws {
        var data: Map

        data = [["foo"]]
        XCTAssertEqual(try data.get(0, 0), "foo")
        try data.set("bar", for: 0, 0)
        XCTAssertEqual(try data.get(0, 0), "bar")

        data = [["foo": "bar"]]
        XCTAssertEqual(try data.get(0, "foo"), "bar")
        try data.set("baz", for: 0, "foo")
        XCTAssertEqual(try data.get(0, "foo"), "baz")

        data = ["foo": ["bar"]]
        XCTAssertEqual(try data.get("foo", 0), "bar")
        try data.set("baz", for: "foo", 0)
        XCTAssertEqual(try data.get("foo", 0), "baz")

        data = ["foo": ["bar": "baz"]]
        XCTAssertEqual(try data.get("foo", "bar"), "baz")
        try data.set("buh", for: "foo", "bar")
        XCTAssertEqual(try data.get("foo", "bar"), "buh")
        try data.set("uhu", for: "foo", "yoo")
        XCTAssertEqual(try data.get("foo", "bar"), "buh")
        XCTAssertEqual(try data.get("foo", "yoo"), "uhu")
        try data.remove("foo", "bar")
        XCTAssertEqual(data, ["foo": ["yoo": "uhu"]])
    }

    func testMapInitializable() throws {
        struct Bar : MapInitializable {
            let bar: String
        }
        struct Foo : MapInitializable {
            let foo: Bar
        }
        struct Baz {
            let baz: String
        }
        struct Fuu : MapInitializable {
            let fuu: Baz
        }
        struct Fou : MapInitializable {
            let fou: String?
        }

        XCTAssertEqual(try Bar(map: ["bar": "bar"]).bar, "bar")
        XCTAssertThrowsError(try Bar(map: "bar"))
        XCTAssertThrowsError(try Bar(map: ["bar": nil]))
        XCTAssertEqual(try Foo(map: ["foo": ["bar": "bar"]]).foo.bar, "bar")
        XCTAssertThrowsError(try Fuu(map: ["fuu": ["baz": "baz"]]))
        XCTAssertEqual(try Fou(map: [:]).fou, nil)

        XCTAssertEqual(try Map(map: nil), nil)
        XCTAssertEqual(try Bool(map: true), true)
        XCTAssertThrowsError(try Bool(map: nil))
        XCTAssertEqual(try Double(map: 4.2), 4.2)
        XCTAssertThrowsError(try Double(map: nil))
        XCTAssertEqual(try Int(map: 4), 4)
        XCTAssertThrowsError(try Int(map: nil))
        XCTAssertEqual(try String(map: "foo"), "foo")
        XCTAssertThrowsError(try String(map: nil))
        XCTAssertEqual(try Data(map: .data(Data("foo"))), Data("foo"))
        XCTAssertThrowsError(try Data(map: nil))
        XCTAssertEqual(try Optional<Int>(map: nil), nil)
        XCTAssertEqual(try Optional<Int>(map: 1969), 1969)
        XCTAssertThrowsError(try Optional<Baz>(map: nil))

        XCTAssertEqual(try Array<Int>(map: [1969]), [1969])
        XCTAssertThrowsError(try Array<Int>(map: nil))
        XCTAssertThrowsError(try Array<Baz>(map: []))

        XCTAssertEqual(try Dictionary<String, Int>(map: ["foo": 1969]), ["foo": 1969])
        XCTAssertThrowsError(try Dictionary<String, Int>(map: nil))
        XCTAssertThrowsError(try Dictionary<Int, Int>(map: [:]))
        XCTAssertThrowsError(try Dictionary<String, Baz>(map: [:]))

        let map: Map = [
            "fey": [
                "foo": "bar",
                "fuu": "baz"
            ]
        ]

        struct Fey : MapInitializable {
            let foo: String
            let fuu: String
        }

        let fey: Fey = try map.get("fey")
        XCTAssertEqual(fey.foo, "bar")
        XCTAssertEqual(fey.fuu, "baz")
    }

    func testMapRepresentable() throws {
        struct Bar : MapFallibleRepresentable {
            let bar: String
        }
        struct Foo : MapFallibleRepresentable {
            let foo: Bar
        }
        struct Baz {
            let baz: String
        }
        struct Fuu : MapFallibleRepresentable {
            let fuu: Baz
        }

        XCTAssertEqual(try Foo(foo: Bar(bar: "bar")).asMap(), ["foo": ["bar": "bar"]])
        XCTAssertThrowsError(try Fuu(fuu: Baz(baz: "baz")).asMap())
        XCTAssertEqual(Map(1969).map, 1969)
        XCTAssertEqual(true.map, true)
        XCTAssertEqual(4.2.map, 4.2)
        XCTAssertEqual(1969.map, 1969)
        XCTAssertEqual("foo".map, "foo")
        XCTAssertEqual(Data("foo").map, .data(Data("foo")))
        let optional: Int? = nil
        XCTAssertEqual(optional.map, nil)
        XCTAssertEqual(Int?(1969).map, 1969)
        XCTAssertEqual([1969].map, [1969])
        XCTAssertEqual([1969].mapArray, [.int(1969)])
        XCTAssertEqual(["foo": 1969].map, ["foo": 1969])
        XCTAssertEqual(["foo": 1969].mapDictionary, ["foo": .int(1969)])
        XCTAssertEqual(try optional.asMap(), nil)
        XCTAssertEqual(try Int?(1969).asMap(), 1969)
        let fuuOptional: Baz? = nil
        XCTAssertThrowsError(try fuuOptional.asMap())
        XCTAssertEqual(try [1969].asMap(), [1969])
        let fuuArray: [Baz] = []
        XCTAssertThrowsError(try fuuArray.asMap())
        XCTAssertEqual(try ["foo": 1969].asMap(), ["foo": 1969])
        let fuuDictionaryA: [Int: Foo] = [:]
        XCTAssertThrowsError(try fuuDictionaryA.asMap())
        let fuuDictionaryB: [String: Baz] = [:]
        XCTAssertThrowsError(try fuuDictionaryB.asMap())
    }
}

extension MapTests {
    public static var allTests: [(String, (MapTests) -> () throws -> Void)] {
        return [
           ("testCreation", testCreation),
           ("testConversion", testConversion),
           ("testDescription", testDescription),
           ("testEquality", testEquality),
           ("testIndexPath", testIndexPath),
           ("testMapInitializable", testMapInitializable),
           ("testMapRepresentable", testMapRepresentable),
        ]
    }
}
