import Foundation
import Combine

public protocol TextBusinessLogicType: AnyObject {
    var text: String { get set }
    var textPublisher: AnyPublisher<String, Never> { get }

    #if os(iOS)
    var deletePublisher: PassthroughSubject<Void, Never> { get }
    #endif

    func delete()
    func append(_ text: String)
}

final class TextBusinessLogic: TextBusinessLogicType {
    static let key = "text"

    private let dataService: DataService
    private var cancellables = Set<AnyCancellable>()

    @Published var text: String
    var textPublisher: AnyPublisher<String, Never> { $text.removeDuplicates().eraseToAnyPublisher() }

    #if os(iOS)
    let deletePublisher = PassthroughSubject<Void, Never>()
    #endif

    init(dataService: DataService) {
        self.dataService = dataService
        text = dataService.load(key: Self.key) ?? .empty
        setUpBindings()
    }

    func delete() {
        text = .empty
        #if os(iOS)
        deletePublisher.send(())
        #endif
    }

    func append(_ text: String) {
        if self.text.isEmpty == false {
            if self.text.last != "\n" {
                self.text += "\n"
            }
            self.text += "\n"
        }
        self.text += text
    }
}

private extension TextBusinessLogic {
    func setUpBindings() {
        $text
            .removeDuplicates()
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink { self.dataService.save(value: $0, key: Self.key) }
            .store(in: &cancellables)

        dataService.publisher
            .receive(on: DispatchQueue.main)
            .sink { self.text = self.dataService.load(key: Self.key) ?? .empty }
            .store(in: &cancellables)
    }
}
