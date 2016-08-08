import XCTest
@testable import Quark

class StructuredDataTests : XCTestCase {
    func testCreation() {
        let nullValue: Bool? = nil
        let null = StructuredData(nullValue)
        XCTAssertEqual(null, nil)
        XCTAssertEqual(null, .null)
        XCTAssertEqual(null, .infer(nullValue))
        XCTAssert(null.isNull)
        XCTAssertFalse(null.isBool)
        XCTAssertFalse(null.isDouble)
        XCTAssertFalse(null.isInt)
        XCTAssertFalse(null.isString)
        XCTAssertFalse(null.isData)
        XCTAssertFalse(null.isArray)
        XCTAssertFalse(null.isDictionary)
        XCTAssertNil(null.asBool)
        XCTAssertNil(null.asDouble)
        XCTAssertNil(null.asInt)
        XCTAssertNil(null.asString)
        XCTAssertNil(null.asData)
        XCTAssertNil(null.asArray)
        XCTAssertNil(null.asDictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullArrayValue: [Bool]? = nil
        let nullArray = StructuredData(nullArrayValue)
        XCTAssertEqual(nullArray, nil)
        XCTAssertEqual(nullArray, .null)
        XCTAssertEqual(nullArray, .infer(nullArrayValue))
        XCTAssert(nullArray.isNull)
        XCTAssertFalse(nullArray.isBool)
        XCTAssertFalse(nullArray.isDouble)
        XCTAssertFalse(nullArray.isInt)
        XCTAssertFalse(nullArray.isString)
        XCTAssertFalse(nullArray.isData)
        XCTAssertFalse(nullArray.isArray)
        XCTAssertFalse(nullArray.isDictionary)
        XCTAssertNil(nullArray.asBool)
        XCTAssertNil(nullArray.asDouble)
        XCTAssertNil(nullArray.asInt)
        XCTAssertNil(nullArray.asString)
        XCTAssertNil(nullArray.asData)
        XCTAssertNil(nullArray.asArray)
        XCTAssertNil(nullArray.asDictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullArrayOfNullValue: [Bool?]? = nil
        let nullArrayOfNull = StructuredData(nullArrayOfNullValue)
        XCTAssertEqual(nullArrayOfNull, nil)
        XCTAssertEqual(nullArrayOfNull, .null)
        XCTAssertEqual(nullArrayOfNull, .infer(nullArrayOfNullValue))
        XCTAssert(nullArrayOfNull.isNull)
        XCTAssertFalse(nullArrayOfNull.isBool)
        XCTAssertFalse(nullArrayOfNull.isDouble)
        XCTAssertFalse(nullArrayOfNull.isInt)
        XCTAssertFalse(nullArrayOfNull.isString)
        XCTAssertFalse(nullArrayOfNull.isData)
        XCTAssertFalse(nullArrayOfNull.isArray)
        XCTAssertFalse(nullArrayOfNull.isDictionary)
        XCTAssertNil(nullArrayOfNull.asBool)
        XCTAssertNil(nullArrayOfNull.asDouble)
        XCTAssertNil(nullArrayOfNull.asInt)
        XCTAssertNil(nullArrayOfNull.asString)
        XCTAssertNil(nullArrayOfNull.asData)
        XCTAssertNil(nullArrayOfNull.asArray)
        XCTAssertNil(nullArrayOfNull.asDictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullDictionaryValue: [String: Bool]? = nil
        let nullDictionary = StructuredData(nullDictionaryValue)
        XCTAssertEqual(nullDictionary, nil)
        XCTAssertEqual(nullDictionary, .null)
        XCTAssertEqual(nullDictionary, .infer(nullDictionaryValue))
        XCTAssert(nullDictionary.isNull)
        XCTAssertFalse(nullDictionary.isBool)
        XCTAssertFalse(nullDictionary.isDouble)
        XCTAssertFalse(nullDictionary.isInt)
        XCTAssertFalse(nullDictionary.isString)
        XCTAssertFalse(nullDictionary.isData)
        XCTAssertFalse(nullDictionary.isArray)
        XCTAssertFalse(nullDictionary.isDictionary)
        XCTAssertNil(nullDictionary.asBool)
        XCTAssertNil(nullDictionary.asDouble)
        XCTAssertNil(nullDictionary.asInt)
        XCTAssertNil(nullDictionary.asString)
        XCTAssertNil(nullDictionary.asData)
        XCTAssertNil(nullDictionary.asArray)
        XCTAssertNil(nullDictionary.asDictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let nullDictionaryOfNullValue: [String: Bool?]? = nil
        let nullDictionaryOfNull = StructuredData(nullDictionaryOfNullValue)
        XCTAssertEqual(nullDictionaryOfNull, nil)
        XCTAssertEqual(nullDictionaryOfNull, .null)
        XCTAssertEqual(nullDictionaryOfNull, .infer(nullDictionaryOfNullValue))
        XCTAssert(nullDictionaryOfNull.isNull)
        XCTAssertFalse(nullDictionaryOfNull.isBool)
        XCTAssertFalse(nullDictionaryOfNull.isDouble)
        XCTAssertFalse(nullDictionaryOfNull.isInt)
        XCTAssertFalse(nullDictionaryOfNull.isString)
        XCTAssertFalse(nullDictionaryOfNull.isData)
        XCTAssertFalse(nullDictionaryOfNull.isArray)
        XCTAssertFalse(nullDictionaryOfNull.isDictionary)
        XCTAssertNil(nullDictionaryOfNull.asBool)
        XCTAssertNil(nullDictionaryOfNull.asDouble)
        XCTAssertNil(nullDictionaryOfNull.asInt)
        XCTAssertNil(nullDictionaryOfNull.asString)
        XCTAssertNil(nullDictionaryOfNull.asData)
        XCTAssertNil(nullDictionaryOfNull.asArray)
        XCTAssertNil(nullDictionaryOfNull.asDictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertThrowsError(try null.asInt())
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let boolValue = true
        let bool = StructuredData(boolValue)
        XCTAssertEqual(bool, true)
        XCTAssertEqual(bool, .bool(boolValue))
        XCTAssertEqual(bool, .infer(boolValue))
        XCTAssertFalse(bool.isNull)
        XCTAssert(bool.isBool)
        XCTAssertFalse(bool.isDouble)
        XCTAssertFalse(bool.isInt)
        XCTAssertFalse(bool.isString)
        XCTAssertFalse(bool.isData)
        XCTAssertFalse(bool.isArray)
        XCTAssertFalse(bool.isDictionary)
        XCTAssertEqual(bool.asBool, boolValue)
        XCTAssertNil(bool.asDouble)
        XCTAssertNil(bool.asInt)
        XCTAssertNil(bool.asString)
        XCTAssertNil(bool.asData)
        XCTAssertNil(bool.asArray)
        XCTAssertNil(bool.asDictionary)
        XCTAssertEqual(try bool.asBool(), boolValue)
        XCTAssertThrowsError(try bool.asDouble())
        XCTAssertThrowsError(try bool.asInt())
        XCTAssertThrowsError(try bool.asString())
        XCTAssertThrowsError(try bool.asData())
        XCTAssertThrowsError(try bool.asArray())
        XCTAssertThrowsError(try bool.asDictionary())

        let doubleValue = 4.20
        let double = StructuredData(doubleValue)
        XCTAssertEqual(double, 4.20)
        XCTAssertEqual(double, .double(doubleValue))
        XCTAssertEqual(double, .infer(doubleValue))
        XCTAssertFalse(double.isNull)
        XCTAssertFalse(double.isBool)
        XCTAssert(double.isDouble)
        XCTAssertFalse(double.isInt)
        XCTAssertFalse(double.isString)
        XCTAssertFalse(double.isData)
        XCTAssertFalse(double.isArray)
        XCTAssertFalse(double.isDictionary)
        XCTAssertNil(double.asBool)
        XCTAssertEqual(double.asDouble, doubleValue)
        XCTAssertNil(double.asInt)
        XCTAssertNil(double.asString)
        XCTAssertNil(double.asData)
        XCTAssertNil(double.asArray)
        XCTAssertNil(double.asDictionary)
        XCTAssertThrowsError(try double.asBool())
        XCTAssertEqual(try double.asDouble(), doubleValue)
        XCTAssertThrowsError(try double.asInt())
        XCTAssertThrowsError(try double.asString())
        XCTAssertThrowsError(try double.asData())
        XCTAssertThrowsError(try double.asArray())
        XCTAssertThrowsError(try double.asDictionary())

        let intValue = 1969
        let int = StructuredData(intValue)
        XCTAssertEqual(int, 1969)
        XCTAssertEqual(int, .int(intValue))
        XCTAssertEqual(int, .infer(intValue))
        XCTAssertFalse(int.isNull)
        XCTAssertFalse(int.isBool)
        XCTAssertFalse(int.isDouble)
        XCTAssert(int.isInt)
        XCTAssertFalse(int.isString)
        XCTAssertFalse(int.isData)
        XCTAssertFalse(int.isArray)
        XCTAssertFalse(int.isDictionary)
        XCTAssertNil(int.asBool)
        XCTAssertNil(int.asDouble)
        XCTAssertEqual(int.asInt, intValue)
        XCTAssertNil(int.asString)
        XCTAssertNil(int.asData)
        XCTAssertNil(int.asArray)
        XCTAssertNil(int.asDictionary)
        XCTAssertThrowsError(try null.asBool())
        XCTAssertThrowsError(try null.asDouble())
        XCTAssertEqual(try int.asInt(), intValue)
        XCTAssertThrowsError(try null.asString())
        XCTAssertThrowsError(try null.asData())
        XCTAssertThrowsError(try null.asArray())
        XCTAssertThrowsError(try null.asDictionary())

        let stringValue = "foo"
        let string = StructuredData(stringValue)
        XCTAssertEqual(string, "foo")
        XCTAssertEqual(string, .string(stringValue))
        XCTAssertEqual(string, .infer(stringValue))
        XCTAssertFalse(string.isNull)
        XCTAssertFalse(string.isBool)
        XCTAssertFalse(string.isDouble)
        XCTAssertFalse(string.isInt)
        XCTAssert(string.isString)
        XCTAssertFalse(string.isData)
        XCTAssertFalse(string.isArray)
        XCTAssertFalse(string.isDictionary)
        XCTAssertNil(string.asBool)
        XCTAssertNil(string.asDouble)
        XCTAssertNil(string.asInt)
        XCTAssertEqual(string.asString, stringValue)
        XCTAssertNil(string.asData)
        XCTAssertNil(string.asArray)
        XCTAssertNil(string.asDictionary)
        XCTAssertThrowsError(try string.asBool())
        XCTAssertThrowsError(try string.asDouble())
        XCTAssertThrowsError(try string.asInt())
        XCTAssertEqual(try string.asString(), stringValue)
        XCTAssertThrowsError(try string.asData())
        XCTAssertThrowsError(try string.asArray())
        XCTAssertThrowsError(try string.asDictionary())

        let dataValue: C7.Data = "foo"
        let data = StructuredData(dataValue)
        XCTAssertEqual(data, .data(dataValue))
        XCTAssertEqual(data, .infer(dataValue))
        XCTAssertFalse(data.isNull)
        XCTAssertFalse(data.isBool)
        XCTAssertFalse(data.isDouble)
        XCTAssertFalse(data.isInt)
        XCTAssertFalse(data.isString)
        XCTAssert(data.isData)
        XCTAssertFalse(data.isArray)
        XCTAssertFalse(data.isDictionary)
        XCTAssertNil(data.asBool)
        XCTAssertNil(data.asDouble)
        XCTAssertNil(data.asInt)
        XCTAssertNil(data.asString)
        XCTAssertEqual(data.asData, dataValue)
        XCTAssertNil(data.asArray)
        XCTAssertNil(data.asDictionary)
        XCTAssertThrowsError(try data.asBool())
        XCTAssertThrowsError(try data.asDouble())
        XCTAssertThrowsError(try data.asInt())
        XCTAssertThrowsError(try data.asString())
        XCTAssertEqual(try data.asData(), dataValue)
        XCTAssertThrowsError(try data.asArray())
        XCTAssertThrowsError(try data.asDictionary())

        let arrayValue = 1969
        let array = StructuredData([arrayValue])
        XCTAssertEqual(array, [1969])
        XCTAssertEqual(array, .array([.int(arrayValue)]))
        XCTAssertEqual(array, .infer([arrayValue]))
        XCTAssertFalse(array.isNull)
        XCTAssertFalse(array.isBool)
        XCTAssertFalse(array.isDouble)
        XCTAssertFalse(array.isInt)
        XCTAssertFalse(array.isString)
        XCTAssertFalse(array.isData)
        XCTAssert(array.isArray)
        XCTAssertFalse(array.isDictionary)
        XCTAssertNil(array.asBool)
        XCTAssertNil(array.asDouble)
        XCTAssertNil(array.asInt)
        XCTAssertNil(array.asString)
        XCTAssertNil(array.asData)
        if let a = array.asArray {
            XCTAssertEqual(a, [.int(arrayValue)])
        } else {
            XCTAssertNotNil(array.asArray)
        }
        XCTAssertNil(array.asDictionary)
        XCTAssertThrowsError(try array.asBool())
        XCTAssertThrowsError(try array.asDouble())
        XCTAssertThrowsError(try array.asInt())
        XCTAssertThrowsError(try array.asString())
        XCTAssertThrowsError(try array.asData())
        XCTAssertEqual(try array.asArray(), [.int(arrayValue)])
        XCTAssertThrowsError(try array.asDictionary())

        let arrayOfOptionalValue: Int? = arrayValue
        let arrayOfOptional = StructuredData([arrayOfOptionalValue])
        XCTAssertEqual(arrayOfOptional, [1969])
        XCTAssertEqual(arrayOfOptional, .array([.int(arrayValue)]))
        XCTAssertEqual(arrayOfOptional, .infer([arrayOfOptionalValue]))
        XCTAssertFalse(arrayOfOptional.isNull)
        XCTAssertFalse(arrayOfOptional.isBool)
        XCTAssertFalse(arrayOfOptional.isDouble)
        XCTAssertFalse(arrayOfOptional.isInt)
        XCTAssertFalse(arrayOfOptional.isString)
        XCTAssertFalse(arrayOfOptional.isData)
        XCTAssert(arrayOfOptional.isArray)
        XCTAssertFalse(arrayOfOptional.isDictionary)
        XCTAssertNil(arrayOfOptional.asBool)
        XCTAssertNil(arrayOfOptional.asDouble)
        XCTAssertNil(arrayOfOptional.asInt)
        XCTAssertNil(arrayOfOptional.asString)
        XCTAssertNil(arrayOfOptional.asData)
        if let a = arrayOfOptional.asArray {
            XCTAssertEqual(a, [.int(arrayValue)])
        } else {
            XCTAssertNotNil(arrayOfOptional.asArray)
        }
        XCTAssertNil(arrayOfOptional.asDictionary)
        XCTAssertThrowsError(try arrayOfOptional.asBool())
        XCTAssertThrowsError(try arrayOfOptional.asDouble())
        XCTAssertThrowsError(try arrayOfOptional.asInt())
        XCTAssertThrowsError(try arrayOfOptional.asString())
        XCTAssertThrowsError(try arrayOfOptional.asData())
        XCTAssertEqual(try arrayOfOptional.asArray(), [.int(arrayValue)])
        XCTAssertThrowsError(try arrayOfOptional.asDictionary())

        let arrayOfNullValue: Int? = nil
        let arrayOfNull = StructuredData([arrayOfNullValue])
        XCTAssertEqual(arrayOfNull, [nil])
        XCTAssertEqual(arrayOfNull, .array([.null]))
        XCTAssertEqual(arrayOfNull, .infer([arrayOfNullValue]))
        XCTAssertFalse(arrayOfNull.isNull)
        XCTAssertFalse(arrayOfNull.isBool)
        XCTAssertFalse(arrayOfNull.isDouble)
        XCTAssertFalse(arrayOfNull.isInt)
        XCTAssertFalse(arrayOfNull.isString)
        XCTAssertFalse(arrayOfNull.isData)
        XCTAssert(arrayOfNull.isArray)
        XCTAssertFalse(arrayOfNull.isDictionary)
        XCTAssertNil(arrayOfNull.asBool)
        XCTAssertNil(arrayOfNull.asDouble)
        XCTAssertNil(arrayOfNull.asInt)
        XCTAssertNil(arrayOfNull.asString)
        XCTAssertNil(arrayOfNull.asData)
        if let a = arrayOfNull.asArray {
            XCTAssertEqual(a, [.null])
        } else {
            XCTAssertNotNil(arrayOfNull.asArray)
        }
        XCTAssertNil(arrayOfNull.asDictionary)
        XCTAssertThrowsError(try arrayOfNull.asBool())
        XCTAssertThrowsError(try arrayOfNull.asDouble())
        XCTAssertThrowsError(try arrayOfNull.asInt())
        XCTAssertThrowsError(try arrayOfNull.asString())
        XCTAssertThrowsError(try arrayOfNull.asData())
        XCTAssertEqual(try arrayOfNull.asArray(), [.null])
        XCTAssertThrowsError(try arrayOfNull.asDictionary())

        let dictionaryValue = 1969
        let dictionary = StructuredData(["foo": dictionaryValue])
        XCTAssertEqual(dictionary, ["foo": 1969])
        XCTAssertEqual(dictionary, .dictionary(["foo": .int(dictionaryValue)]))
        XCTAssertEqual(dictionary, .infer(["foo": dictionaryValue]))
        XCTAssertFalse(dictionary.isNull)
        XCTAssertFalse(dictionary.isBool)
        XCTAssertFalse(dictionary.isDouble)
        XCTAssertFalse(dictionary.isInt)
        XCTAssertFalse(dictionary.isString)
        XCTAssertFalse(dictionary.isData)
        XCTAssertFalse(dictionary.isArray)
        XCTAssert(dictionary.isDictionary)
        XCTAssertNil(dictionary.asBool)
        XCTAssertNil(dictionary.asDouble)
        XCTAssertNil(dictionary.asInt)
        XCTAssertNil(dictionary.asString)
        XCTAssertNil(dictionary.asData)
        XCTAssertNil(dictionary.asArray)
        if let d = dictionary.asDictionary {
            XCTAssertEqual(d, ["foo": .int(dictionaryValue)])
        } else {
            XCTAssertNotNil(dictionary.asDictionary)
        }
        XCTAssertThrowsError(try dictionary.asBool())
        XCTAssertThrowsError(try dictionary.asDouble())
        XCTAssertThrowsError(try dictionary.asInt())
        XCTAssertThrowsError(try dictionary.asString())
        XCTAssertThrowsError(try dictionary.asData())
        XCTAssertThrowsError(try dictionary.asArray())
        XCTAssertEqual(try dictionary.asDictionary(), ["foo": .int(dictionaryValue)])

        let dictionaryOfOptionalValue: Int? = dictionaryValue
        let dictionaryOfOptional = StructuredData(["foo": dictionaryOfOptionalValue])
        XCTAssertEqual(dictionaryOfOptional, ["foo": 1969])
        XCTAssertEqual(dictionaryOfOptional, .dictionary(["foo": .int(dictionaryValue)]))
        XCTAssertEqual(dictionaryOfOptional, .infer(["foo": dictionaryOfOptionalValue]))
        XCTAssertFalse(dictionaryOfOptional.isNull)
        XCTAssertFalse(dictionaryOfOptional.isBool)
        XCTAssertFalse(dictionaryOfOptional.isDouble)
        XCTAssertFalse(dictionaryOfOptional.isInt)
        XCTAssertFalse(dictionaryOfOptional.isString)
        XCTAssertFalse(dictionaryOfOptional.isData)
        XCTAssertFalse(dictionaryOfOptional.isArray)
        XCTAssert(dictionaryOfOptional.isDictionary)
        XCTAssertNil(dictionaryOfOptional.asBool)
        XCTAssertNil(dictionaryOfOptional.asDouble)
        XCTAssertNil(dictionaryOfOptional.asInt)
        XCTAssertNil(dictionaryOfOptional.asString)
        XCTAssertNil(dictionaryOfOptional.asData)
        XCTAssertNil(dictionaryOfOptional.asArray)
        if let d = dictionaryOfOptional.asDictionary {
            XCTAssertEqual(d, ["foo": .int(dictionaryValue)])
        } else {
            XCTAssertNotNil(dictionaryOfOptional.asDictionary)
        }
        XCTAssertThrowsError(try dictionaryOfOptional.asBool())
        XCTAssertThrowsError(try dictionaryOfOptional.asDouble())
        XCTAssertThrowsError(try dictionaryOfOptional.asInt())
        XCTAssertThrowsError(try dictionaryOfOptional.asString())
        XCTAssertThrowsError(try dictionaryOfOptional.asData())
        XCTAssertThrowsError(try dictionaryOfOptional.asArray())
        XCTAssertEqual(try dictionaryOfOptional.asDictionary(), ["foo": .int(dictionaryValue)])

        let dictionaryOfNullValue: Int? = nil
        let dictionaryOfNull = StructuredData(["foo": dictionaryOfNullValue])
        XCTAssertEqual(dictionaryOfNull, ["foo": nil])
        XCTAssertEqual(dictionaryOfNull, .dictionary(["foo": .null]))
        XCTAssertEqual(dictionaryOfNull, .infer(["foo": dictionaryOfNullValue]))
        XCTAssertFalse(dictionaryOfNull.isNull)
        XCTAssertFalse(dictionaryOfNull.isBool)
        XCTAssertFalse(dictionaryOfNull.isDouble)
        XCTAssertFalse(dictionaryOfNull.isInt)
        XCTAssertFalse(dictionaryOfNull.isString)
        XCTAssertFalse(dictionaryOfNull.isData)
        XCTAssertFalse(dictionaryOfNull.isArray)
        XCTAssert(dictionaryOfNull.isDictionary)
        XCTAssertNil(dictionaryOfNull.asBool)
        XCTAssertNil(dictionaryOfNull.asDouble)
        XCTAssertNil(dictionaryOfNull.asInt)
        XCTAssertNil(dictionaryOfNull.asString)
        XCTAssertNil(dictionaryOfNull.asData)
        XCTAssertNil(dictionaryOfNull.asArray)
        if let d = dictionaryOfNull.asDictionary {
            XCTAssertEqual(d, ["foo": .null])
        } else {
            XCTAssertNotNil(dictionaryOfNull.asDictionary)
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
        let null: StructuredData = nil
        XCTAssertEqual(try null.asBool(converting: true), false)
        XCTAssertEqual(try null.asDouble(converting: true), 0)
        XCTAssertEqual(try null.asInt(converting: true), 0)
        XCTAssertEqual(try null.asString(converting: true), "null")
        XCTAssertEqual(try null.asData(converting: true), [])
        XCTAssertEqual(try null.asArray(converting: true), [])
        XCTAssertEqual(try null.asDictionary(converting: true), [:])

        let `true`: StructuredData = true
        XCTAssertEqual(try `true`.asBool(converting: true), true)
        XCTAssertEqual(try `true`.asDouble(converting: true), 1.0)
        XCTAssertEqual(try `true`.asInt(converting: true), 1)
        XCTAssertEqual(try `true`.asString(converting: true), "true")
        XCTAssertEqual(try `true`.asData(converting: true), [0xff])
        XCTAssertThrowsError(try `true`.asArray(converting: true))
        XCTAssertThrowsError(try `true`.asDictionary(converting: true))

        let `false`: StructuredData = false
        XCTAssertEqual(try `false`.asBool(converting: true), false)
        XCTAssertEqual(try `false`.asDouble(converting: true), 0.0)
        XCTAssertEqual(try `false`.asInt(converting: true), 0)
        XCTAssertEqual(try `false`.asString(converting: true), "false")
        XCTAssertEqual(try `false`.asData(converting: true), [0x00])
        XCTAssertThrowsError(try `false`.asArray(converting: true))
        XCTAssertThrowsError(try `false`.asDictionary(converting: true))

        let double: StructuredData = 4.20
        XCTAssertEqual(try double.asBool(converting: true), true)
        XCTAssertEqual(try double.asDouble(converting: true), 4.20)
        XCTAssertEqual(try double.asInt(converting: true), 4)
        XCTAssertEqual(try double.asString(converting: true), "4.2")
        XCTAssertThrowsError(try double.asData(converting: true))
        XCTAssertThrowsError(try double.asArray(converting: true))
        XCTAssertThrowsError(try double.asDictionary(converting: true))

        let doubleZero: StructuredData = 0.0
        XCTAssertEqual(try doubleZero.asBool(converting: true), false)
        XCTAssertEqual(try doubleZero.asDouble(converting: true), 0.0)
        XCTAssertEqual(try doubleZero.asInt(converting: true), 0)
        XCTAssertEqual(try doubleZero.asString(converting: true), "0.0")
        XCTAssertThrowsError(try doubleZero.asData(converting: true))
        XCTAssertThrowsError(try doubleZero.asArray(converting: true))
        XCTAssertThrowsError(try doubleZero.asDictionary(converting: true))

        let int: StructuredData = 1969
        XCTAssertEqual(try int.asBool(converting: true), true)
        XCTAssertEqual(try int.asDouble(converting: true), 1969.0)
        XCTAssertEqual(try int.asInt(converting: true), 1969)
        XCTAssertEqual(try int.asString(converting: true), "1969")
        XCTAssertThrowsError(try int.asData(converting: true))
        XCTAssertThrowsError(try int.asArray(converting: true))
        XCTAssertThrowsError(try int.asDictionary(converting: true))

        let intZero: StructuredData = 0
        XCTAssertEqual(try intZero.asBool(converting: true), false)
        XCTAssertEqual(try intZero.asDouble(converting: true), 0.0)
        XCTAssertEqual(try intZero.asInt(converting: true), 0)
        XCTAssertEqual(try intZero.asString(converting: true), "0")
        XCTAssertThrowsError(try intZero.asData(converting: true))
        XCTAssertThrowsError(try intZero.asArray(converting: true))
        XCTAssertThrowsError(try intZero.asDictionary(converting: true))

        let string: StructuredData = "foo"
        XCTAssertThrowsError(try string.asBool(converting: true))
        XCTAssertThrowsError(try string.asDouble(converting: true))
        XCTAssertThrowsError(try string.asInt(converting: true))
        XCTAssertEqual(try string.asString(converting: true), "foo")
        XCTAssertEqual(try string.asData(converting: true), Data("foo"))
        XCTAssertThrowsError(try string.asArray(converting: true))
        XCTAssertThrowsError(try string.asDictionary(converting: true))

        let stringTrue: StructuredData = "TRUE"
        XCTAssertEqual(try stringTrue.asBool(converting: true), true)
        XCTAssertThrowsError(try stringTrue.asDouble(converting: true))
        XCTAssertThrowsError(try stringTrue.asInt(converting: true))
        XCTAssertEqual(try stringTrue.asString(converting: true), "TRUE")
        XCTAssertEqual(try stringTrue.asData(converting: true), Data("TRUE"))
        XCTAssertThrowsError(try stringTrue.asArray(converting: true))
        XCTAssertThrowsError(try stringTrue.asDictionary(converting: true))

        let stringFalse: StructuredData = "FALSE"
        XCTAssertEqual(try stringFalse.asBool(converting: true), false)
        XCTAssertThrowsError(try stringFalse.asDouble(converting: true))
        XCTAssertThrowsError(try stringFalse.asInt(converting: true))
        XCTAssertEqual(try stringFalse.asString(converting: true), "FALSE")
        XCTAssertEqual(try stringFalse.asData(converting: true), Data("FALSE"))
        XCTAssertThrowsError(try stringFalse.asArray(converting: true))
        XCTAssertThrowsError(try stringFalse.asDictionary(converting: true))

        let stringDouble: StructuredData = "4.20"
        XCTAssertThrowsError(try stringDouble.asBool(converting: true))
        XCTAssertEqual(try stringDouble.asDouble(converting: true), 4.20)
        XCTAssertThrowsError(try stringDouble.asInt(converting: true))
        XCTAssertEqual(try stringDouble.asString(converting: true), "4.20")
        XCTAssertEqual(try stringDouble.asData(converting: true), Data("4.20"))
        XCTAssertThrowsError(try stringDouble.asArray(converting: true))
        XCTAssertThrowsError(try stringDouble.asDictionary(converting: true))

        let stringInt: StructuredData = "1969"
        XCTAssertThrowsError(try stringInt.asBool(converting: true))
        XCTAssertEqual(try stringInt.asDouble(converting: true), 1969.0)
        XCTAssertEqual(try stringInt.asInt(converting: true), 1969)
        XCTAssertEqual(try stringInt.asString(converting: true), "1969")
        XCTAssertEqual(try stringInt.asData(converting: true), Data("1969"))
        XCTAssertThrowsError(try stringInt.asArray(converting: true))
        XCTAssertThrowsError(try stringInt.asDictionary(converting: true))

        let data: StructuredData = .data("foo")
        XCTAssertEqual(try data.asBool(converting: true), true)
        XCTAssertThrowsError(try data.asDouble(converting: true))
        XCTAssertThrowsError(try data.asInt(converting: true))
        XCTAssertEqual(try data.asString(converting: true), "foo")
        XCTAssertEqual(try data.asData(converting: true), "foo")
        XCTAssertThrowsError(try data.asArray(converting: true))
        XCTAssertThrowsError(try data.asDictionary(converting: true))

        let dataEmpty: StructuredData = .data([])
        XCTAssertEqual(try dataEmpty.asBool(converting: true), false)
        XCTAssertThrowsError(try dataEmpty.asDouble(converting: true))
        XCTAssertThrowsError(try dataEmpty.asInt(converting: true))
        XCTAssertEqual(try dataEmpty.asString(converting: true), "")
        XCTAssertEqual(try dataEmpty.asData(converting: true), [])
        XCTAssertThrowsError(try dataEmpty.asArray(converting: true))
        XCTAssertThrowsError(try dataEmpty.asDictionary(converting: true))

        let array: StructuredData = [1969]
        XCTAssertEqual(try array.asBool(converting: true), true)
        XCTAssertThrowsError(try array.asDouble(converting: true))
        XCTAssertThrowsError(try array.asInt(converting: true))
        XCTAssertThrowsError(try array.asString(converting: true))
        XCTAssertThrowsError(try array.asData(converting: true))
        XCTAssertEqual(try array.asArray(converting: true), [1969])
        XCTAssertThrowsError(try array.asDictionary(converting: true))

        let arrayEmpty: StructuredData = []
        XCTAssertEqual(try arrayEmpty.asBool(converting: true), false)
        XCTAssertThrowsError(try arrayEmpty.asDouble(converting: true))
        XCTAssertThrowsError(try arrayEmpty.asInt(converting: true))
        XCTAssertThrowsError(try arrayEmpty.asString(converting: true))
        XCTAssertThrowsError(try arrayEmpty.asData(converting: true))
        XCTAssertEqual(try arrayEmpty.asArray(converting: true), [])
        XCTAssertThrowsError(try arrayEmpty.asDictionary(converting: true))

        let dictionary: StructuredData = ["foo": "bar"]
        XCTAssertEqual(try dictionary.asBool(converting: true), true)
        XCTAssertThrowsError(try dictionary.asDouble(converting: true))
        XCTAssertThrowsError(try dictionary.asInt(converting: true))
        XCTAssertThrowsError(try dictionary.asString(converting: true))
        XCTAssertThrowsError(try dictionary.asData(converting: true))
        XCTAssertThrowsError(try dictionary.asArray(converting: true))
        XCTAssertEqual(try dictionary.asDictionary(converting: true), ["foo": "bar"])

        let dictionaryEmpty: StructuredData = [:]
        XCTAssertEqual(try dictionaryEmpty.asBool(converting: true), false)
        XCTAssertThrowsError(try dictionaryEmpty.asDouble(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asInt(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asString(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asData(converting: true))
        XCTAssertThrowsError(try dictionaryEmpty.asArray(converting: true))
        XCTAssertEqual(try dictionaryEmpty.asDictionary(converting: true), [:])
    }

    func testDescription() {
        let data: StructuredData = [
            "array": [
                [],
                true,
                .data("bar"),
                [:],
                4.20,
                1969,
                nil,
                "foo\nbar",
            ],
            "bool": true,
            "data": .data("bar"),
            "dictionary": [
                "array": [],
                "bool": true,
                "data": .data("bar"),
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

    func testStringInterpolationLiteral() {
        var data: StructuredData = "\(1969)+\(4.20)"
        XCTAssertEqual(data, .string("1969+4.2"))
        data = StructuredData(unicodeScalarLiteral: "foo")
        XCTAssertEqual(data, .string("foo"))
        data = StructuredData(extendedGraphemeClusterLiteral: "foo")
        XCTAssertEqual(data, .string("foo"))
    }

    func testEquality() {
        let a: StructuredData = "foo"
        let b: StructuredData = 1968
        XCTAssertNotEqual(a, b)
    }

    func testIndexPath() throws {
        var data: StructuredData

        data = [["foo"]]
        XCTAssertEqual(try data.get(at: 0, 0), "foo")
        try data.set(value: "bar", at: 0, 0)
        XCTAssertEqual(try data.get(at: 0, 0), "bar")

        data = [["foo": "bar"]]
        XCTAssertEqual(try data.get(at: 0, "foo"), "bar")
        try data.set(value: "baz", at: 0, "foo")
        XCTAssertEqual(try data.get(at: 0, "foo"), "baz")

        data = ["foo": ["bar"]]
        XCTAssertEqual(try data.get(at: "foo", 0), "bar")
        try data.set(value: "baz", at: "foo", 0)
        XCTAssertEqual(try data.get(at: "foo", 0), "baz")

        data = ["foo": ["bar": "baz"]]
        XCTAssertEqual(try data.get(at: "foo", "bar"), "baz")
        try data.set(value: "buh", at: "foo", "bar")
        XCTAssertEqual(try data.get(at: "foo", "bar"), "buh")
        try data.set(value: "uhu", at: "foo", "yoo")
        XCTAssertEqual(try data.get(at: "foo", "bar"), "buh")
        XCTAssertEqual(try data.get(at: "foo", "yoo"), "uhu")
        try data.remove(at: "foo", "bar")
        XCTAssertEqual(data, ["foo": ["yoo": "uhu"]])
    }

    func testStructuredDataInitializable() throws {
        struct Bar : StructuredDataInitializable {
            let bar: String
        }
        struct Foo : StructuredDataInitializable {
            let foo: Bar
        }
        struct Baz {
            let baz: String
        }
        struct Fuu : StructuredDataInitializable {
            let fuu: Baz
        }
        struct Fou : StructuredDataInitializable {
            let fou: String?
        }

        XCTAssertEqual(try Bar(structuredData: ["bar": "bar"]).bar, "bar")
        XCTAssertThrowsError(try Bar(structuredData: "bar"))
        XCTAssertThrowsError(try Bar(structuredData: ["bar": nil]))
        XCTAssertEqual(try Foo(structuredData: ["foo": ["bar": "bar"]]).foo.bar, "bar")
        XCTAssertThrowsError(try Fuu(structuredData: ["fuu": ["baz": "baz"]]))
        XCTAssertEqual(try Fou(structuredData: [:]).fou, nil)

        XCTAssertEqual(try StructuredData(structuredData: nil), nil)
        XCTAssertEqual(try Bool(structuredData: true), true)
        XCTAssertThrowsError(try Bool(structuredData: nil))
        XCTAssertEqual(try Double(structuredData: 4.2), 4.2)
        XCTAssertThrowsError(try Double(structuredData: nil))
        XCTAssertEqual(try Int(structuredData: 4), 4)
        XCTAssertThrowsError(try Int(structuredData: nil))
        XCTAssertEqual(try String(structuredData: "foo"), "foo")
        XCTAssertThrowsError(try String(structuredData: nil))
        XCTAssertEqual(try Data(structuredData: .data("foo")), Data("foo"))
        XCTAssertThrowsError(try Data(structuredData: nil))
        XCTAssertEqual(try Optional<Int>(structuredData: nil), nil)
        XCTAssertEqual(try Optional<Int>(structuredData: 1969), 1969)
        XCTAssertThrowsError(try Optional<Baz>(structuredData: nil))

        XCTAssertEqual(try Array<Int>(structuredData: [1969]), [1969])
        XCTAssertThrowsError(try Array<Int>(structuredData: nil))
        XCTAssertThrowsError(try Array<Baz>(structuredData: []))

        XCTAssertEqual(try Dictionary<String, Int>(structuredData: ["foo": 1969]), ["foo": 1969])
        XCTAssertThrowsError(try Dictionary<String, Int>(structuredData: nil))
        XCTAssertThrowsError(try Dictionary<Int, Int>(structuredData: [:]))
        XCTAssertThrowsError(try Dictionary<String, Baz>(structuredData: [:]))
    }

    func testStructuredDataRepresentable() throws {
        struct Bar : StructuredDataFallibleRepresentable {
            let bar: String
        }
        struct Foo : StructuredDataFallibleRepresentable {
            let foo: Bar
        }
        struct Baz {
            let baz: String
        }
        struct Fuu : StructuredDataFallibleRepresentable {
            let fuu: Baz
        }

        XCTAssertEqual(try Foo(foo: Bar(bar: "bar")).asStructuredData(), ["foo": ["bar": "bar"]])
        XCTAssertThrowsError(try Fuu(fuu: Baz(baz: "baz")).asStructuredData())
        XCTAssertEqual(StructuredData(1969).structuredData, 1969)
        XCTAssertEqual(true.structuredData, true)
        XCTAssertEqual(4.2.structuredData, 4.2)
        XCTAssertEqual(1969.structuredData, 1969)
        XCTAssertEqual("foo".structuredData, "foo")
        XCTAssertEqual(Data("foo").structuredData, .data("foo"))
        let optional: Int? = nil
        XCTAssertEqual(optional.structuredData, nil)
        XCTAssertEqual(Int?(1969).structuredData, 1969)
        XCTAssertEqual([1969].structuredData, [1969])
        XCTAssertEqual([1969].structuredDataArray, [.int(1969)])
        XCTAssertEqual(["foo": 1969].structuredData, ["foo": 1969])
        XCTAssertEqual(["foo": 1969].structuredDataDictionary, ["foo": .int(1969)])
        XCTAssertEqual(try optional.asStructuredData(), nil)
        XCTAssertEqual(try Int?(1969).asStructuredData(), 1969)
        let fuuOptional: Baz? = nil
        XCTAssertThrowsError(try fuuOptional.asStructuredData())
        XCTAssertEqual(try [1969].asStructuredData(), [1969])
        let fuuArray: [Baz] = []
        XCTAssertThrowsError(try fuuArray.asStructuredData())
        XCTAssertEqual(try ["foo": 1969].asStructuredData(), ["foo": 1969])
        let fuuDictionaryA: [Int: Foo] = [:]
        XCTAssertThrowsError(try fuuDictionaryA.asStructuredData())
        let fuuDictionaryB: [String: Baz] = [:]
        XCTAssertThrowsError(try fuuDictionaryB.asStructuredData())
    }
}

extension StructuredDataTests {
    static var allTests: [(String, (StructuredDataTests) -> () throws -> Void)] {
        return [
           ("testCreation", testCreation),
           ("testConversion", testConversion),
           ("testDescription", testDescription),
           ("testStringInterpolationLiteral", testStringInterpolationLiteral),
           ("testEquality", testEquality),
           ("testIndexPath", testIndexPath),
           ("testStructuredDataInitializable", testStructuredDataInitializable),
           ("testStructuredDataRepresentable", testStructuredDataRepresentable),
        ]
    }
}
