enum MatchError: Error {
    case noDigits
    case noSpecialCharacter
    case noUpperCase
    case noLowerCase
    case lessThanRequired
}


enum ConversionError: Error { 
    case invalidDate
}