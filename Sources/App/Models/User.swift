import Fluent
import Vapor

final class User: Content, Model {
    static let schema = "user"

    private enum CodingKeys: String, CodingKey {
        case username
        case con_password = "con-password"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        con_password = try container.decode(String.self, forKey: .con_password)

    }

    @ID
    var id: UUID?

    @Parent(key: "credentials")
    var details: LoginProfile

    @Field(key: "username")
    var username: String

    @Children(for: \Appointment.$user)
    var appointments: [Appointment]

    @OptionalChild(for: \CompleteUser.$user)
    var complete: CompleteUser?

    var con_password: String = ""

    init() {}

    init(
        id: UUID? = nil, username: String,
        con_password: String = "",
        credentials_id: LoginProfile.IDValue
        ) {
        self.id = id
        self.username = username
        self.con_password = con_password
        self.$details.id = credentials_id
    }
}


extension User: CustomStringConvertible {
    var description: String {
        username + "\n" + "\(details.description)" + con_password
    }
}