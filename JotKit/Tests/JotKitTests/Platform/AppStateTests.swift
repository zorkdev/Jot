import XCTest
@testable import JotKit

final class AppStateTests: XCTestCase {
    func testInit() {
        #if os(iOS)
        let appState = AppState(loggingService: MockLoggingService(),
                                dataService: MockDataService(),
                                reviewBusinessLogic: MockReviewBusinessLogic(),
                                textBusinessLogic: MockTextBusinessLogic(),
                                highlighterBusinessLogic: MockHighlighterBusinessLogic(),
                                shareBusinessLogic: MockShareBusinessLogic(),
                                activityHandler: MockActivityHandler())
        #elseif os(macOS)
        let appState = AppState(loggingService: MockLoggingService(),
                                dataService: MockDataService(),
                                textBusinessLogic: MockTextBusinessLogic(),
                                highlighterBusinessLogic: MockHighlighterBusinessLogic(),
                                shareBusinessLogic: MockShareBusinessLogic(),
                                activityHandler: MockActivityHandler())
        #endif
        XCTAssertTrue(appState.textBusinessLogic is MockTextBusinessLogic)
        XCTAssertTrue(appState.highlighterBusinessLogic is MockHighlighterBusinessLogic)
        XCTAssertTrue(appState.shareBusinessLogic is MockShareBusinessLogic)
        XCTAssertTrue(appState.activityHandler is MockActivityHandler)
        XCTAssertTrue(appState.activityHandler.appState is AppState)
    }

    func testConvenienceInit() {
        let appState = AppState()
        XCTAssertTrue(appState.textBusinessLogic is TextBusinessLogic)
        XCTAssertTrue(appState.highlighterBusinessLogic is HighlighterBusinessLogic)
        XCTAssertTrue(appState.shareBusinessLogic is ShareBusinessLogic)
        XCTAssertTrue(appState.activityHandler is ActivityHandler)
        XCTAssertTrue(appState.activityHandler.appState is AppState)
    }
}
