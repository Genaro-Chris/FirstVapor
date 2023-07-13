import Fluent
import Vapor

struct AppointmentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let appointment_routes = routes.grouped("api", "appointment")
        appointment_routes.post(use: create)
        appointment_routes.get(use: self.index)
        appointment_routes.get("appointment", ":id", use: getIndexOf)
        appointment_routes.get(":id",use: getIndex)
    }

    func create(request: Request) async throws -> Response {
        let appointment = try request.content.decode(Appointment.self)

        let users = try await User.query(on: request.db).with(\User.$details).all()
        guard let user = users.first(where: { $0.details.email == appointment.email }) else {
            throw Abort(.notFound)
        }
        
        appointment.$user.id = user.id
        let value = try await appointment.$user.get(on: request.db)
        try await value?.$appointments.create([appointment], on: request.db)
        //try await appointment.save(on: request.db)
        return request.redirect(to: "/")
    }

    func getIndex(request: Request) async throws -> [Appointment] {
        let id = request.parameters.get("id", as: UUID.self)
        guard let user = try await User.find(id, on: request.db) else {
            throw Abort(.notFound)
        }
        let appointments = try await user.$appointments.get(on: request.db)
        return appointments
    }

    func getIndexOf(request: Request) async throws -> Appointment {
        let id = request.parameters.get("id", as: UUID.self)
        guard let appointment = try await Appointment.find(id, on: request.db) else {
            throw Abort(.notFound)
        }
        return appointment
    }

    func index(request: Request) async throws -> [Appointment] {
        let users = try await User.query(on: request.db).with(\User.$appointments).all()
        guard !users.isEmpty else {
            throw Abort(.noContent)
        }
        let appointments = users.map( {
            $0.appointments
        }).reduce(into: []) {
            $0 += $1
        }
        return appointments
    }
}

enum SessionError: Error {
    case invalid
}
