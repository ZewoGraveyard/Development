public protocol AsyncClient: AsyncResponder {
    init(uri: URI) throws
}
