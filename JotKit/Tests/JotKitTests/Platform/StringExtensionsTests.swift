import XCTest
@testable import JotKit

final class StringExtensionsTests: XCTestCase {
    func testEmpty() {
        XCTAssertEqual(String.empty, "")
    }
}
