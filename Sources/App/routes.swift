import Fluent
import Vapor

func routes(_ app: Application) throws {
    /* app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    } */

    app.get("health") { request async throws in
        "\(request.url.path) FirstVapor is running"
     }

    let cors = CORSMiddleware.init(
        configuration: .init(allowedOrigin: .all, allowedMethods: [], allowedHeaders: []))
    app.middleware.use(cors, at: .beginning)
    app.sessions.use(.memory)
    app.sessions.configuration.cookieName = "SESSION"
    app.sessions.configuration.cookieFactory = { idval -> HTTPCookies.Value in
        .init(
            string: idval.string, expires: .now + TimeInterval(exactly: 60)!, isSecure: true,
            isHTTPOnly: true, sameSite: HTTPCookies.SameSitePolicy.none)
    }
    app.middleware.use(app.sessions.middleware)
    try app.register(collection: ProfileController())
    try app.register(collection: AppointmentController())
    try app.register(collection: UserController())
    try app.register(collection: CompleteUserController())
    let redirectMiddleware = LoginProfile.redirectMiddleware { req in
        req.session.redirectTo = req.url.path
        return "/login"
    }
    let protected = app.grouped(LoginProfile.authenticator())
        .grouped(
            LoginProfile.asyncSessionAuthenticator()
        ).grouped(redirectMiddleware)
    protected.grouped("search").get { request async throws in
        return request.redirect(to: "search.html")
    }
}
