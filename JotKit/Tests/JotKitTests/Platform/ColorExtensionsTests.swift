import XCTest
@testable import JotKit

final class ColorExtensionsTests: XCTestCase {
    func testPlainText() {
        XCTAssertNotNil(Color.plainText)
    }

    func testInit() {
        XCTAssertNotNil(Color(r: 1, g: 1, b: 1))
        XCTAssertNotNil(Color(light: .init(r: 0, g: 0, b: 0),
                              dark: .init(r: 1, g: 1, b: 1)).cgColor)
    }
}
