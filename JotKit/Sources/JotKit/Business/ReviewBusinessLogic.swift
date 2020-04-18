#if os(iOS)
import Combine
import StoreKit

protocol ReviewRequestable {
    static func requestReview()
}

extension SKStoreReviewController: ReviewRequestable {}

protocol ReviewBusinessLogicType {}

final class ReviewBusinessLogic: ReviewBusinessLogicType {
    private static let key = "launchCount"

    private let dataService: DataService
    private let textBusinessLogic: TextBusinessLogicType
    private let shareBusinessLogic: ShareBusinessLogicType
    private let reviewRequestable: ReviewRequestable.Type
    private var cancellables = Set<AnyCancellable>()

    private var launchCount: Int { dataService.load(key: Self.key) ?? .zero }

    init(dataService: DataService,
         textBusinessLogic: TextBusinessLogicType,
         shareBusinessLogic: ShareBusinessLogicType,
         reviewRequestable: ReviewRequestable.Type) {
        self.dataService = dataService
        self.textBusinessLogic = textBusinessLogic
        self.shareBusinessLogic = shareBusinessLogic
        self.reviewRequestable = reviewRequestable
        incrementLaunchCount()
        setUpBindings()
    }

    convenience init(dataService: DataService,
                     textBusinessLogic: TextBusinessLogicType,
                     shareBusinessLogic: ShareBusinessLogicType) {
        self.init(dataService: dataService,
                  textBusinessLogic: textBusinessLogic,
                  shareBusinessLogic: shareBusinessLogic,
                  reviewRequestable: SKStoreReviewController.self)
    }
}

private extension ReviewBusinessLogic {
    func incrementLaunchCount() {
        dataService.save(value: launchCount + 1, key: Self.key)
    }

    func setUpBindings() {
        Publishers.Merge(textBusinessLogic.deletePublisher, shareBusinessLogic.sharePublisher)
            .receive(on: DispatchQueue.main)
            .sink { self.requestReview() }
            .store(in: &cancellables)
    }

    func requestReview() {
        guard launchCount.isMultiple(of: 10) else { return }
        reviewRequestable.requestReview()
    }
}
#endif
