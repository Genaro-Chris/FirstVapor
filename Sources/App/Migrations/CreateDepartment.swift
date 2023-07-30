import Fluent

struct CreateDepartment: AsyncMigration {
    func prepare(on database: Database) async throws {
        var enumBuilder = database.enum("department")
        Department.allCases.forEach {
            enumBuilder = enumBuilder.case($0.rawValue)
        }
        _ = try await enumBuilder.create()
    }

    func revert(on database: Database) async throws {
        try await database.enum("department").delete()
    }
}
