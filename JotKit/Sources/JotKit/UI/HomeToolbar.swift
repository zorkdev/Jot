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

    private let segmentedControlItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("segmentedControlItem"))
    private var segmentedControl: NSSegmentedControl!

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
        setUp()
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

    @objc
    func onSelectedSegment(_ sender: NSSegmentedControl) {
        appState.highlighterBuinessLogic.highlighter = type(of: appState.highlighterBuinessLogic)
            .highlighters[sender.selectedSegment]
    }
}

private extension HomeToolbar {
    func setUp() {
        let labels = type(of: appState.highlighterBuinessLogic).highlighters.map { $0.name }
        segmentedControl = NSSegmentedControl(labels: labels,
                                              trackingMode: .selectOne,
                                              target: self,
                                              action: #selector(onSelectedSegment))
        segmentedControl.selectedSegment = appState.highlighterBuinessLogic.currentIndex
        segmentedControlItem.view = segmentedControl
    }

    func setUpBindings() {
        appState.shareBusinessLogic.sharePublisher
            .receive(on: DispatchQueue.main)
            .sink { self.presentShareSheet() }
            .store(in: &cancellables)

        appState.highlighterBuinessLogic.highlighterPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in self.updateSegmentedControl() }
            .store(in: &cancellables)
    }

    func presentShareSheet() {
        guard let view = shareItem.view else { return }
        let sharingPicker = NSSharingServicePicker(items: [appState.textBusinessLogic.text])
        sharingPicker.show(relativeTo: view.frame, of: view, preferredEdge: .maxX)
    }

    func updateSegmentedControl() {
        segmentedControl.setSelected(true, forSegment: appState.highlighterBuinessLogic.currentIndex)
    }
}

extension HomeToolbar: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [deleteItem.itemIdentifier,
         NSToolbarItem.Identifier.flexibleSpace,
         segmentedControlItem.itemIdentifier,
         NSToolbarItem.Identifier.flexibleSpace,
         shareItem.itemIdentifier]
    }

    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        [deleteItem, segmentedControlItem, shareItem].first { $0.itemIdentifier == itemIdentifier }
    }
}
#endif
