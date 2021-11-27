import Foundation

extension Actions {
    enum FormatJSON: Action {
        static var name: String { "Format JSON" }

        static func process(_ text: String) throws -> String {
            let json = try JSONSerialization.jsonObject(with: Data(text.utf8), options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
            return String(decoding: data, as: UTF8.self)
        }
    }
}
