import Foundation
import Splash

extension SyntaxHighlighter: Highlighter where Format.Builder.Output == NSAttributedString {}

enum SwiftHighlighterProvider: HighlighterProvider {
    private static var theme: Theme {
        let callColor = Color(light: .init(r: 62, g: 128, b: 135),
                              dark: .init(r: 120, g: 194, b: 179))
        return .init(
            font: .init(preloaded: .monospaced),
            plainTextColor: .plainText,
            tokenColors: [
                .keyword: .init(light: .init(r: 173, g: 61, b: 164),
                                dark: .init(r: 255, g: 122, b: 178)),
                .string: .init(light: .init(r: 209, g: 48, b: 27),
                               dark: .init(r: 255, g: 130, b: 111)),
                .type: .init(light: .init(r: 74, g: 34, b: 176),
                             dark: .init(r: 218, g: 186, b: 255)),
                .call: callColor,
                .number: .init(light: .init(r: 39, g: 42, b: 217),
                               dark: .init(r: 217, g: 202, b: 125)),
                .comment: .init(light: .init(r: 111, g: 128, b: 140),
                                dark: .init(r: 127, g: 140, b: 152)),
                .property: callColor,
                .dotAccess: callColor,
                .preprocessing: .init(light: .init(r: 120, g: 73, b: 42),
                                      dark: .init(r: 255, g: 161, b: 78))
            ],
            backgroundColor: .clear
        )
    }

    static var identifier: String { "swift" }
    static var name: String { Copy.swift }
    static var highlighter: Highlighter { SyntaxHighlighter(format: AttributedStringOutputFormat(theme: theme)) }
}
