import Foundation

extension Actions {
    enum GenerateUUID: Action {
        static var name: String { "Generate UUID" }

        static func process(_ text: String) throws -> String { text + "\n" + UUID().uuidString }
    }
}
