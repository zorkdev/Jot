#if os(macOS)
import XCTest
@testable import JotKit

final class HomeToolbarTests: XCTestCase {
    var appState: MockAppState!
    var activityHandler: MockActivityHandler!
    var toolbar: HomeToolbar!

    override func setUp() {
        super.setUp()
        appState = .init()
        activityHandler = appState.activityHandler as? MockActivityHandler
        toolbar = .init(appState: appState)
    }

    func testOnTapDelete() {
        toolbar.onTapDelete()
        XCTAssertEqual(activityHandler.handleActivityParams.map { $0.type }, [.delete])
    }

    func testOnTapShare() {
        toolbar.onTapShare()
        XCTAssertEqual(activityHandler.handleActivityParams.map { $0.type }, [.share])
    }

    func testDefaultItemIdentifiers() {
        XCTAssertEqual(toolbar.toolbarDefaultItemIdentifiers(NSToolbar()), [
            NSToolbarItem.Identifier("deleteItem"),
            .flexibleSpace,
            NSToolbarItem.Identifier("shareItem")
        ])
    }

    func testItemForItemIdentifier() {
        XCTAssertNotNil(toolbar.toolbar(NSToolbar(),
                                        itemForItemIdentifier: NSToolbarItem.Identifier("shareItem"),
                                        willBeInsertedIntoToolbar: true))
        XCTAssertNotNil(toolbar.toolbar(NSToolbar(),
                                        itemForItemIdentifier: NSToolbarItem.Identifier("deleteItem"),
                                        willBeInsertedIntoToolbar: true))
    }
}
#endif
