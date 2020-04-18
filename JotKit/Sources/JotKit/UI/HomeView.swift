#if os(macOS)
import AppKit
import Combine

final class HomeView: NSView {
    private static let padding: CGFloat = 16

    private let appState: AppStateType
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = NSScrollView {
        $0.autoresizingMask = [.height, .width]
        $0.hasVerticalScroller = true
    }

    private let textView = NSTextView {
        $0.autoresizingMask = [.height, .width]
        $0.textContainerInset = .init(width: HomeView.padding, height: HomeView.padding)
        $0.textContainer?.lineFragmentPadding = 0.5
        $0.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        $0.isEditable = true
        $0.allowsUndo = true
        $0.isRichText = false
        $0.smartInsertDeleteEnabled = false
        $0.isAutomaticQuoteSubstitutionEnabled = false
        $0.isAutomaticDashSubstitutionEnabled = false
        $0.isAutomaticTextCompletionEnabled = false
        $0.isAutomaticTextReplacementEnabled = false
        $0.isAutomaticSpellingCorrectionEnabled = false
        $0.isGrammarCheckingEnabled = false
    }

    init(appState: AppStateType) {
        self.appState = appState
        super.init(frame: .zero)
        setUp()
        setUpBindings()
    }

    required init?(coder: NSCoder) { nil }
}

private extension HomeView {
    func setUp() {
        scrollView.documentView = textView
        addSubview(scrollView)
        textView.delegate = self
        textView.string = appState.textBusinessLogic.text
    }

    func setUpBindings() {
        appState.textBusinessLogic.textPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                if $0 != self.textView.string {
                    self.textView.string = $0
                }
            }.store(in: &cancellables)
    }
}

extension HomeView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        appState.textBusinessLogic.text = textView.string
    }

    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertTab(_:)) {
            textView.insertText("    ", replacementRange: textView.rangeForUserTextChange)
            return true
        }
        return false
    }
}
#endif
