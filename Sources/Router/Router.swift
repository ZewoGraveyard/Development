// Router.swift
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

@_exported import TrieRouteMatcher
@_exported import RegexRouteMatcher

public protocol Router: RouterRepresentable {
    var path: String { get }
    var middleware: [Middleware] { get }
    var matcher: RouteMatcher.Type { get }
    func build(router: RouterBuilder)
}

extension Router {
    public var path: String {
        return ""
    }

    public var middleware: [Middleware] {
        return []
    }

    public var matcher: RouteMatcher.Type {
        return TrieRouteMatcher.self
    }

    public func build(router: RouterBuilder) {}
}

extension Router {
    public var router: RouterProtocol {
        let router = RouterBuilder(path: path)
        build(router: router)
        return BasicRouter(
            middleware: middleware,
            matcher: matcher,
            router: router
        )
    }
}
