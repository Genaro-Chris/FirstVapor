import RegexBuilder
import Vapor

extension Validator {
    static var strongPassword: Validator<String> {
        .init { string in
            ValidatorResults.StrongPassKey(string)
        }
    }
}

extension ValidatorResults {
    public struct StrongPassKey {
        var isValidPassKey: Bool
        init(_ pattern: String) {
            try? Self.matchLowerCase(pattern)
            try? Self.matchUpperCase(pattern)
            try? Self.matchDigits(pattern)
            try? Self.matchSpecialCase(pattern)
            try? Self.matchCount(pattern, count: 8)
            isValidPassKey = Self.failureMessage != "contains" ? false : true
        }
        private let successMessage: String = "is a strong password"
        private static var failureMessage: String = "contains"

        static func matchDigits(_ pattern: String) throws {
            let numberMatch = Regex {
                .digit
            }
            guard let _ = pattern.firstMatch(of: numberMatch) else {
                self.failureMessage += "no digits, "
                throw MatchError.noDigits
            }
        }

        static func matchLowerCase(_ pattern: String) throws {
            let lowerCaseMatch = Regex {
                CharacterClass("a"..."z")
            }
            guard let _ = pattern.firstMatch(of: lowerCaseMatch) else {
                self.failureMessage += "no lowercase, "
                throw MatchError.noLowerCase
            }
        }

        static func matchUpperCase(_ pattern: String) throws {
            let upperCaseMatch = Regex {
                CharacterClass("A"..."Z")
            }
            guard let _ = pattern.firstMatch(of: upperCaseMatch) else {
                self.failureMessage += "no uppercase, "
                throw MatchError.noUpperCase
            }
        }

        static func matchSpecialCase(_ pattern: String) throws {
            let specialCaseMatch = Regex {
                .anyOf("~!@#$%^&*(_-+=<>/?.,:;)")
            }
            guard let _ = pattern.firstMatch(of: specialCaseMatch) else {
                self.failureMessage += "no special character "
                throw MatchError.noSpecialCharacter
            }
        }

        static func matchCount(_ pattern: String, count: UInt8) throws {
            guard pattern.count >= count else {
                Self.failureMessage += "and less than \(count)"
                throw MatchError.lessThanRequired
            }
        }
    }
}

extension ValidatorResults.StrongPassKey: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidPassKey
    }

    public var successDescription: String? {
        self.successMessage
    }

    public var failureDescription: String? {
        Self.failureMessage != "contain" ? Self.failureMessage : nil
    }
}
