import Fluent
import Vapor

struct CompleteUserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles_routes = routes.grouped("api", "complete")
        profiles_routes.post(use: create)
        profiles_routes.get(use: index)
    }

    func create(request: Request) async throws -> Response {  
        try CompleteUser.validate(content: request)  
        let complete = try request.content.decode(CompleteUser.self)
        guard let email = request.session.data["email"] else {
            throw Abort(.internalServerError)

        }        
        guard let id = try await LoginProfile.query(on: request.db).filter(\LoginProfile.$email ~= email).first()?.id else {
            throw Abort(.noContent)
        }
        guard let user = try await User.query(on: request.db).with(\User.$details).filter(\User.$details.$id == id).first() else {
            throw Abort(.notFound)
        }
        complete.$user.id = user.id
        try await complete.save(on: request.db)
        request.session.data["fullname"] = complete.fullname    
        return request.redirect(to: "/")
    }

    func index(request: Request) async throws -> [CompleteUser] {
        try await CompleteUser.query(on: request.db).all()
    }
}

