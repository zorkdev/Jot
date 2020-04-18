#if os(iOS)
@testable import JotKit

final class MockReviewRequestable: ReviewRequestable {
    static var didCallRequestReview = false
    static func requestReview() {
        didCallRequestReview = true
    }
}
#endif
