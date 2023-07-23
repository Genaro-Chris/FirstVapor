import Fluent
import Vapor

enum Department: String, Codable, CaseIterable {
    case General_Health = "General Health"
    case Cardiology, Dental
    case Medical_Research = "Medical Research"

}

final class Appointment: Model, Content {
    static let schema = "appointment"
    private enum CodingKeys: String, CodingKey {
        case fullname = "name"
        case appointment_date = "date"
        case telephone = "phone"
        case department
        case email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        telephone = try container.decode(UInt.self, forKey: .telephone)
        email = try container.decode(String.self, forKey: .email)
        let date_string = try container.decode(String.self, forKey: .appointment_date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date_string) else {
            throw ConversionError.invalidDate
        }
        appointment_date = date
        fullname = try container.decode(String.self, forKey: .fullname)
        dept = try container.decode(Department.self, forKey: .department)
    }

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "name")
    var fullname: String

    @OptionalParent(key: "user")
    var user: User?


    @Enum(key: "department")
    var dept: Department

    @Field(key: "date")
    var appointment_date: Date

    @Field(key: "telephone")
    var telephone: UInt

    init() {}

    init(id: UUID? = nil, date: Date, fullname: String, email: String, telephone: UInt, dept: Department, user_id: User.IDValue?) {
        self.id = id
        self.appointment_date = date
        self.fullname = fullname
        self.email = email
        self.telephone = telephone
        self.dept = dept
        self.$user.id = user_id
    }

    var description: String {
        fullname + "\n" + "\(telephone)"  + "\n" + "\(appointment_date.description)" + "" + "\n" + "\(dept.rawValue)"
    }

}


extension Appointment: Validatable {

    static func validations(_ validations: inout Validations) {
        validations.add("fullname", as: String.self, is: .ascii, required: true)
        validations.add("email", as: String.self, is: .email && .internationalEmail, required: true)
        validations.add("telephone", as: UInt64.self, is: .range(111_111_111_1...999_999_999_9), required: true)
    }
}


