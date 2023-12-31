import Crypto
import Fluent
import Vapor

struct ProfileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles_routes = routes.grouped("api", "login")
        profiles_routes.post(use: index)
    }

    func index(request: Request) async throws -> Response {
        try LoginProfile.validate(content: request)
        let new_profile: LoginProfile = try request.content.decode(LoginProfile.self)
        guard
            let profile = try await LoginProfile.query(on: request.db).filter(
                \LoginProfile.$email ~= new_profile.email
            ).first(), let id = profile.id
        else {
            throw Abort(.notFound)
        }
        guard try profile.verify(password: new_profile.password) else {
            throw Abort(.notFound)
        }
        guard
            let user = try await User.query(on: request.db).with(\User.$details).filter(
                \User.$details.$id == id
            ).first()
        else {
            throw Abort(.noContent)
        }
        try await profile.authenticate(request: request)
        try await profile.authenticate(sessionID: profile.id ?? .init(), for: request)
        // try await user.$details.load(on: request.db)
        request.session.data["username"] = user.username
        request.session.data["email"] = user.details.email
        request.session.data["fullname"] = try await user.$complete.get(on: request.db)?.fullname
        return request.redirect(to: request.session.redirectTo ?? "/")
    }
}
