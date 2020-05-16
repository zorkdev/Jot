import Foundation
import Combine

public protocol Highlighter {
    func highlight(_ text: String) -> NSAttributedString
}

public protocol HighlighterProvider {
    static var identifier: String { get }
    static var name: String { get }
    static var highlighter: Highlighter { get }
}

public protocol HighlighterBusinessLogicType: AnyObject {
    static var highlighters: [HighlighterProvider.Type] { get }
    var highlighter: HighlighterProvider.Type { get set }
    var highlighterPublisher: AnyPublisher<HighlighterProvider.Type, Never> { get }
    var currentIndex: Int { get }
}

final class HighlighterBusinessLogic: HighlighterBusinessLogicType {
    private static let key = "highlighter"

    static let highlighters: [HighlighterProvider.Type] = [
        PlainTextHighlighterProvider.self,
        SwiftHighlighterProvider.self
    ]

    private let dataService: DataService
    private var cancellables = Set<AnyCancellable>()

    @Published var highlighter: HighlighterProvider.Type
    var highlighterPublisher: AnyPublisher<HighlighterProvider.Type, Never> {
        $highlighter.removeDuplicates { $0 == $1 }.eraseToAnyPublisher()
    }

    var currentIndex: Int { Self.highlighters.firstIndex { $0.identifier == highlighter.identifier } ?? .zero }

    init(dataService: DataService) {
        self.dataService = dataService
        self.highlighter = Self.loadHighlighter(dataService: dataService)
        setUpBindings()
    }
}

private extension HighlighterBusinessLogic {
    func setUpBindings() {
        $highlighter
            .sink { self.dataService.save(value: $0.identifier, key: Self.key) }
            .store(in: &cancellables)

        dataService.publisher
            .receive(on: DispatchQueue.main)
            .sink { self.highlighter = Self.loadHighlighter(dataService: self.dataService) }
            .store(in: &cancellables)
    }

    static func loadHighlighter(dataService: DataService) -> HighlighterProvider.Type {
        guard let highlighterValue: String = dataService.load(key: Self.key) else { return highlighters[0] }
        return highlighters.first { $0.identifier == highlighterValue } ?? highlighters[0]
    }
}
