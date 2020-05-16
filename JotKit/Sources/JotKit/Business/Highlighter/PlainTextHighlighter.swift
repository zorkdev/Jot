import Foundation

struct PlainTextHighlighter: Highlighter {
    private let font: Font
    private let color: Color

    init(font: Font, color: Color) {
        self.font = font
        self.color = color
    }

    func highlight(_ text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
}

enum PlainTextHighlighterProvider: HighlighterProvider {
    static var identifier: String { "plainText" }
    static var name: String { Copy.plainText }
    static var highlighter: Highlighter { PlainTextHighlighter(font: .monospaced, color: .plainText) }
}
