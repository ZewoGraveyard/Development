struct Credentials : MapConvertible {
    let email: String
    let password: String
}

public struct MainRouter : Router {
    let app: Application
    let todos: TodoResource

    public init(app: Application) {
        self.app = app
        self.todos = TodoResource(controller: app.todoController)
    }

    public func custom(routes: Routes) {
        routes.compose("/todos", resource: todos)

        routes.get("/test") { request in
            return Response()
        }

        routes.get("/") { request in
            guard request.session["user-id"] != nil else {
                return Response(redirectTo: "/sign-in")
            }
            return try Response(filePath: "Public/index.html")
        }

        routes.post("/sign-in") { (request, credentials: Credentials) in
            let id = try self.app.signIn(email: credentials.email, password: credentials.password)
            request.session["user-id"] = id
            return Response(redirectTo: "/")
        }

        routes.post("/sign-up") { (request, credentials: Credentials) in
            let id = try self.app.signUp(email: credentials.email, password: credentials.password)
            request.session["user-id"] = id
            return Response(redirectTo: "/")
        }

        routes.post("/sign-out") { request in
            request.session["user-id"] = nil
            return Response(redirectTo: "/sign-in")
        }
    }
}
