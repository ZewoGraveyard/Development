public protocol Controller {
    associatedtype ID : PathParameterInitializable = String
    associatedtype Model : StructuredDataInitializable, StructuredDataFallibleRepresentable = StructuredData

    associatedtype DetailID : PathParameterInitializable = ID
    associatedtype UpdateID : PathParameterInitializable = ID
    associatedtype DestroyID : PathParameterInitializable = ID

    associatedtype CreateInput : StructuredDataInitializable = Model
    associatedtype UpdateInput : StructuredDataInitializable = Model

    associatedtype ListOutput : StructuredDataFallibleRepresentable = Model
    associatedtype CreateOutput : StructuredDataFallibleRepresentable = Model
    associatedtype DetailOutput : StructuredDataFallibleRepresentable = Model
    associatedtype UpdateOutput : StructuredDataFallibleRepresentable = Model
    associatedtype DestroyOutput : StructuredDataFallibleRepresentable = Model

    func list() throws -> [ListOutput]
    func create(_ input: CreateInput) throws -> CreateOutput
    func detail(id: DetailID) throws -> DetailOutput
    func update(id: UpdateID, _ input: UpdateInput) throws -> UpdateOutput
    func destroy(id: DestroyID) throws -> DestroyOutput
}

public extension Controller {
    func list() throws -> [ListOutput] {
        throw ClientError.notFound
    }

    func create(_: CreateInput) throws -> CreateOutput {
        throw ClientError.notFound
    }

    func detail(id: DetailID) throws -> DetailOutput {
        throw ClientError.notFound
    }

    func update(id: UpdateID, _: UpdateInput) throws -> UpdateOutput {
        throw ClientError.notFound
    }

    func destroy(id: DestroyID) throws -> DestroyOutput {
        throw ClientError.notFound
    }
}
