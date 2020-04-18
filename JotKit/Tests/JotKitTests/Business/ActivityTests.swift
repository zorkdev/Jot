import XCTest
@testable import JotKit

final class ActivityTests: XCTestCase {
    func testShare() {
        let activity = Activity.share
        XCTAssertEqual(activity.type, .share)
        XCTAssertEqual(activity.title, Copy.shareActivity)
        XCTAssertEqual(activity.keywords, [Copy.shareKeyword, Copy.noteKeyword])
        #if os(iOS)
        XCTAssertEqual(activity.suggestedInvocationPhrase, Copy.shareActivity)
        #endif
    }

    func testDelete() {
        let activity = Activity.delete
        XCTAssertEqual(activity.type, .delete)
        XCTAssertEqual(activity.title, Copy.deleteActivity)
        XCTAssertEqual(activity.keywords, [Copy.deleteKeyword, Copy.noteKeyword])
    }

    func testAppend() {
        let activity = Activity.append(text: "Text")
        XCTAssertEqual(activity.type, .append)
        XCTAssertEqual(activity.title, Copy.appendActivity)
        XCTAssertEqual(activity.keywords, [Copy.appendKeyword, Copy.noteKeyword])
        XCTAssertEqual(activity.userInfo?["text"] as? String, "Text")
    }

    #if os(macOS)
    func testSave() {
        let activity = Activity.save
        XCTAssertEqual(activity.type, .save)
        XCTAssertEqual(activity.title, Copy.saveActivity)
        XCTAssertEqual(activity.keywords, [Copy.saveKeyword, Copy.noteKeyword])
    }
    #endif
}
