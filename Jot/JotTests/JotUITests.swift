import XCTest

final class JotUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testApp() {
        givenILaunchTheApp()

        whenIEnter("Lorem ipsum\t")
        whenITapSwiftButton()

        thenICanSee("Lorem ipsum    ")

        whenITapPlainTextButton()

        thenICanSee("Lorem ipsum    ")

        takeScreenshot()
        whenITapShareButton()

        thenICanSeeShareSheet("Lorem ipsum    ")

        #if os(iOS)
        whenITapAddToJot()
        #elseif os(macOS)
        whenITapShareButton()
        #endif
        whenITapDeleteButton()

        thenICanSee("")
    }

    #if os(iOS)
    func testShareAction() {
        givenILaunchTheApp()

        whenITapShareTextShortcut()

        thenICanSeeShareSheet()
    }
    #endif

    #if os(macOS)
    func testMenu() {
        givenILaunchTheApp()

        whenIEnter("Lorem ipsum")
        whenITapSave()

        thenICanSeeSavePanel()

        whenITapSaveOnSavePanel()
        whenITapDeleteAll()

        thenICanSee("")
    }
    #endif
}

private extension JotUITests {
    var textView: XCUIElement { app.textViews.firstMatch }
    var shareButton: XCUIElement { app.buttons["Share"].firstMatch }
    var deleteButton: XCUIElement { app.buttons["Delete"].firstMatch }

    var plainTextButton: XCUIElement {
        #if os(iOS)
        return app.buttons["Plain text"].firstMatch
        #elseif os(macOS)
        return app.radioButtons["Plain text"].firstMatch
        #endif
    }

    var swiftButton: XCUIElement {
        #if os(iOS)
        return app.buttons["Swift"].firstMatch
        #elseif os(macOS)
        return app.radioButtons["Swift"].firstMatch
        #endif
    }

    #if os(macOS)
    var savePanel: XCUIElement { app.dialogs["Save"].firstMatch }
    #endif

    var shareSheet: XCUIElement {
        #if os(iOS)
        return app.otherElements["ActivityListView"].firstMatch
        #elseif os(macOS)
        return shareButton.menus.firstMatch
        #endif
    }

    func givenILaunchTheApp() {
        XCTContext.runActivity(named: #function) { _ in
            app.launch()
        }
    }

    func whenIEnter(_ text: String) {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(textView.exists, "Text view doesn't exist")
            textView.tap()

            if let previousText = textView.value as? String {
                let deleteString = previousText.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
                textView.typeText(deleteString)
            }

            textView.typeText(text)
        }
    }

    func whenITapDeleteButton() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(deleteButton.exists, "Delete button doesn't exist")
            deleteButton.tap()
        }
    }

    func whenITapShareButton() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(shareButton.exists, "Share button doesn't exist")
            shareButton.tap()
        }
    }

    func whenITapPlainTextButton() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(plainTextButton.exists, "Plain text button doesn't exist")
            plainTextButton.tap()
        }
    }

    func whenITapSwiftButton() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(swiftButton.exists, "Swift button doesn't exist")
            swiftButton.tap()
        }
    }

    #if os(iOS)
    func whenITapAddToJot() {
        XCTContext.runActivity(named: #function) { _ in
            shareSheet.cells.element(boundBy: 2).tap()
        }
    }

    func whenITapShareTextShortcut() {
        XCTContext.runActivity(named: #function) { _ in
            XCUIDevice.shared.press(.home)
            let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
            springboard.icons["Jot"].press(forDuration: 1.5)
            springboard.buttons["Share Jot"].tap()
        }
    }
    #endif

    #if os(macOS)
    func whenITapSave() {
        XCTContext.runActivity(named: #function) { _ in
            app.menuItems["Save..."].firstMatch.tap()
        }
    }

    func whenITapSaveOnSavePanel() {
        XCTContext.runActivity(named: #function) { _ in
            savePanel.buttons["Save"].firstMatch.tap()
            let replaceButton = savePanel.buttons["Replace"].firstMatch
            if replaceButton.exists {
                replaceButton.tap()
            }
        }
    }

    func whenITapDeleteAll() {
        XCTContext.runActivity(named: #function) { _ in
            app.menuItems["Delete All"].firstMatch.tap()
        }
    }

    func thenICanSeeSavePanel() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(savePanel.exists, "Save panel doesn't exist")
        }
    }
    #endif

    func thenICanSee(_ text: String) {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(textView.exists, "Text view doesn't exist")
            XCTAssertEqual(textView.value as? String, text)
        }
    }

    func thenICanSeeShareSheet() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(shareSheet.waitForExistence(timeout: 5), "Share sheet doesn't exist")
        }
    }

    func thenICanSeeShareSheet(_ text: String) {
        XCTContext.runActivity(named: #function) { _ in
            thenICanSeeShareSheet()
            #if os(iOS)
            XCTAssertTrue(shareSheet.otherElements[text].exists, "Share text doesn't exist")
            #endif
        }
    }

    func takeScreenshot() {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
