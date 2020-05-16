import XCTest
import Combine
@testable import JotKit

final class HighlighterBusinessLogicTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    var dataService: MockDataService!
    var highlighterBusinessLogic: HighlighterBusinessLogic!

    override func setUp() {
        super.setUp()
        dataService = .init()
        dataService.loadStringReturnValues = [nil, nil]
    }

    func testBindings() {
        dataService.loadStringReturnValues = ["swift", "swift"]

        highlighterBusinessLogic = .init(dataService: dataService)

        wait()

        XCTAssertTrue(highlighterBusinessLogic.highlighter == SwiftHighlighterProvider.self)
        XCTAssertEqual(highlighterBusinessLogic.currentIndex, 1)

        dataService.loadStringReturnValues = ["plainText"]
        dataService.internalPublisher = ()

        wait()

        XCTAssertTrue(highlighterBusinessLogic.highlighter == PlainTextHighlighterProvider.self)
        XCTAssertEqual(highlighterBusinessLogic.currentIndex, .zero)

        highlighterBusinessLogic.highlighterPublisher
            .receive(on: DispatchQueue.main)
            .sink { XCTAssertTrue($0 == PlainTextHighlighterProvider.self) }
            .store(in: &cancellables)

        dataService.loadStringReturnValues = ["plainText"]
        dataService.internalPublisher = ()

        wait()
    }

    func testCurrentIndex() {
        dataService.loadStringReturnValues = ["swift", "swift"]
        highlighterBusinessLogic = .init(dataService: dataService)

        wait()

        highlighterBusinessLogic.highlighter = MockHighlighterProvider.self

        wait()

        XCTAssertEqual(highlighterBusinessLogic.currentIndex, .zero)
    }

    func testLoad() {
        dataService.loadStringReturnValues = ["invalid", "invalid"]
        highlighterBusinessLogic = .init(dataService: dataService)

        wait()

        XCTAssertTrue(highlighterBusinessLogic.highlighter == PlainTextHighlighterProvider.self)
    }

    func testLoadNil() {
        dataService.loadStringReturnValues = [nil, nil]
        highlighterBusinessLogic = .init(dataService: dataService)

        wait()

        XCTAssertTrue(highlighterBusinessLogic.highlighter == PlainTextHighlighterProvider.self)
    }
}
