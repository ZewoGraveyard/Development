import CEnvironment

public var environment = Environment()

public struct Environment {
    public lazy var variables: [String: String] = {
        var envs: [String: String] = [:]

        #if os(Linux)
            guard var env = __environ else {
                return envs
            }
        #else
            guard var env = environ else {
                return envs
            }
        #endif

        while true {
            guard let envPointee = env.pointee else {
                break
            }

            guard let envString = String(validatingUTF8: envPointee) else {
                env += 1
                continue
            }

            guard let index = envString.characters.index(of: "=") else {
                env += 1
                continue
            }

            let name = String(envString.characters.prefix(upTo: index))
            let value = String(envString.characters.suffix(from: envString.index(index, offsetBy: 1)))
            envs[name] = value
            env += 1
        }

        return envs
    }()

    public subscript(variable: String) -> String? {
        get {
            return Environment.getEnvironmentVariable(variable)
        }

        nonmutating set(value) {
            if let value = value {
                Environment.setEnvironmentVariable(variable, value: value, replace: true)
            } else {
                Environment.removeEnvironmentVariable(variable)
            }
        }
    }

    private static func getEnvironmentVariable(_ variable: String) -> String? {
        guard let value = getenv(variable) else {
            return nil
        }
        return String(validatingUTF8: value)
    }

    private static func setEnvironmentVariable(_ variable: String, value: String, replace: Bool = true) {
        setenv(variable, value, replace ? 1 : 0)
    }

    private static func removeEnvironmentVariable(_ variable: String) {
        unsetenv(variable)
    }
}
