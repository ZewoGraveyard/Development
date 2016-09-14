import XCTest
@testable import Venice
@testable import UDP

public class UDPSocketTests: XCTestCase {

    func testBasicSendReceive() {
        let udpSocket = try? UDPSocket(ip: IP(port: 5050))
        do {
            try udpSocket?.send(Data("Hello world"), ip: IP(port: 5051))
        }
        catch {
            XCTFail("failed to send data to the server")
        }
        XCTAssert(1 == 1, "Something is severely wrong here.")
    }

    func testBasicEcho() {

        guard let serverSocket = try? UDPSocket(ip: IP(port: 5050)) else {
            XCTFail("could not start listening socket")
            return
        }
        guard let clientSocket = try? UDPSocket(ip: IP(port: 5051)) else {
            XCTFail("could not start client socket")
            return
        }

        let originalMessage = "Hello, World!"
        let comparisonChannel = Channel<Bool>()

        // Coroutine waiting for input message
        co {
            guard let (data, _) = try? serverSocket.receive(upTo: 1024) else {
                comparisonChannel.send(false)
                return
            }
            // compare the received message and send back the comparison value
            guard let message = String(data: data, encoding: String.Encoding.utf8) else {
                comparisonChannel.send(false)
                return
            }
            comparisonChannel.send(message == originalMessage)
        }

        // Send data to the server
        do {
            try clientSocket.send(Data(originalMessage), ip: IP(port: 5050))
        }
        catch {
            XCTFail("failed to send data to the server")
            return
        }
        // Data was sent to the server

        let success = comparisonChannel.receive()!
        // Received the comparison result
        XCTAssert(success, "Sent and received messages are not equal")
    }

}

extension UDPSocketTests {
    public static var allTests : [(String, (UDPSocketTests) -> () throws -> Void)] {
        return [
           ("testBasicSendReceive", testBasicSendReceive),
           ("testBasicEcho", testBasicEcho),
        ]
    }
}
