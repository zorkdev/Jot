import XCTest
@testable import JotKit

final class SwiftHighlighterTests: XCTestCase {
    func testProvider() {
        XCTAssertEqual(SwiftHighlighterProvider.identifier, "swift")
        XCTAssertEqual(SwiftHighlighterProvider.name, Copy.swift)
    }

    func testHighlight() {
        let highlighter = SwiftHighlighterProvider.highlighter
        XCTAssertEqual(highlighter.highlight("Text").string, "Text")
    }
}
