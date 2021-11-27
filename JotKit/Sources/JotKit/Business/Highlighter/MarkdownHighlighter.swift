#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Ink

extension MarkdownParser: Highlighter {
    public func highlight(_ text: String) -> NSAttributedString { attributedString(from: text) }
}

enum MarkdownHighlighterProvider: HighlighterProvider {
    static var highlighter: Highlighter {
        MarkdownParser(attributesModifiers: [
            .init(target: .headings, attributes: [.font: Font.systemFont(ofSize: 20, weight: .semibold)]),
            .init(target: .inlineCode, attributes: [.font: monospacedFont]),
            .init(target: .codeBlocks, attributes: [.font: monospacedFont])
        ], defaultAttributes: [
            .font: systemFont,
            .foregroundColor: plainTextColor
        ])
    }
}
