import Foundation
extension Sequence {
    func forEach(body: (Element) async throws -> Void) async throws {
        for value in self {
            try await body(value)
        }
    }
}

protocol CaseIterableWithRawValues: CaseIterable {
    var rawValue: String { get }
}
