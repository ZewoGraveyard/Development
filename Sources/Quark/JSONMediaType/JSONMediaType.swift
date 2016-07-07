extension JSON : MediaTypeRepresentor {
    public static var mediaType: MediaType {
        return MediaType(
            type: "application",
            subtype: "json",
            parameters: ["charset": "utf-8"]
        )
    }

    public static var parser: StructuredDataParser {
        return JSONStructuredDataParser()
    }

    public static var serializer: StructuredDataSerializer {
        return JSONStructuredDataSerializer()
    }
}
