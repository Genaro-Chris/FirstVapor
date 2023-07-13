import Fluent
import Vapor

struct CompleteUserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles_routes = routes.grouped("api", "complete")
        profiles_routes.post(use: create)
        profiles_routes.get(use: index)
    }

    func create(request: Request) async throws -> Response {    
        let complete = try request.content.decode(CompleteUser.self)
        guard !request.hasSession else {
            throw Abort(.noContent)
        }
        if let email = request.session.data["email"] {
            let profile = try await LoginProfile.query(on: request.db).filter(\LoginProfile.$email ~= email).first()
            print(profile!)
        }        
        request.session.data["fullname"] = complete.fullname    
        try await complete.save(on: request.db)
        return request.redirect(to: "/")
    }

    func index(request: Request) async throws -> [CompleteUser] {
        try await CompleteUser.query(on: request.db).all()
    }
}

