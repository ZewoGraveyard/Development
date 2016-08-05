@_exported import C7
@_exported import S4

public enum QuarkError : ErrorProtocol {
    case invalidConfiguration(description: String)
    case invalidArgument(description: String)
}

extension QuarkError : CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidConfiguration(let description):
            return description
        case .invalidArgument(let description):
            return description
        }
    }
}

public var configuration: StructuredData = nil {
    willSet(configuration) {
        do {
            let file = try File(path: "/tmp/QuarkConfiguration", mode: .truncateWrite)
            let serializer = JSONStructuredDataSerializer()
            let data = try serializer.serialize(configuration)
            try file.write(data)
        } catch {
            fatalError(String(error))
        }
    }
}

public typealias Configuration = StructuredDataInitializable

public protocol ConfigurableServer {
    init(middleware: [Middleware], responder: Responder, configuration: StructuredData) throws
    func start() throws
}

public func configure<AppConfiguration : Configuration>(configurationFile: String = "Configuration.swift", server: ConfigurableServer.Type, configure: (AppConfiguration) throws -> ResponderRepresentable) {
    do {
        let configuration = try loadConfiguration(configurationFilePath: configurationFile)
        let responder = try configure(AppConfiguration(structuredData: configuration))
        try configureServer(server, responder: responder.responder, configuration: configuration)
    } catch {
        print(error)
    }
}

private func configureServer(_ server: ConfigurableServer.Type, responder: Responder, configuration: StructuredData) throws {
    var middleware: [Middleware] = []

    if configuration["server", "log"]?.asBool == true {
        middleware.append(LogMiddleware())
    }

    middleware.append(SessionMiddleware())
    middleware.append(ContentNegotiationMiddleware(mediaTypes: [JSON.self, URLEncodedForm.self]))

    try server.init(
        middleware: middleware,
        responder: responder,
        configuration: configuration
    ).start()
}

private var arguments: [String] {
    return Process.argc > 0 ? Array(Process.arguments.suffix(from: 1)) : []
}

private func loadConfiguration(configurationFilePath: String) throws -> StructuredData {
    let environmentVariables = try load(environmentVariables: environment.variables)
    let commandLineArguments = try load(commandLineArguments: arguments)

    if let workingDirectory = commandLineArguments["workingDirectory"]?.asString ?? environmentVariables["workingDirectory"]?.asString {
        try File.changeWorkingDirectory(path: workingDirectory)
    }

    let configurationFile = try load(configurationFile: configurationFilePath)
    var configuration: StructuredData = [:]

    for (key, value) in configurationFile {
        try configuration.set(value: value, at: key)
    }

    for (key, value) in environmentVariables {
        try configuration.set(value: value, at: key)
    }

    for (key, value) in commandLineArguments {
        try configuration.set(value: value, at: key)
    }

    return configuration
}

private func load(configurationFile: String) throws -> [String: StructuredData] {
    let libraryDirectory = ".build/" + buildConfiguration.buildPath
    let moduleName = "Quark"
    var arguments = ["swiftc"]
    arguments += ["--driver-mode=swift"]
    arguments += ["-I", libraryDirectory, "-L", libraryDirectory, "-l\(moduleName)"]

#if os(OSX)
    arguments += ["-target", "x86_64-apple-macosx10.10"]
#endif

    arguments += [configurationFile]

#if Xcode
    // Xcode's PATH doesn't include swiftenv shims. Let's include it mannualy.
    environment["PATH"] = (environment["HOME"] ?? "") + "/.swiftenv/shims:" + (environment["PATH"] ?? "")
#endif

    try sys(arguments)

    let file = try File(path: "/tmp/QuarkConfiguration")
    let parser = JSONStructuredDataParser()
    let data = try file.readAll()
    return try parser.parse(data).asDictionary()
}

func load(commandLineArguments: [String]) throws -> [String: StructuredData] {
    var parameters: StructuredData = [:]

    var currentParameter = ""
    var shouldParseParameter = true

    for argument in commandLineArguments {
        if shouldParseParameter {
            if argument.has(prefix: "--") {
                currentParameter = String(Array(argument.characters).suffix(from: 2))
                shouldParseParameter = false
                continue
            } else if argument.has(prefix: "-") {
                let flag = String(Array(argument.characters).suffix(from: 1))
                let indexPath = flag.indexPath()
                try parameters.set(value: true, at: indexPath)
                continue
            }
            throw QuarkError.invalidArgument(description: "\(argument) is a malformed parameter. Parameters should be provided in the format --parameter value.")
        } else { // parse value
            if argument.has(prefix: "-") {
                throw QuarkError.invalidArgument(description: "\(currentParameter) is missing the value. Parameters should be provided in the format --parameter value.")
            }
            let value = parse(value: argument)
            let indexPath = currentParameter.indexPath()
            try parameters.set(value: value, at: indexPath)
            shouldParseParameter = true
        }
    }

    if !shouldParseParameter {
        throw QuarkError.invalidArgument(description: "\(currentParameter) is missing the value. Parameters should be provided in the format --parameter value.")
    }

    return parameters.asDictionary!
}

func load(environmentVariables: [String: String]) throws -> [String: StructuredData] {
    var variables: [String: StructuredData] = [:]

    for (key, value) in environmentVariables {
        let key = convertEnvironmentVariableKeyToCamelCase(key)
        variables[key] = parse(value: value)
    }

    return variables
}

func parse(value: String) -> StructuredData {
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

    private static func currentConfiguration(suppressingWarning: Bool) -> BuildConfiguration {
        if suppressingWarning && _isDebugAssertConfiguration() {
            return .debug
        }
        if suppressingWarning && _isFastAssertConfiguration() {
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

// TODO: refactor this

public enum SpawnError : ErrorProtocol {
    case exitStatus(Int32, [String])
}

extension SpawnError : CustomStringConvertible {
    public var description: String {
        switch self {
        case .exitStatus(let code, let args):
            return "exit(\(code)): \(args)"
        }
    }
}

public func sys(_ arguments: [String]) throws {
    fflush(stdout)
    guard !arguments.isEmpty else {
        throw SystemError.invalidArgument
    }
    
    let pid = try spawn(arguments: arguments)
    let exitStatus = try wait(pid: pid)

    guard exitStatus == 0 else {
        throw SpawnError.exitStatus(exitStatus, arguments)
    }
}

func spawn(arguments: [String]) throws -> pid_t {
    let argv: [UnsafeMutablePointer<CChar>?] = arguments.map {
        $0.withCString(strdup)
    }

    defer {
        for case let a? in argv {
            free(a)
        }
    }

    var envs: [String: String] = [:]

#if Xcode
    let keys = ["SWIFT_EXEC", "HOME", "PATH", "TOOLCHAINS", "DEVELOPER_DIR", "LLVM_PROFILE_FILE"]
#else
    let keys = ["SWIFT_EXEC", "HOME", "PATH", "SDKROOT", "TOOLCHAINS", "DEVELOPER_DIR", "LLVM_PROFILE_FILE"]
#endif

    for key in keys {
        if envs[key] == nil {
            envs[key] = environment[key]
        }
    }

    let env: [UnsafeMutablePointer<CChar>?] = envs.map {
        "\($0.0)=\($0.1)".withCString(strdup)
    }

    defer {
        for case let e? in env {
            free(e)
        }
    }

    var pid = pid_t()
    let rv = posix_spawnp(&pid, argv[0], nil, nil, argv + [nil], env + [nil])

    if rv != 0 {
        try ensureLastOperationSucceeded()
    }

    return pid
}

func wait(pid: pid_t) throws -> Int32 {
    while true {
        var exitStatus: Int32 = 0
        let rv = waitpid(pid, &exitStatus, 0)

        if rv != -1 {
            if exitStatus & 0x7f == 0 {
                return (exitStatus >> 8) & 0xff
            } else {
                try ensureLastOperationSucceeded()
            }
        } else if errno == EINTR {
            continue
        } else {
            try ensureLastOperationSucceeded()
        }
    }
}
