import XCTest
import Combine
@testable import JotKit

final class ShareBusinessLogicTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    var textBusinessLogic: MockTextBusinessLogic!
    var shareBusinessLogic: ShareBusinessLogic!

    override func setUp() {
        super.setUp()
        textBusinessLogic = .init()
        shareBusinessLogic = .init(textBusinessLogic: textBusinessLogic)
    }

    #if os(macOS)
    func testShareMenu() {
        let menu = shareBusinessLogic.shareMenu
        XCTAssertEqual(menu.title, Copy.shareButton)
        shareBusinessLogic.onTapShareMenuItem(NSMenuItem())
    }

    func testSave() {
        shareBusinessLogic.save()
    }
    #endif

    func testShare() {
        let newExpectation = expectation(description: "New expectation")

        shareBusinessLogic.sharePublisher
            .receive(on: DispatchQueue.main)
            .sink { newExpectation.fulfill() }
            .store(in: &cancellables)

        shareBusinessLogic.share()

        waitForExpectations(timeout: 2, handler: nil)
    }
}
