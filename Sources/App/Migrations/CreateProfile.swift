import Fluent

struct CreateProfile: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(LoginProfile.schema)
            .id()
            .field("email", .string, .required)
            .field("password", .string, .required)
            //.field("user", .uuid, .required, .references(User.schema, "id"))
            //.foreignKey("user", references: User.schema, "id")
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(LoginProfile.schema).delete()
    }
}