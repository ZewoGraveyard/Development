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

public typealias Configuration = StructuredDataInitializable

public var configuration: StructuredData = nil {
    willSet(configuration) {
        do {
            let file = try File(path: "/tmp/QuarkConfiguration", mode: .truncateWrite)
            let serializer = JSONStructuredDataSerializer()
            let data = try serializer.serialize(configuration)
            try file.write(data)
        } catch {
            fatalError("\(error)")
        }
    }
}

public func configure<C : Configuration>(_ configure: (C) throws -> ResponderRepresentable) {
    do {
        let configuration = try loadConfiguration()
        let responder = try configure(C(structuredData: configuration))

        var middleware: [Middleware] = []

        if configuration["server.log"]?.boolValue == true {
            middleware.append(LogMiddleware())
        }

        middleware.append(SessionMiddleware())
        middleware.append(ContentNegotiationMiddleware(mediaTypes: [JSON.self, URLEncodedForm.self]))

        let host = configuration["server.host"]?.stringValue ?? "127.0.0.1"
        let port = configuration["server.port"]?.intValue ?? 8080
        let reusePort = configuration["server.reusePort"]?.boolValue ?? false

        try Server(
            host: host,
            port: port,
            reusePort: reusePort,
            middleware: middleware,
            responder: responder
        ).start()
    } catch {
        print(error)
    }
}

private func loadConfiguration() throws -> StructuredData {
    var configuration: StructuredData = [:]

    guard case .dictionary(let environmentVariables) = try loadEnvironmentVariables() else {
        throw QuarkError.invalidConfiguration(description: "Configuration from environment variables is not in dictionary format.")
    }

    guard case .dictionary(let commandLineArguments) = try loadCommandLineArguments() else {
        throw QuarkError.invalidConfiguration(description: "Configuration from command line arguments is not in dictionary format.")
    }

    if let workingDirectory = commandLineArguments["workingDirectory"]?.stringValue {
        try File.changeWorkingDirectory(path: workingDirectory)
    }

    guard case .dictionary(let configurationFile) = try loadConfigurationFile() else {
        throw QuarkError.invalidConfiguration(description: "Configuration from file is not in dictionary format.")
    }

    for (key, value) in configurationFile {
        configuration[key] = value
    }

    for (key, value) in commandLineArguments {
        configuration[key] = value
    }

    for (key, value) in environmentVariables {
        configuration[key] = value
    }

    return configuration
}

private func loadConfigurationFile() throws -> StructuredData {
    let libraryDirectory = ".build/debug"
    let moduleName = "Quark"
    var arguments = ["swiftc"]
    arguments += ["--driver-mode=swift"]
    arguments += ["-I", libraryDirectory, "-L", libraryDirectory, "-l\(moduleName)"]

    #if os(OSX)
        arguments += ["-target", "x86_64-apple-macosx10.10"]
    #endif

    arguments += ["Configuration.swift"]

    // Xcode's PATH doesn't include swiftenv shims.
    if let xpc = environment["XPC_SERVICE_NAME"] where xpc.contains("com.apple.dt.Xcode") {
        environment["PATH"] = environment["HOME"]! + "/.swiftenv/shims:" + environment["PATH"]!
    }

    try system(arguments)

    let file = try File(path: "/tmp/QuarkConfiguration")
    let parser = JSONStructuredDataParser()
    let data = try file.readAllBytes()
    return try parser.parse(data)
}

private func loadCommandLineArguments() throws -> StructuredData {
    let arguments = Process.arguments.suffix(from: 1)
    var parameters: StructuredData = [:]

    var currentParameter = ""
    var shouldParseParameter = true

    for argument in arguments {
        if shouldParseParameter {
            if argument.starts(with: "--") {
                currentParameter = String(Array(argument.characters).suffix(from: 2))
            } else if argument.starts(with: "-") {
                let flag = String(Array(argument.characters).suffix(from: 1))
                parameters[flag] = true
                continue
            } else {
                throw QuarkError.invalidArgument(description: "\(argument) is a malformed parameter. Parameters should be provided in the format --parameter value.")
            }
            shouldParseParameter = false
        } else { // parse value
            if argument.starts(with: "--") {
                throw QuarkError.invalidArgument(description: "\(currentParameter) is missing the value. Parameters should be provided in the format --parameter value.")
            }
            parameters[currentParameter] = parse(value: argument)
            shouldParseParameter = true
        }
    }

    if !shouldParseParameter {
        throw QuarkError.invalidArgument(description: "\(currentParameter) is missing the value. Parameters should be provided in the format --parameter value.")
    }

    return parameters
}

private func loadEnvironmentVariables() throws -> StructuredData {
    var variables: StructuredData = [:]

    for (key, value) in environment.variables {
        let key = convertEnvironmentVariableKeyToCamelCase(key)
        variables[key] = parse(value: value)
    }

    return variables
}

private func parse(value: String) -> StructuredData {
    if isNull(string: value) {
        return .null
    }

    if let intValue = Int(value) {
        return .int(intValue)
    }

    if let doubleValue = Double(value) {
        return .double(doubleValue)
    }

    if let boolValue = convertToBool(string: value) {
        return .bool(boolValue)
    }

    return .string(value)
}

private func isNull(string: String) -> Bool {
    switch string {
    case "null", "NULL", "nil", "NIL":
        return true
    default:
        return false
    }
}

private func convertToBool(string: String) -> Bool? {
    switch string {
    case "True", "true", "yes", "1":
        return true
    case "False", "false", "no", "0":
        return false
    default:
        return nil
    }
}

private func convertEnvironmentVariableKeyToCamelCase(_ variableKey: String) -> String {
    var key = ""
    let words = variableKey.split(separator: "_", omittingEmptySubsequences: false)

    if words[0] == "" {
        key += "_"
    } else {
        key += words[0].lowercased()
    }

    for i in 1 ..< words.count {
        key += words[i].capitalized()
    }

    return key
}

// TODO: refactor this

public func getenvString(_ key: String) -> String? {
    let out = getenv(key)
    return out == nil ? nil : String(validatingUTF8: out!)  //FIXME locale may not be UTF8
}

public enum Error: ErrorProtocol {
    case exitStatus(Int32, [String])
    case exitSignal
}

extension Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .exitStatus(let code, let args):
            return "exit(\(code)): \(args)"

        case .exitSignal:
            return "Child process exited with signal"
        }
    }
}

public func system(_ arguments: [String], environment: [String:String] = [:]) throws {
    // make sure subprocess output doesn't get interleaved with our own
    fflush(stdout)

    do {
        let pid = try posix_spawnp(arguments[0], args: arguments, environment: environment)
        let exitStatus = try waitpid(pid)
        guard exitStatus == 0 else {
            throw Error.exitStatus(exitStatus, arguments)
        }
    } catch let underlyingError as SystemError {
        throw underlyingError
    }
}

@available(*, unavailable)
public func system() {}


#if os(OSX)
    typealias swiftpm_posix_spawn_file_actions_t = posix_spawn_file_actions_t?
#else
    typealias swiftpm_posix_spawn_file_actions_t = posix_spawn_file_actions_t
#endif

/// Convenience wrapper for posix_spawn.
func posix_spawnp(_ path: String, args: [String], environment: [String: String] = [:], fileActions: swiftpm_posix_spawn_file_actions_t? = nil) throws -> pid_t {
    let argv: [UnsafeMutablePointer<CChar>?] = args.map{ $0.withCString(strdup) }
    defer { for case let arg? in argv { free(arg) } }

    var environment = environment
#if Xcode
    let keys = ["SWIFT_EXEC", "HOME", "PATH", "TOOLCHAINS", "DEVELOPER_DIR", "LLVM_PROFILE_FILE"]
#else
    let keys = ["SWIFT_EXEC", "HOME", "PATH", "SDKROOT", "TOOLCHAINS", "DEVELOPER_DIR", "LLVM_PROFILE_FILE"]
#endif
    for key in keys {
        if environment[key] == nil {
            environment[key] = getenvString(key)
        }
    }

    let env: [UnsafeMutablePointer<CChar>?] = environment.map{ "\($0.0)=\($0.1)".withCString(strdup) }
    defer { for case let arg? in env { free(arg) } }

    var pid = pid_t()
    let rv: Int32
    if var fileActions = fileActions {
        rv = posix_spawnp(&pid, argv[0], &fileActions, nil, argv + [nil], env + [nil])
    } else {
        rv = posix_spawnp(&pid, argv[0], nil, nil, argv + [nil], env + [nil])
    }
    if rv != 0 {
        try ensureLastOperationSucceeded()
    }

    return pid
}


private func _WSTATUS(_ status: CInt) -> CInt {
    return status & 0x7f
}

private func WIFEXITED(_ status: CInt) -> Bool {
    return _WSTATUS(status) == 0
}

private func WEXITSTATUS(_ status: CInt) -> CInt {
    return (status >> 8) & 0xff
}


/// convenience wrapper for waitpid
func waitpid(_ pid: pid_t) throws -> Int32 {
    while true {
        var exitStatus: Int32 = 0
        let rv = waitpid(pid, &exitStatus, 0)

        if rv != -1 {
            if WIFEXITED(exitStatus) {
                return WEXITSTATUS(exitStatus)
            } else {
                try ensureLastOperationSucceeded()
            }
        } else if errno == EINTR {
            continue  // see: man waitpid
        } else {
            try ensureLastOperationSucceeded()
        }
    }
}
