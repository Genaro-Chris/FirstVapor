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

extension LoginProfile: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email && .internationalEmail)
        validations.add("password", as: String.self, is: .strongPassword, required: true, customFailureDescription: "Must contain an uppercase, lowercase, a number and at least a special character and no less than 8 characters")

    }
}

extension LoginProfile: Authenticatable {}
extension LoginProfile: ModelAuthenticatable {
    static var usernameKey = \LoginProfile.$password
    static var passwordHashKey: KeyPath<LoginProfile, Field<String>> = \LoginProfile.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
extension LoginProfile: ModelCredentialsAuthenticatable {}
