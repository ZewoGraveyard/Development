import PackageDescription

let package = Package(
    name: "Quark",
    targets: [
        Target(
            name: "Quark"
        ),
        Target(
            name: "TestApplication",
            dependencies: ["Quark"]
        ),
    ],
    dependencies: [
        .Package(url: "https://github.com/open-swift/S4.git", majorVersion: 0, minor: 10),
        .Package(url: "https://github.com/VeniceX/CLibvenice.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/CURIParser.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/Zewo/CHTTPParser.git", majorVersion: 0, minor: 5),
    ]
)
