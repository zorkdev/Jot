import XCTest
@testable import JotKit

final class FontExtensionsTests: XCTestCase {
    func testMonospacedFont() {
        XCTAssertNotNil(Font.monospaced)
    }
}
