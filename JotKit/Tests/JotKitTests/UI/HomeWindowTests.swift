#if os(macOS)
import XCTest
@testable import JotKit

final class HomeWindowTests: XCTestCase {
    func testInit() {
        let window = HomeWindow(appState: MockAppState())
        XCTAssertTrue(window.toolbar is HomeToolbar)
        XCTAssertTrue(window.contentView is HomeView)
    }
}
#endif
