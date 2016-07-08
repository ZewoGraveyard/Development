public protocol Controller {
    associatedtype DetailID: PathParameterInitializable = UpdateID
    associatedtype UpdateID: PathParameterInitializable
    associatedtype DestroyID: PathParameterInitializable = UpdateID

    associatedtype CreateInput: StructuredDataInitializable = UpdateInput
    associatedtype UpdateInput: StructuredDataInitializable

    associatedtype ListOutput: StructuredDataFallibleRepresentable = UpdateOutput
    associatedtype CreateOutput: StructuredDataFallibleRepresentable = UpdateOutput
    associatedtype DetailOutput: StructuredDataFallibleRepresentable = UpdateOutput
    associatedtype UpdateOutput: StructuredDataFallibleRepresentable

    func list() throws -> ListOutput
    func create(element: CreateInput) throws -> CreateOutput
    func detail(id: DetailID) throws -> DetailOutput
    func update(id: UpdateID, element: UpdateInput) throws -> UpdateOutput
    func destroy(id: DestroyID) throws
}

extension Controller {
    public func list() throws -> ListOutput {
        throw ClientError.notFound
    }

    public func create(element: CreateInput) throws -> CreateOutput {
        throw ClientError.notFound
    }

    public func detail(id: DetailID) throws -> DetailOutput {
        throw ClientError.notFound
    }

    public func update(id: UpdateID, element: UpdateInput) throws -> UpdateOutput {
        throw ClientError.notFound
    }

    public func destroy(id: DestroyID) throws {
        throw ClientError.notFound
    }
}
