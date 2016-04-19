import PackageDescription

let package = Package(
    name: "Flux",
    dependencies: [
        .Package(url: "https://github.com/open-swift/C7.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/open-swift/S4.git", majorVersion: 0, minor: 4),
        //.Package(url: "https://github.com/open-swift/D5.git", majorVersion: 0, minor: 0),

        .Package(url: "https://github.com/VeniceX/ChannelStream.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/CLibvenice.git",    majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/File.git",          majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/HTTPClient.git",    majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/HTTPFile.git",      majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/HTTPSClient.git",   majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/HTTPServer.git",    majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/HTTPSServer.git",   majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/IP.git",            majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/TCP.git",           majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/TCPSSL.git",        majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/UDP.git",           majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/VeniceX/Venice.git",        majorVersion: 0, minor: 5),

        .Package(url: "https://github.com/Zewo/Base64.git",                       majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/BasicAuthMiddleware.git",          majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/CHTTPParser.git",                  majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/CLibpq.git",                       majorVersion: 0, minor: 5),
        //.Package(url: "https://github.com/Zewo/CMySQL.git",                       majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/COpenSSL.git",                     majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/CURIParser.git",                   majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/CZeroMQ.git",                      majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/ContentNegotiationMiddleware.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Event.git",                        majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/HTTP.git",                         majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/HTTPJSON.git",                     majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/HTTPParser.git",                   majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/HTTPSerializer.git",               majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/JSON.git",                         majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/JSONMediaType.git",                majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Log.git",                          majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/LogMiddleware.git",                majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Mapper.git",                       majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/MediaType.git",                    majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/MessagePack.git",                  majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Mustache.git",                     majorVersion: 0, minor: 5),
        //.Package(url: "https://github.com/Zewo/MySQL.git",                        majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/OpenSSL.git",                      majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/POSIX.git",                        majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/POSIXRegex.git",                   majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/PathParameterMiddleware.git",      majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/PostgreSQL.git",                   majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/RecoveryMiddleware.git",           majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/RegexRouteMatcher.git",            majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Resource.git",                     majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Router.git",                       majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/SQL.git",                          majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Sideburns.git",                    majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/String.git",                       majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/StructuredData.git",               majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/TrieRouteMatcher.git",             majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/URI.git",                          majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/URLEncodedForm.git",               majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/URLEncodedFormMediaType.git",      majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/WebSocket.git",                    majorVersion: 0, minor: 5),
        //.Package(url: "https://github.com/Zewo/XML.git",                          majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/ZeroMQ.git",                       majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/Zewo.git",                         majorVersion: 0, minor: 5),
    ]
)
