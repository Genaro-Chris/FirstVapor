import Foundation
extension Sequence {
    func forEach(body: (Element) async throws -> ()) async rethrows {
        for value in self {
            try await body(value)
        }
    }
}

protocol CaseIterableWithRawValues: CaseIterable {
    var rawValue: String { get }
}