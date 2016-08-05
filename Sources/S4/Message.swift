public protocol Message: CustomDataStore {
    var version: Version { get set }
    var headers: Headers { get set }
    var body: Body { get set }
}
