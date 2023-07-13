import Fluent
import Vapor

enum Genotype: String, Codable, CaseIterableWithRawValues {
    case AA, AS, SS
}

enum Gender: String, Codable, CaseIterableWithRawValues {
    case Male, Female
}

enum State: String, Codable, CaseIterableWithRawValues {
    case Abia, Anambra, Ebonyi, Enugu, Imo
}

enum Blood_Group: String, Codable, CaseIterableWithRawValues {
    case Ap = "A+"
    case Am = "A-"
    case ABp = "AB+"
    case ABm = "AB-"
    case Op = "O+"
    case Om = "O-"

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self = switch try container.decode(String.self) {
            case "AB+": .ABp
            case "A+": .Ap
            case "AB-": .ABm
            case "A-": .Am
            case "O+": .Op
            case "O-": .Om
            default: .Ap
        }
    }

    init?(rawValue: String) {
        switch rawValue {
            case "AB+": self = .ABp
            case "A+": self = .Ap
            case "AB-": self = .ABm
            case "A-": self = .Am
            case "O+": self = .Op
            case "O-": self = .Om
            default: return nil
        }
    }
}

final class CompleteUser: Model, Content {
    static let schema = "complete-user"

    private enum CodingKeys: String, CodingKey {
        case gender, blood_group, genotype, fullname
        case dob = "date"
        case state, age, telephone
    }

    @ID()
    var id: UUID?

    @Enum(key: "gender")
    var gender: Gender

    @Enum(key: "blood_group")
    var blood_group: Blood_Group

    @Enum(key: "genotype")
    var genotype: Genotype

    @Field(key: "fullname")
    var fullname: String

    @Field(key: "dob")
    var dob: Date

    @Enum(key: "state")
    var state: State

    @Field(key: "age")
    var age: UInt8

    @Field(key: "tel")
    var telephone: UInt64

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        telephone = try container.decode(UInt64.self, forKey: .telephone)
        fullname = try container.decode(String.self, forKey: .fullname)
        let date_string = try container.decode(String.self, forKey: .dob)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dob = formatter.date(from: date_string)!
        age = try container.decode(UInt8.self, forKey: .age)
        state = try container.decode(State.self, forKey: .state)
        gender = try container.decode(Gender.self, forKey: .gender)
        blood_group = try container.decode(Blood_Group.self, forKey: .blood_group)
        genotype = try container.decode(Genotype.self, forKey: .genotype)
    }
}
