import PackageDescription

let package = Package(
    name: "Flux",
    targets: [
        Target(name: "POSIX"),
        Target(name: "Flux", dependencies: ["POSIX"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/VeniceX/CLibvenice.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/Zewo/COpenSSL", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/Zewo/CEnvironment.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/Zewo/CURIParser.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/Zewo/CHTTPParser.git", majorVersion: 0, minor: 6),
    ]
)
