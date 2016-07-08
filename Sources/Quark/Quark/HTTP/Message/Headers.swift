extension Headers : CustomStringConvertible {
    public var description: String {
        var string = ""

        for (header, value) in headers {
            string += "\(header): \(value)\n"
        }

        return string
    }
}
