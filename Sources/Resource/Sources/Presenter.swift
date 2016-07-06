// Presenter.swift
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

enum PresenterError: ErrorProtocol {
    case bypass
}

public protocol Presenter {
    var viewsPath: String { get }

    associatedtype ListInput: StructuredDataInitializable = StructuredData
    associatedtype CreateInput: StructuredDataInitializable = StructuredData
    associatedtype DetailIntput: StructuredDataInitializable = StructuredData
    associatedtype UpdateInput: StructuredDataInitializable = StructuredData

    associatedtype ListOutput: StructuredDataFallibleRepresentable = StructuredData
    associatedtype CreateOutput: StructuredDataFallibleRepresentable = StructuredData
    associatedtype DetailOutput: StructuredDataFallibleRepresentable = StructuredData
    associatedtype UpdateOutput: StructuredDataFallibleRepresentable = StructuredData

    func list(input: ListInput) throws -> ListOutput
    func create(input: CreateInput) throws -> CreateOutput
    func detail(input: DetailIntput) throws -> DetailOutput
    func update(input: UpdateInput) throws -> UpdateOutput
}

extension Presenter {
    public var viewsPath: String {
        let typeName = String(self.dynamicType)
        return String(typeName.characters.dropLast(9))
    }

    public func list(input: ListInput) throws -> ListOutput {
        throw PresenterError.bypass
    }

    public func create(input: CreateInput) throws -> CreateOutput {
        throw PresenterError.bypass
    }

    public func detail(input: DetailIntput) throws -> DetailOutput {
        throw PresenterError.bypass
    }

    public func update(input: UpdateInput) throws -> UpdateOutput {
        throw PresenterError.bypass
    }
}
