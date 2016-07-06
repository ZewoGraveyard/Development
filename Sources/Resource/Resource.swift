// Resource.swift
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

public protocol Resource: RouterRepresentable {
    associatedtype ControllerType: Controller
    var controller: ControllerType { get }
    var path: String { get }
    var viewsPath: String { get }
    var matcher: RouteMatcher.Type { get }
    var middleware: [Middleware] { get }
    var mediaTypes: [MediaTypeRepresentor.Type] { get }
    func recover(error: ErrorProtocol) throws -> Response
    func build(resource: ResourceBuilder)

    associatedtype ListOutput: StructuredDataFallibleRepresentable = ControllerType.ListOutput

    func renderList(input: ControllerType.ListOutput) throws -> ListOutput
}

extension Resource {
    public var path: String {
        return ""
    }

    public var viewsPath: String {
        let typeName = String(self.dynamicType)
        return String(typeName.characters.dropLast(8))
    }

    public var matcher: RouteMatcher.Type {
        return TrieRouteMatcher.self
    }

    public var middleware: [Middleware] {
        return []
    }

    public var mediaTypes: [MediaTypeRepresentor.Type] {
        return []
    }

    public func recover(error: ErrorProtocol) throws -> Response {
        throw error
    }

    public func build(resource: ResourceBuilder) {}

    public func renderList(input: ControllerType.ListOutput) throws -> ListOutput {
        throw PresenterError.bypass
    }
}

extension Resource {
    public var router: RouterProtocol {
        let resource = ResourceBuilder(path: path, viewsPath: viewsPath)
        build(resource: resource)
        resource.list(action: controller.list, render: renderList)
        resource.create(action: controller.create)
        resource.detail(action: controller.detail)
        resource.update(action: controller.update)
        resource.destroy(action: controller.destroy)
        return BasicResource(
            matcher: matcher,
            middleware: middleware,
            mediaTypes: mediaTypes,
            recover: recover,
            resource: resource
        )
    }
}
