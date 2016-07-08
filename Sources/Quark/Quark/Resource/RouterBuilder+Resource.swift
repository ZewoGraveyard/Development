extension RouterBuilder {
    public func compose(_ path: String = "", middleware: Middleware..., resource representable: RouterRepresentable) {
        compose(path, router: representable)
    }
}
