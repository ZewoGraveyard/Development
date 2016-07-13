@_exported import C7
@_exported import S4

public enum QuarkError : ErrorProtocol {
    case invalidArgument(description: String)
}

extension QuarkError : CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidArgument(let description):
            return description
        }
    }
}

public struct Quark {
    public static func run(_ configure: (ServerParameters) throws -> ResponderRepresentable) {
        do {
            let parameters = try parse(arguments: Process.arguments)
            let responder = try configure(ServerParameters())

            var middleware: [Middleware] = []

            if parameters["log"] == "true" {
                middleware.append(LogMiddleware())
            }

            if let workingDirectory = parameters["working-dir"] {
                try File.changeWorkingDirectory(path: workingDirectory)
            }

            middleware.append(SessionMiddleware())
            middleware.append(ContentNegotiationMiddleware(mediaTypes: [JSON.self, URLEncodedForm.self]))

            try Server(middleware: middleware, responder: responder).start()
        } catch {
            print(error)
        }
    }

    private static func parse(arguments: [String]) throws -> [String: String] {
        let arguments = arguments.suffix(from: 1)
        var parameters: [String: String] = [:]

        var currentParameter = ""
        var shouldParseParameter = true

        for argument in arguments {
            if shouldParseParameter {
                if argument.starts(with: "--") {
                    currentParameter = String(Array(argument.characters).suffix(from: 2))
                } else {
                    throw QuarkError.invalidArgument(description: "\(argument) is a malformed parameter. Parameters should be provided in the format --parameter value.")
                }
                shouldParseParameter = false
            } else { // parse value
                if argument.starts(with: "--") {
                    throw QuarkError.invalidArgument(description: "\(currentParameter) is missing the value. Parameters should be provided in the format --parameter value.")
                }
                parameters[currentParameter] = argument
                shouldParseParameter = true
            }
        }

        if !shouldParseParameter {
            throw QuarkError.invalidArgument(description: "\(currentParameter) is missing the value. Parameters should be provided in the format --parameter value.")
        }

        return parameters
    }
}

public protocol ParameterRepresentable {
    var parameters: [String: String] { get }
}

public struct ServerParameters : ParameterRepresentable {
    public let parameters: [String: String]

    init() {
        self.parameters = [:]
    }

    func host() throws -> String {
        return ""
    }

    func port() throws -> Int {
        return 0
    }
}

public protocol DatabaseParameters : ParameterRepresentable {
    func databaseURI() throws -> String
}

public enum DatabaseParametersError : ErrorProtocol {
    case databaseURIRequired
}

extension DatabaseParameters {
    public func databaseURI() throws -> String {
        guard let uri = parameters["database-uri"] else {
            throw DatabaseParametersError.databaseURIRequired
        }
        return uri
    }
}
