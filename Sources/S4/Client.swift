public protocol Client: Responder {
    init(uri: URI) throws
}
