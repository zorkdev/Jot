#if os(iOS)
import XCTest
@testable import JotKit

final class ReviewBusinessLogicTests: XCTestCase {
    var dataService: MockDataService!
    var textBusinessLogic: MockTextBusinessLogic!
    var shareBusinessLogic: MockShareBusinessLogic!
    var reviewBusinessLogic: ReviewBusinessLogic!

    override func setUp() {
        super.setUp()
        dataService = .init()
        textBusinessLogic = .init()
        shareBusinessLogic = .init()
        dataService.loadIntReturnValues = [2]
        reviewBusinessLogic = .init(dataService: dataService,
                                    textBusinessLogic: textBusinessLogic,
                                    shareBusinessLogic: shareBusinessLogic,
                                    reviewRequestable: MockReviewRequestable.self)
    }

    func testInit() {
        dataService.loadIntReturnValues = [nil]
        reviewBusinessLogic = .init(dataService: dataService,
                                    textBusinessLogic: textBusinessLogic,
                                    shareBusinessLogic: shareBusinessLogic)
    }

    func testLaunchCount() {
        dataService.loadIntReturnValues = [nil]

        reviewBusinessLogic = .init(dataService: dataService,
                                    textBusinessLogic: textBusinessLogic,
                                    shareBusinessLogic: shareBusinessLogic,
                                    reviewRequestable: MockReviewRequestable.self)

        XCTAssertEqual(dataService.saveIntParams, [
            .init(value: 3, key: "launchCount"),
            .init(value: 1, key: "launchCount")
        ])
    }

    func testBindings() {
        MockReviewRequestable.didCallRequestReview = false

        dataService.loadIntReturnValues = [5]
        textBusinessLogic.deletePublisher.send(())
        wait()
        XCTAssertFalse(MockReviewRequestable.didCallRequestReview)

        dataService.loadIntReturnValues = [20]
        shareBusinessLogic.sharePublisher.send(())
        wait()
        XCTAssertTrue(MockReviewRequestable.didCallRequestReview)
    }
}
#endif
