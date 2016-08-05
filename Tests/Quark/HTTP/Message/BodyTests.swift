import XCTest
@testable import Quark

class BodyTests : XCTestCase {
    let data: C7.Data = [0x00, 0x01, 0x02, 0x03]

    func checkBodyProperties(_ body: Body) {
        var bodyForBuffer = body
        var bodyForReader = body
        var bodyForWriter = body

        XCTAssert(data == (try! bodyForBuffer.becomeBuffer()), "Garbled buffer bytes")
        switch bodyForBuffer {
        case .buffer(let d):
            XCTAssert(data == d, "Garbled buffer bytes")
        default:
            XCTFail("Incorrect type")
        }

        bodyForReader.forceReopenDrain()
        let readerDrain = Drain(stream: try! bodyForReader.becomeReader())
        XCTAssert(data == readerDrain.data, "Garbled reader bytes")
        switch bodyForReader {
        case .reader(let reader):
            bodyForReader.forceReopenDrain()
            let readerDrain = Drain(stream: reader)
            XCTAssert(data == readerDrain.data, "Garbed reader bytes")
        default:
            XCTFail("Incorrect type")
        }


        let writerDrain = Drain()
        bodyForReader.forceReopenDrain()
        do {
            try bodyForWriter.becomeWriter()(writerDrain)

        } catch {
            XCTFail("Drain threw error \(error)")
        }
        XCTAssert(data == writerDrain.data, "Garbled writer bytes")

        switch bodyForWriter {
        case .writer(let closure):
            let writerDrain = Drain()
            bodyForReader.forceReopenDrain()
            do {
                try closure(writerDrain)
            } catch {
                XCTFail("Drain threw error \(error)")
            }
            XCTAssert(data == writerDrain.data, "Garbed writer bytes")
        default:
            XCTFail("Incorrect type")
        }
    }

    func testWriter() {
        let writer = Body.writer { stream in
            try stream.write(self.data)
        }
        checkBodyProperties(writer)
    }

    func testReader() {
        let drain = Drain(buffer: data)
        let reader = Body.reader(drain)
        checkBodyProperties(reader)
    }

    func testBuffer() {
        let buffer = Body.buffer(data)
        checkBodyProperties(buffer)
    }

    func testBodyEquality() {
        let buffer = Body.buffer(data)

        let drain = Drain(buffer: data)
        let reader = Body.reader(drain)

        let writer = Body.writer { stream in
            try stream.write(self.data)
        }

        XCTAssertEqual(buffer, buffer)
        XCTAssertNotEqual(buffer, reader)
        XCTAssertNotEqual(buffer, writer)
        XCTAssertNotEqual(reader, writer)
    }

    func testBecomeFailure() {
        var body = Body.asyncReader(AsyncDrain())
        XCTAssertThrowsError(try body.becomeBuffer())
        XCTAssertThrowsError(try body.becomeReader())
        XCTAssertThrowsError(try body.becomeWriter())
    }
}

extension Body {
    mutating func forceReopenDrain() {
        if let drain = (try! self.becomeReader()) as? Drain {
            drain.closed = false
        }
    }
}

extension BodyTests {
    static var allTests : [(String, (BodyTests) -> () throws -> Void)] {
        return [
            ("testWriter", testWriter),
            ("testReader", testReader),
            ("testBuffer", testBuffer),
            ("testBodyEquality", testBodyEquality),
            ("testBecomeFailure", testBecomeFailure),
        ]
    }
}
