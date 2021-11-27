extension Actions {
    enum Lowercase: Action {
        static var name: String { "Lowercase" }

        static func process(_ text: String) -> String { text.lowercased() }
    }
}
