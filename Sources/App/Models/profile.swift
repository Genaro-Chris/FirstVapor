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
    public static func == (lhs: LoginProfile, rhs: LoginProfile) -> Bool {
        lhs.email == rhs.email && lhs.password == rhs.password
    }
}

extension LoginProfile: Validatable {
    static private var msg: String {
        "Must contain an uppercase, lowercase, a number and at least a special character and no less than 8 characters"
    }
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email && .internationalEmail)
        validations.add(
            "password", as: String.self, is: .strongPassword, required: true,
            customFailureDescription: msg
        )
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
extension LoginProfile: ModelSessionAuthenticatable {}

extension LoginProfile: SessionAuthenticatable {
    typealias SessionID = UUID
    var sessionID: UUID {
        self.id ?? .init()
    }
}

extension LoginProfile: AsyncSessionAuthenticator {
    typealias User = LoginProfile
    func authenticate(sessionID: User.SessionID, for request: Request) async throws {
        guard
            let profile = try await LoginProfile.query(on: request.db).filter(\.$id == sessionID)
                .first()
        else {
            throw Abort(.notFound)
        }
        request.session.authenticate(profile)
    }
}

extension LoginProfile: AsyncRequestAuthenticator {

    func authenticate(request: Request) async throws {
        guard self.id != nil else {
            throw Abort(.notFound)
        }
        request.auth.login(self)
    }

    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        try await self.authenticate(request: request)
        return try await next.respond(to: request)
    }
}
