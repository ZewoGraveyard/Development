// IP.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CLibvenice
@_exported import Venice
@_exported import POSIX

public enum IPError: ErrorProtocol {
    case invalidPort
}

extension IPError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidPort: return "Port number should be between 0 and 0xffff"
        }
    }
}

public enum IPMode {
    case ipV4
    case ipV6
    case ipV4Prefered
    case ipV6Prefered

    var code: Int32 {
        switch self {
        case .ipV4: return 1
        case .ipV6: return 2
        case .ipV4Prefered: return 3
        case .ipV6Prefered: return 4
        }
    }
}

public struct IP {
    public let address: ipaddr

    public init(address: ipaddr) {
        self.address = address
    }

    public init(port: Int = 0, mode: IPMode = .ipV4Prefered) throws {
        try IP.assertValid(port)
        let address = iplocal(nil, Int32(port), mode.code)
        try ensureLastOperationSucceeded()
        self.init(address: address)
    }

    public init(localAddress: String, port: Int = 0, mode: IPMode = .ipV4Prefered) throws {
        try IP.assertValid(port)
        let address = iplocal(localAddress, Int32(port), mode.code)
        try ensureLastOperationSucceeded()
        self.init(address: address)
    }

    public init(remoteAddress: String, port: Int, mode: IPMode = .ipV4Prefered, deadline: Double = .never) throws {
        try IP.assertValid(port)
        let address = ipremote(remoteAddress, Int32(port), mode.code, deadline.int64milliseconds)
        try ensureLastOperationSucceeded()
        self.init(address: address)
    }

    private static func assertValid(_ port: Int) throws {
        if port < 0 || port > 0xffff {
            throw IPError.invalidPort
        }
    }
}

extension IP: CustomStringConvertible {
    public var description: String {
        var buffer = [Int8](repeating: 0, count: 46)
        ipaddrstr(address, &buffer)
        return String(cString: buffer)
    }
}