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

    @Parent(key: "details")
    var details: LoginProfile

    @Field(key: "username")
    var username: String

    @Children(for: \Appointment.$user)
    var appointments: [Appointment]

    var con_password: String = ""

    init() {}

    init(
        id: UUID? = nil, username: String,
        con_password: String = "",
        details_id: LoginProfile.IDValue
    ) {
        self.id = id
        self.username = username
        self.con_password = con_password
        self.$details.id = details_id
    }
}


extension User: CustomStringConvertible {
    var description: String {
        username + "\n" + "\(details.description)" + con_password
    }
}