#if os(macOS)
import Combine
import AppKit

final class HomeToolbar: NSToolbar {
    private let appState: AppStateType
    private var cancellables = Set<AnyCancellable>()

    private lazy var deleteItem: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("deleteItem"))
        let button = NSButton(title: "􀈑",
                              target: self,
                              action: #selector(onTapDelete))
        button.bezelStyle = .texturedRounded
        item.view = button
        item.label = Copy.deleteButton
        item.toolTip = Copy.deleteButton
        return item
    }()

    private lazy var shareItem: NSToolbarItem = {
        let item = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("shareItem"))
        let button = NSButton(image: NSImage(named: NSImage.shareTemplateName)!,
                              target: self,
                              action: #selector(onTapShare))
        button.bezelStyle = .texturedRounded
        item.view = button
        item.label = Copy.shareButton
        item.toolTip = Copy.shareButton
        return item
    }()

    init(appState: AppStateType) {
        self.appState = appState
        super.init(identifier: "homeToolbar")
        delegate = self
        setUpBindings()
    }

    @objc
    func onTapDelete() {
        appState.activityHandler.handle(activity: Activity.delete)
    }

    @objc
    func onTapShare() {
        appState.activityHandler.handle(activity: Activity.share)
    }
}

private extension HomeToolbar {
    func setUpBindings() {
        appState.shareBusinessLogic.sharePublisher
            .receive(on: DispatchQueue.main)
            .sink { self.presentShareSheet() }
            .store(in: &cancellables)
    }

    func presentShareSheet() {
        guard let view = shareItem.view else { return }
        let sharingPicker = NSSharingServicePicker(items: [appState.textBusinessLogic.text])
        sharingPicker.show(relativeTo: view.frame, of: view, preferredEdge: .maxX)
    }
}

extension HomeToolbar: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [deleteItem.itemIdentifier,
         NSToolbarItem.Identifier.flexibleSpace,
         shareItem.itemIdentifier]
    }

    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        [deleteItem, shareItem].first { $0.itemIdentifier == itemIdentifier }
    }
}
#endif
