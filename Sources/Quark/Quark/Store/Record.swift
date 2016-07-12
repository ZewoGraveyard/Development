public struct Record<Model> {
    public let id: String
    public let model: Model

    public init(id: String, model: Model) {
        self.id = id
        self.model = model
    }
}
