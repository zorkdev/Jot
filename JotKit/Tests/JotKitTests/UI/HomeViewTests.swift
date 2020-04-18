#if os(macOS)
import XCTest
@testable import JotKit

final class HomeViewTests: XCTestCase {
    var appState: MockAppState!
    var textBusinessLogic: MockTextBusinessLogic!
    var view: HomeView!

    override func setUp() {
        super.setUp()
        appState = .init()
        textBusinessLogic = appState.textBusinessLogic as? MockTextBusinessLogic
        view = .init(appState: appState)
    }

    func testInit() {
        XCTAssertNil(HomeView(coder: NSCoder()))
    }

    func testTextDidChange() {
        view.textDidChange(.init(name: NSText.didChangeNotification))
    }

    func testTextViewDoCommandBy() {
        let textView = NSTextView()
        textView.string = "Text"

        XCTAssertTrue(
            view.textView(textView, doCommandBy: #selector(textView.insertTab(_:)))
        )
        XCTAssertEqual(textView.string, "Text    ")

        XCTAssertFalse(
            view.textView(textView, doCommandBy: #selector(textView.insertText(_:replacementRange:)))
        )
    }

    func testBindings() {
        textBusinessLogic.text = "Text"
        wait()
    }
}
#endif
