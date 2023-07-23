import Fluent
import Vapor

func routes(_ app: Application) throws {
    /* app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    } */
    let cors = CORSMiddleware.init(configuration: .init(allowedOrigin: .all, allowedMethods: [], allowedHeaders: []))
    app.middleware.use(cors, at: .beginning)

    app.sessions.use(.fluent(.sqlite))
    app.sessions.configuration.cookieName = "SESSION"
    app.sessions.configuration.cookieFactory = { idval  -> HTTPCookies.Value in 
        .init(string: idval.string, expires: .now + TimeInterval(exactly: 60)!, isSecure: true, isHTTPOnly: true, sameSite: HTTPCookies.SameSitePolicy.none)
    }
    app.middleware.use(app.sessions.middleware)
    try app.register(collection: ProfileController())
    try app.register(collection: AppointmentController())
    try app.register(collection: UserController())
    try app.register(collection: CompleteUserController())
}
