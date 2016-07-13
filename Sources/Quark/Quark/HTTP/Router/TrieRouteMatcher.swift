public struct TrieRouteMatcher : RouteMatcher {
    private var routesTrie = Trie<String, RouteProtocol>()
    public let routes: [RouteProtocol]

    public init(routes: [RouteProtocol]) {
        self.routes = routes

        for route in routes {
            // break into components
            let components = route.path.split(separator: "/")

            // insert components into trie with route being the ending payload
            routesTrie.insert(components, payload: route)
        }

        // ensure parameter paths are processed later than static paths
        routesTrie.sort { t1, t2 in
            func rank(_ t: Trie<String, RouteProtocol>) -> Int {
                if t.prefix == "*" {
                    return 3
                }
                if t.prefix?.characters.first == ":" {
                    return 2
                }
                return 1
            }

            return rank(t1) < rank(t2)
        }
    }

    func searchForRoute(head: Trie<String, RouteProtocol>, components: IndexingIterator<[String]>, parameters: inout [String: String]) -> RouteProtocol? {

        var components = components

        // if no more components, we hit the end of the path and
        // may have matched something
        guard let component = components.next() else {
            return head.payload
        }

        // store each possible path (ie both a static and a parameter)
        // and then go through them all
        var paths = [Trie<String, RouteProtocol>]()

        for child in head.children {

            // matched static
            if child.prefix == component {
                paths.append(child)
                continue
            }

            // matched parameter
            if child.prefix?.characters.first == ":" {
                paths.append(child)
                let param = String(child.prefix!.characters.dropFirst())
                parameters[param] = component
                continue
            }

            // matched wildstar
            if child.prefix == "*" {
                paths.append(child)
                continue
            }
        }

        // go through all the paths and recursively try to match them. if
        // any of them match, the route has been matched
        for path in paths {

            if let route = path.payload where path.prefix == "*" {
                return route
            }

            let matched = searchForRoute(head: path, components: components, parameters: &parameters)
            if let matched = matched { return matched }
        }

        // we went through all the possible paths and still found nothing. 404
        return nil
    }

    public func match(_ request: Request) -> RouteProtocol? {
        guard let path = request.path else {
            return nil
        }

        let components = path.unicodeScalars.split(separator: "/").map(String.init)
        var parameters: [String: String] = [:]

        let matched = searchForRoute(
            head: routesTrie,
            components: components.makeIterator(),
            parameters: &parameters
        )

        guard let route = matched else {
            return nil
        }

        if parameters.isEmpty {
            return route
        }

        let parametersMiddleware = PathParameterMiddleware(parameters)

        // wrap the route to inject the pathParameters upon receiving a request
        return BasicRoute(
            path: route.path,
            actions: route.actions.mapValues({parametersMiddleware.chain(to: $0)}),
            fallback: route.fallback
        )
    }
}

extension TrieRouteMatcher : CustomStringConvertible {
    public var description: String {
        return routesTrie.description
    }
}

extension Dictionary {
    func mapValues<T>(_ transform: (Value) -> T) -> [Key: T] {
        var dictionary: [Key: T] = [:]

        for (key, value) in self {
            dictionary[key] = transform(value)
        }

        return dictionary
    }
}
