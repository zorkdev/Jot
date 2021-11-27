extension Actions {
    enum Uppercase: Action {
        static var name: String { "Uppercase" }

        static func process(_ text: String) -> String { text.uppercased() }
    }
}
