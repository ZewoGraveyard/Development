// This is where you configure your resource

struct TodoResource : Resource {
    let controller: TodoController

    func build(resource: ResourceBuilder) {
        resource.get("/done", action: controller.listDone, view: "list-done.html")
    }
}
