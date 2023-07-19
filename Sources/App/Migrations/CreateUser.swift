import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("username", .string)
            .unique(on: "username")
            .field("credentials", .uuid, .required, .references(LoginProfile.schema, "id"))
            .field("details", .uuid, .references(CompleteUser.schema, "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
