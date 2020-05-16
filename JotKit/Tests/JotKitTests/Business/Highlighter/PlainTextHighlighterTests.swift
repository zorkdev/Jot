import XCTest
@testable import JotKit

final class PlainTextHighlighterTests: XCTestCase {
    func testProvider() {
        XCTAssertEqual(PlainTextHighlighterProvider.identifier, "plainText")
        XCTAssertEqual(PlainTextHighlighterProvider.name, Copy.plainText)
    }

    func testHighlight() {
        let highlighter = PlainTextHighlighterProvider.highlighter
        XCTAssertEqual(highlighter.highlight("Text").string, "Text")
    }
}
