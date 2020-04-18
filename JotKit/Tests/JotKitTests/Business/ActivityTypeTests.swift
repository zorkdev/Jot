import XCTest
@testable import JotKit

final class ActivityTypeTests: XCTestCase {
    func testTypes() {
        XCTAssertEqual(ActivityType.share.activity, "share")
        XCTAssertEqual(ActivityType.share.type, "com.zorkdev.Jot.share")

        XCTAssertEqual(ActivityType.delete.activity, "delete")
        XCTAssertEqual(ActivityType.delete.type, "com.zorkdev.Jot.delete")

        XCTAssertEqual(ActivityType.append.activity, "append")
        XCTAssertEqual(ActivityType.append.type, "com.zorkdev.Jot.append")

        XCTAssertEqual(ActivityType.url.activity, NSUserActivityTypeBrowsingWeb)
        XCTAssertEqual(ActivityType.url.type, NSUserActivityTypeBrowsingWeb)

        #if os(macOS)
        XCTAssertEqual(ActivityType.save.activity, "save")
        XCTAssertEqual(ActivityType.save.type, "com.zorkdev.Jot.save")
        #endif
    }

    func testInit() {
        XCTAssertEqual(ActivityType(NSUserActivity(activityType: "com.zorkdev.Jot.share")), .share)
        XCTAssertEqual(ActivityType("share"), .share)
    }

    func testExtensions() {
        XCTAssertEqual(NSUserActivity(activityType: "com.zorkdev.Jot.share").type, .share)
        XCTAssertEqual(URL(string: "https://jot.attilanemet.com/share")?.type, .share)
    }
}
