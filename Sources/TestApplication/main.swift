// Bring everything together

import Quark

let store = TodoInMemoryStore()
let app = TodoApplication(store: store)
let router = TodoRouter(app: app)

try Server(router).start()
