enum PresenterError : ErrorProtocol {
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
