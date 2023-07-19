import Fluent
import Vapor

final class LoginProfile: Content, Model {
    static let schema = "login_profile"

    @ID(key: .id)
    var id: UUID?

    private enum CodingKeys: String, CodingKey {
        case email
        case password
    }

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    init() {}

    init(email: String, password: String) {
        self.email = email
        self.id = id
        self.password = password
    }
}

extension LoginProfile: CustomStringConvertible {
    public var description: String {
        "email: \(email)\npassword: \(password)"
    }
}

extension LoginProfile: Equatable {
    public static func ==(lhs: LoginProfile, rhs: LoginProfile) -> Bool {
        lhs.email == rhs.email && lhs.password == rhs.password
    }
}
