import XCTest
#if os(iOS)
import MobileCoreServices
import Intents
#endif
@testable import JotKit

final class ActivityHandlerTests: XCTestCase {
    var appState: MockAppState!
    var textBusinessLogic: MockTextBusinessLogic!
    var shareBusinessLogic: MockShareBusinessLogic!
    var activityHandler: ActivityHandler!

    override func setUp() {
        super.setUp()
        appState = .init()
        textBusinessLogic = appState.textBusinessLogic as? MockTextBusinessLogic
        shareBusinessLogic = appState.shareBusinessLogic as? MockShareBusinessLogic
        activityHandler = .init()
        activityHandler.appState = appState
    }

    func testHandleActivity() {
        var activities: Set<NSUserActivity> = [
            Activity.share,
            Activity.delete,
            Activity.append(text: "Text"),
            NSUserActivity(activityType: "invalid")
        ]

        #if os(macOS)
        activities.insert(Activity.save)
        #endif

        activities.forEach { activityHandler.handle(activity: $0) }

        XCTAssertTrue(shareBusinessLogic.didCallShare)
        XCTAssertTrue(textBusinessLogic.didCallDelete)
        XCTAssertEqual(textBusinessLogic.appendParams, ["Text"])
        #if os(macOS)
        XCTAssertTrue(shareBusinessLogic.didCallSave)
        #endif
    }

    func testHandleURL() {
        var urlStrings = [
            "https://jot.attilanemet.com/share",
            "https://jot.attilanemet.com/delete",
            "https://jot.attilanemet.com/append?text=Text",
            "https://jot.attilanemet.com/invalid"
        ]

        #if os(macOS)
        urlStrings.append("https://jot.attilanemet.com/save")
        #endif

        let activities: [NSUserActivity] = urlStrings.map {
            let activity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
            activity.webpageURL = URL(string: $0)!
            return activity
        }

        activities.forEach { activityHandler.handle(activity: $0) }

        XCTAssertTrue(shareBusinessLogic.didCallShare)
        XCTAssertTrue(textBusinessLogic.didCallDelete)
        XCTAssertEqual(textBusinessLogic.appendParams, ["Text"])
        #if os(macOS)
        XCTAssertTrue(shareBusinessLogic.didCallSave)
        #endif
    }

    #if os(iOS)
    func testHandleActivities() {
        activityHandler.handle(activities: [Activity.share])
        XCTAssertTrue(shareBusinessLogic.didCallShare)
    }

    func testHandleShortcutItem() {
        let shortcutItem = UIApplicationShortcutItem(type: "share", localizedTitle: "Title")
        activityHandler.handle(shortcutItem: shortcutItem)
        XCTAssertTrue(shareBusinessLogic.didCallShare)
    }

    func testHandleExtensionItems() {
        let textItem = NSItemProvider(item: "Text" as NSSecureCoding,
                                      typeIdentifier: kUTTypeText as String)
        let urlItem = NSItemProvider(item: URL(string: "https://www.apple.com")! as NSSecureCoding,
                                     typeIdentifier: kUTTypeURL as String)
        let extensionItem = NSExtensionItem()
        extensionItem.attachments = [textItem, urlItem]

        activityHandler.handle(extensionItems: [extensionItem])

        wait()

        XCTAssertEqual(textBusinessLogic.appendParams, ["Text", "https://www.apple.com"])
    }

    func testHandleURLs() {
        let urls = [URL(string: "jot://x-callback-url/append?text=Text")!]
        activityHandler.handle(urls: urls)
        XCTAssertEqual(textBusinessLogic.appendParams, ["Text"])
    }

    func testHandleIntent() {
        let newExpectation = expectation(description: "New expectation")
        let intent = INAppendToNoteIntent(targetNote: nil, content: INTextNoteContent(text: "Text"))
        textBusinessLogic.text = "Original text"

        activityHandler.handle(intent: intent) {
            XCTAssertEqual($0.code, .success)
            XCTAssertEqual($0.userActivity?.type, .append)
            XCTAssertEqual($0.note?.title.spokenPhrase, Copy.productName)
            XCTAssertEqual(($0.note?.contents.first as? INTextNoteContent)?.text, "Original text")
            XCTAssertEqual(self.textBusinessLogic.appendParams, ["Text"])
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testHandleInvalidIntent() {
        let newExpectation = expectation(description: "New expectation")
        let intent = INAppendToNoteIntent(targetNote: nil, content: INImageNoteContent())

        activityHandler.handle(intent: intent) {
            XCTAssertEqual($0.code, .failure)
            XCTAssertNil($0.userActivity)
            XCTAssertNil($0.note)
            XCTAssertEqual(self.textBusinessLogic.appendParams, [])
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
    #endif

    #if os(macOS)
    func testHandleServiceInvocation() {
        let pasteBoard = NSPasteboard(name: NSPasteboard.Name(rawValue: "test"))
        pasteBoard.declareTypes([.string], owner: nil)
        pasteBoard.setString("Text", forType: .string)

        activityHandler.handleServiceInvocation(pasteBoard,
                                                userData: .empty,
                                                error: nil)

        XCTAssertEqual(textBusinessLogic.appendParams, ["Text"])
    }

    func testHandleEvent() {
        let event = NSAppleEventDescriptor.appleEvent(withEventClass: AEEventClass(),
                                                      eventID: AEEventID(),
                                                      targetDescriptor: nil,
                                                      returnID: AEReturnID(),
                                                      transactionID: AETransactionID())
        let descriptor = NSAppleEventDescriptor(applicationURL: URL(string: "jot://x-callback-url/append?text=Text")!)
        event.setParam(descriptor, forKeyword: keyDirectObject)
        activityHandler.handle(event: event)
        XCTAssertEqual(textBusinessLogic.appendParams, ["Text"])
    }
    #endif
}
