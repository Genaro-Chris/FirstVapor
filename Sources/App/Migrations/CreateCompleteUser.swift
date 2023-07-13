import Fluent

struct CreateCompleteUser: AsyncMigration {
    func prepare(on database: Database) async throws { 
        /* 
        // Only this if you didn't @Enum(key: ) attributes
        try await create(from: "gender", with: Gender.self, db: database)
        try await create(from: "genotype", with: Genotype.self, db: database)
        try await create(from: "state", with: State.self, db: database)
        try await create(from: "blood_group", with: Blood_Group.self, db: database) */
        let gender = try await database.enum("gender").read()
        let genotype = try await database.enum("genotype").read()
        let state = try await database.enum("state").read()
        let blood_group = try await database.enum("blood_group").read()
        return try await database.schema(CompleteUser.schema)
            .id()
            .field("fullname", .string, .required)
            .field("gender", gender, .required)
            .field("genotype", genotype, .required)
            .field("state", state, .required)
            .field("blood_group", blood_group, .required)
            .field("dob", .date, .required)
            .field("age", .uint8, .required)
            .field("tel", .uint64, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        /* try await ["gender", "blood_group", "genotype", "state"].forEach {
            try await database.enum($0).delete()
        } */
        try await database.schema(CompleteUser.schema).delete()
    }
}

func create(from: String, with: (some CaseIterableWithRawValues).Type, db: Database) async throws {
    var enumBuilder = db.enum(from)
    with.allCases.forEach { val in
        enumBuilder = enumBuilder.case(val.rawValue)
    }
    _ = try await enumBuilder.create()
}


