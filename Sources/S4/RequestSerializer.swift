public protocol RequestSerializer {
    init(stream: Stream)
    func serialize(_ request: Request) throws
}
