#if os(iOS)
import UIKit
import Combine

final class HomeViewController: UIViewController {
    private static let padding: CGFloat = 16

    private let textView = UITextView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInsetAdjustmentBehavior = .always
        $0.keyboardDismissMode = .interactive
        $0.alwaysBounceVertical = true
        $0.textContainer.lineFragmentPadding = .zero
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
        $0.smartInsertDeleteType = .no
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.adjustsFontForContentSizeCategory = true
        $0.font = HomeViewController.createFont()
        $0.textContainerInset = .init(top: HomeViewController.padding,
                                      left: HomeViewController.padding,
                                      bottom: HomeViewController.padding,
                                      right: HomeViewController.padding)
    }

    private let appState: AppStateType
    private var cancellables = Set<AnyCancellable>()

    override var keyCommands: [UIKeyCommand]? {
        let deleteCommand = UIKeyCommand(input: "\u{8}", modifierFlags: .command, action: #selector(onTapDelete))
        deleteCommand.title = Copy.deleteButton

        let shareCommand = UIKeyCommand(input: "S", modifierFlags: .command, action: #selector(onTapShare))
        shareCommand.title = Copy.shareButton

        return [deleteCommand, shareCommand]
    }

    init(appState: AppStateType) {
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
        setUpNavigationBar()
        setUpLayout()
        setUpKeyboard()
        setUpBindings()
    }

    required init?(coder: NSCoder) { nil }

    @objc
    func onTapDelete() {
        appState.activityHandler.handle(activity: Activity.delete)
    }

    @objc
    func onTapShare() {
        appState.activityHandler.handle(activity: Activity.share)
    }

    func presentShareSheet() {
        let viewController = UIActivityViewController(activityItems: [appState.textBusinessLogic.text],
                                                      applicationActivities: nil)
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true, completion: nil)
    }
}

private extension HomeViewController {
    static func createFont() -> UIFont {
        let weight: UIFont.Weight = UIAccessibility.isBoldTextEnabled ? .bold : .regular
        return UIFontMetrics(forTextStyle: .body)
            .scaledFont(for: .monospacedSystemFont(ofSize: UIFont.labelFontSize, weight: weight))
    }

    func setUpNavigationBar() {
        title = Copy.productName
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .trash,
                                                 target: self,
                                                 action: #selector(onTapDelete))
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .action,
                                                  target: self,
                                                  action: #selector(onTapShare))
    }

    func setUpLayout() {
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setUpKeyboard() {
        textView.delegate = self
        textView.text = appState.textBusinessLogic.text

        let keyboardWillOpen = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .receive(on: DispatchQueue.main)
            .sink {
                guard let userInfo = $0.userInfo,
                    let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                let height = max(self.view.frame.height - keyboardFrame.origin.y - self.view.safeAreaInsets.bottom, .zero)
                var contentInset = self.textView.contentInset
                var scrollIndicatorInsets = self.textView.verticalScrollIndicatorInsets
                contentInset.bottom = height
                scrollIndicatorInsets.bottom = height
                self.textView.contentInset = contentInset
                self.textView.verticalScrollIndicatorInsets = scrollIndicatorInsets
            }.store(in: &cancellables)
    }

    func setUpBindings() {
        appState.textBusinessLogic.textPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                if $0 != self.textView.text {
                    self.textView.text = $0
                }
            }.store(in: &cancellables)

        appState.shareBusinessLogic.sharePublisher
            .receive(on: DispatchQueue.main)
            .sink { self.presentShareSheet() }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UIAccessibility.boldTextStatusDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in self.textView.font = Self.createFont() }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        appState.textBusinessLogic.text = textView.text
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\t" {
            textView.insertText("    ")
            return false
        }
        return true
    }
}
#endif
