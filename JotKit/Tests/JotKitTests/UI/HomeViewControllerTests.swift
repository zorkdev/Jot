#if os(iOS)
import XCTest
@testable import JotKit

final class HomeViewControllerTests: XCTestCase {
    var appState: MockAppState!
    var textBusinessLogic: MockTextBusinessLogic!
    var shareBusinessLogic: MockShareBusinessLogic!
    var activityHandler: MockActivityHandler!
    var viewController: HomeViewController!

    override func setUp() {
        super.setUp()
        appState = .init()
        textBusinessLogic = appState.textBusinessLogic as? MockTextBusinessLogic
        shareBusinessLogic = appState.shareBusinessLogic as? MockShareBusinessLogic
        activityHandler = appState.activityHandler as? MockActivityHandler
        viewController = .init(appState: appState)
    }

    func testInit() {
        XCTAssertNil(HomeViewController(coder: NSCoder()))
    }

    func testKeyCommands() {
        let keyCommands = viewController.keyCommands

        XCTAssertEqual(keyCommands?.count, 2)
        XCTAssertEqual(keyCommands?.first?.title, Copy.deleteButton)
        XCTAssertEqual(keyCommands?.last?.title, Copy.shareButton)
    }

    func testTextViewDidChange() {
        let textView = UITextView()
        textView.text = "Text"
        viewController.textViewDidChange(textView)
        XCTAssertEqual(textBusinessLogic.text, "Text")
    }

    func testTextViewShouldChangeText() {
        let textView = UITextView()
        textView.text = "Text"

        XCTAssertFalse(
            viewController.textView(textView,
                                    shouldChangeTextIn: NSRange(location: 4, length: 0),
                                    replacementText: "\t")
        )
        XCTAssertEqual(textView.text, "Text    ")

        XCTAssertTrue(
            viewController.textView(textView,
                                    shouldChangeTextIn: NSRange(location: 8, length: 0),
                                    replacementText: "a")
        )
    }

    func testOnTapDelete() {
        viewController.onTapDelete()
        XCTAssertEqual(activityHandler.handleActivityParams.map { $0.type }, [.delete])
    }

    func testOnTapShare() {
        viewController.onTapShare()
        XCTAssertEqual(activityHandler.handleActivityParams.map { $0.type }, [.share])
    }

    func testOnSelectedSegment() {
        MockHighlighterBusinessLogic.highlighters = [MockHighlighterProvider.self, SwiftHighlighterProvider.self]
        let segmentedControl = UISegmentedControl {
            $0.insertSegment(withTitle: "0", at: 0, animated: false)
            $0.insertSegment(withTitle: "1", at: 1, animated: false)
            $0.selectedSegmentIndex = 1
        }
        viewController.onSelectedSegment(segmentedControl)
        XCTAssertTrue(appState.highlighterBuinessLogic.highlighter == SwiftHighlighterProvider.self)
        MockHighlighterBusinessLogic.highlighters = [MockHighlighterProvider.self]
    }

    func testPresentShareSheet() {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        viewController.presentShareSheet()
        XCTAssertTrue(viewController.presentedViewController is UIActivityViewController)
    }

    func testBindings() {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        shareBusinessLogic.sharePublisher.send(())

        wait()
        wait()

        XCTAssertTrue(viewController.presentedViewController is UIActivityViewController)

        textBusinessLogic.text = "Text"

        wait()
    }

    func testKeyboard() {
        let notification = Notification(name: UIResponder.keyboardWillShowNotification,
                                        object: nil,
                                        userInfo: [UIResponder.keyboardFrameEndUserInfoKey: CGRect.zero])
        NotificationCenter.default.post(notification)
        wait()
    }
}
#endif
