extension URLEncodedForm : MediaTypeRepresentor {
    public static var mediaType: MediaType {
        return MediaType(
            type: "application",
            subtype: "x-www-form-urlencoded",
            parameters: ["charset": "utf-8"]
        )
    }

    public static var parser: StructuredDataParser {
        return URLEncodedFormStructuredDataParser()
    }

    public static var serializer: StructuredDataSerializer {
        return URLEncodedFormStructuredDataSerializer()
    }
}
