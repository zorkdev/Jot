import Foundation
import Combine
@testable import JotKit

final class MockHighlighter: Highlighter {
    var highlightParams = [String]()
    func highlight(_ text: String) -> NSAttributedString {
        highlightParams.append(text)
        return NSAttributedString(string: text)
    }
}

enum MockHighlighterProvider: HighlighterProvider {
    static var identifier = "id"
    static var name = "Name"
    static var highlighter: Highlighter = MockHighlighter()
}

final class MockHighlighterBusinessLogic: HighlighterBusinessLogicType {
    static var highlighters: [HighlighterProvider.Type] = [MockHighlighterProvider.self]

    @Published var highlighter: HighlighterProvider.Type = MockHighlighterProvider.self
    var highlighterPublisher: AnyPublisher<HighlighterProvider.Type, Never> { $highlighter.eraseToAnyPublisher() }

    var currentIndex: Int = .zero
}
