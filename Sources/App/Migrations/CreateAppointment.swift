import Fluent


struct CreateAppointment: AsyncMigration {
    func prepare(on database: Database) async throws {
        /* _ = try await database.enum("department")
        .case(Department.Cardiology.rawValue)
        .case(Department.Dental.rawValue)
        .case(Department.General_Health.rawValue)
        .case(Department.Medical_Research.rawValue)
        .create() */
        let department = try await database.enum("department").read()
        return try await database.schema(Appointment.schema)
            .id()
            .field("name", .string, .required)
            .field("department", department)
            .field("date", .date, .required)
            .field("email", .string, .required)
            .field("telephone", .uint64, .required)
            .field("user", .uuid, .references(User.schema, "id"))
            .unique(on: "name", "email", "date", "department")
            .create()
    }

    func revert(on database: Database) async throws {
        //try await database.enum("department").delete()
        try await database.schema(Appointment.schema).delete()
    }
}