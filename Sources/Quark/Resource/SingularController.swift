public protocol SingularController {
    associatedtype CreateInput: StructuredDataInitializable
    associatedtype UpdateInput: StructuredDataInitializable

    associatedtype CreateOutput: StructuredDataFallibleRepresentable
    associatedtype DetailOutput: StructuredDataFallibleRepresentable
    associatedtype UpdateOutput: StructuredDataFallibleRepresentable

    func create(element: CreateInput) throws -> CreateOutput
    func detail() throws -> DetailOutput
    func update(element: UpdateInput) throws -> UpdateOutput
    func destroy() throws
}

extension SingularController {
    public func create(element: CreateInput) throws -> CreateOutput {
        throw ClientError.notFound
    }

    public func detail() throws -> DetailOutput {
        throw ClientError.notFound
    }

    public func update(element: UpdateInput) throws -> UpdateOutput {
        throw ClientError.notFound
    }

    public func destroy() throws {
        throw ClientError.notFound
    }
}
