import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let register_routes = routes.grouped("api", "register")
        register_routes.post(use: create)
    }

    func create(request: Request) async throws -> Response {
        try User.validate(content: request)
        try LoginProfile.validate(content: request)
        let user = try request.content.decode(User.self)
        let user_details = try request.content.decode(LoginProfile.self)
        guard user_details.password == user.con_password else {
            request.logger.error("Passwords mismatch")
            throw Abort(.internalServerError, reason: "Password mismatch")
        }
        user_details.password = try Bcrypt.hash(user_details.password)
        try await user_details.save(on: request.db)
        guard let id = user_details.id else {
            throw Abort(.noContent)
        }
        user.$details.id = id
        try await user.save(on: request.db)
        request.session.data["username"] = user.username
        request.session.data["email"] = user_details.email
        return request.redirect(to: "/complete.html")
    }
}