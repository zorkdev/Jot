#if os(macOS)
import XCTest
@testable import JotKit

final class HomeViewTests: XCTestCase {
    var appState: MockAppState!
    var textBusinessLogic: MockTextBusinessLogic!
    var highlighterBusinessLogic: MockHighlighterBusinessLogic!
    var highlighter: MockHighlighter!
    var view: HomeView!

    override func setUp() {
        super.setUp()
        appState = .init()
        textBusinessLogic = appState.textBusinessLogic as? MockTextBusinessLogic
        highlighterBusinessLogic = appState.highlighterBusinessLogic as? MockHighlighterBusinessLogic
        highlighter = MockHighlighter()
        MockHighlighterProvider.highlighter = highlighter
        view = .init(appState: appState)
        wait()
    }

    func testInit() {
        XCTAssertNil(HomeView(coder: NSCoder()))
    }

    func testTextDidChange() {
        view.textDidChange(.init(name: NSText.didChangeNotification))
        wait()
        XCTAssertEqual(highlighter.highlightParams, [.empty, .empty, .empty])
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
        wait()
    }

    func testBindings() {
        textBusinessLogic.text = "Text"
        wait()
    }
}
#endif
