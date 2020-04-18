import Combine
@testable import JotKit

final class MockTextBusinessLogic: TextBusinessLogicType {
    @Published var text = String.empty
    var textPublisher: AnyPublisher<String, Never> { $text.eraseToAnyPublisher() }

    #if os(iOS)
    var deletePublisher = PassthroughSubject<Void, Never>()
    #endif

    var didCallDelete = false
    func delete() {
        didCallDelete = true
    }

    var appendParams = [String]()
    func append(_ text: String) {
        appendParams.append(text)
    }
}
