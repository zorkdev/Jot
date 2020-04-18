import XCTest
@testable import JotKit

final class OSLoggingServiceTests: XCTestCase {
    func testLogging() {
        let loggingService = OSLoggingService(bundleIdentifier: "bundleIdentifier")

        loggingService.log(title: "Title", content: "Content")

        XCTAssertEqual(
            OSLoggingService.createLogString(title: "Title", content: "Content"),
            """

            🔵 ********* Title *********
            Content
            *********************************

            """
        )
    }
}
