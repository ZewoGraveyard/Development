public enum QuarkError : Error {
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

public func Configuration(file: String = "Release.swift") throws -> Map {
    return try loadConfiguration(configurationFile: "Configuration/" + file)
}

func loadConfiguration(configurationFile: String, arguments: [String] = CommandLine.arguments) throws -> Map {
    let environmentVariables = load(environmentVariables: environment.variables)
    let commandLineArguments = try load(arguments: Array(arguments.dropFirst()))

    if let workingDirectory = commandLineArguments["workingDirectory"]?.string ?? environmentVariables["workingDirectory"]?.string {
        try File.changeWorkingDirectory(path: workingDirectory)
    }

    let configurationFile = try load(configurationFile: configurationFile)
    var configuration: Map = [:]

    for (key, value) in configurationFile {
        try configuration.set(value, for: key)
    }

    for (key, value) in environmentVariables {
        try configuration.set(value, for: key)
    }

    for (key, value) in commandLineArguments {
        try configuration.set(value, for: key)
    }

    return configuration
}

private func load(configurationFile: String) throws -> [String: Map] {
    let libraryDirectory = ".build/" + buildConfiguration.buildPath
    let moduleName = "QuarkConfiguration"

    var arguments = ["swiftc"]
    arguments += ["--driver-mode=swift"]
    arguments += ["-I", libraryDirectory]
    arguments += ["-L", libraryDirectory]
    arguments += ["-l\(moduleName)"]

#if os(macOS)
    arguments += ["-target", "x86_64-apple-macosx10.10"]
#endif

    arguments += [configurationFile]

#if Xcode
    // Xcode's PATH doesn't include swiftenv shims. Let's include it mannualy.
    let home = environment["HOME"] ?? ""
    let path = environment["PATH"] ?? ""
    environment["PATH"] = home + "/.swiftenv/shims:" +
        "/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:" + path
#endif

    try sys(arguments)

    let file = try File(path: "/tmp/QuarkConfiguration")
    let parser = JSONMapParser()
    let data = try file.readAll()
    return try parser.parse(data).asDictionary()
}

func load(arguments: [String]) throws -> [String: Map] {
    var parameters: Map = [:]

    var currentParameter = ""
    var hasParameter = false
    var value: Map = nil
    var i = 0

    while i < arguments.count {
        if arguments[i].has(prefix: "-") {
            if !hasParameter {
                currentParameter = String(Array(arguments[i].characters).suffix(from: 1))
                hasParameter = true
                i += 1
                continue
            } else {
                value = true
                let indexPath = currentParameter.indexPath()
                try parameters.set(value, for: indexPath)
                hasParameter = false
                continue
            }
        }
        if hasParameter {
            let value = parse(value: arguments[i])
            let indexPath = currentParameter.indexPath()
            try parameters.set(value, for: indexPath)
            hasParameter = false
            i += 1
        } else {
            throw QuarkError.invalidArgument(description: "\(arguments[i]) is a malformed parameter. Parameters should be provided in the format -parameter [value].")
        }
    }

    if hasParameter {
        let indexPath = currentParameter.indexPath()
        try parameters.set(true, for: indexPath)
    }

    return parameters.dictionary!
}

func load(environmentVariables: [String: String]) -> [String: Map] {
    var variables: [String: Map] = [:]

    for (key, value) in environmentVariables {
        let key = convertEnvironmentVariableKeyToCamelCase(key)
        variables[key] = parse(value: value)
    }

    return variables
}

func parse(value: String) -> Map {
    if isNull(value) {
        return .null
    }

    if let intValue = Int(value) {
        return .int(intValue)
    }

    if let doubleValue = Double(value) {
        return .double(doubleValue)
    }

    if let boolValue = convertToBool(value) {
        return .bool(boolValue)
    }

    return .string(value)
}

func isNull(_ string: String) -> Bool {
    switch string {
    case "NULL", "Null", "null", "NIL", "Nil", "nil":
        return true
    default:
        return false
    }
}

func convertToBool(_ string: String) -> Bool? {
    switch string {
    case "TRUE", "True", "true", "YES", "Yes", "yes":
        return true
    case "FALSE", "False", "false", "NO", "No", "no":
        return false
    default:
        return nil
    }
}

func convertEnvironmentVariableKeyToCamelCase(_ variableKey: String) -> String {
    if variableKey == "_" {
        return variableKey
    }

    var key = ""
    let words = variableKey.split(separator: "_", omittingEmptySubsequences: false)

    key += words.first!.lowercased()

    for word in words.suffix(from: 1) {
        key += word.capitalizedWord()
    }

    return key
}

public enum BuildConfiguration {
    case debug
    case release
    case fast

    fileprivate static func currentConfiguration(suppressingWarning: Bool) -> BuildConfiguration {
        if _isDebugAssertConfiguration() && suppressingWarning {
            return .debug
        }
        if _isFastAssertConfiguration() && suppressingWarning {
            return .fast
        }
        return .release
    }
}

extension BuildConfiguration {
    var buildPath: String {
        switch self {
        case .debug: return "debug"
        case .release: return "release"
        case .fast: return "release"
        }
    }
}

public var buildConfiguration: BuildConfiguration {
    return BuildConfiguration.currentConfiguration(suppressingWarning: true)
}
