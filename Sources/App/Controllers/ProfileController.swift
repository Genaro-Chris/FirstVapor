import Crypto
import Fluent
import Vapor

struct ProfileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles_routes = routes.grouped("api", "login")
        profiles_routes.post(use: index)
    }

    func index(request: Request) async throws -> Response {
        let new_profile: LoginProfile = try request.content.decode(LoginProfile.self)
        guard
            let profile = try await LoginProfile.query(on: request.db).filter(
                \LoginProfile.$email ~= new_profile.email
            ).filter(\LoginProfile.$password ~= new_profile.password).first(), let id = profile.id
        else {
            throw Abort(.notFound)
        }
        guard let user = try await User.query(on: request.db).with(\User.$details).filter(\User.$details.$id == id).first() else {
            throw Abort(.noContent)
        }
        //try await user.$details.load(on: request.db)
        request.session.data["username"] = user.username
        request.session.data["email"] = user.details.email
        return request.redirect(to: "/")
    }
}

