import Combine
#if os(macOS)
import AppKit
#endif

public protocol ShareBusinessLogicType {
    var sharePublisher: PassthroughSubject<Void, Never> { get }
    #if os(macOS)
    var shareMenu: NSMenu { get }

    func save()
    #endif
    func share()
}

final class ShareBusinessLogic: ShareBusinessLogicType {
    private let textBusinessLogic: TextBusinessLogicType

    let sharePublisher = PassthroughSubject<Void, Never>()

    #if os(macOS)
    var shareMenu: NSMenu {
        let sharingServices = NSSharingService.sharingServices(forItems: [textBusinessLogic.text])
        let menu = NSMenu(title: Copy.shareButton)

        sharingServices.forEach { service in
            let menuItem = NSMenuItem(title: service.title,
                                      action: #selector(onTapShareMenuItem(_:)),
                                      keyEquivalent: .empty)
            menuItem.image = service.image
            menuItem.representedObject = service
            menuItem.target = self
            menu.addItem(menuItem)
        }

        return menu
    }
    #endif

    init(textBusinessLogic: TextBusinessLogicType) {
        self.textBusinessLogic = textBusinessLogic
    }

    func share() {
        sharePublisher.send(())
    }

    #if os(macOS)
    func save() {
        let savePanel = NSSavePanel()
        savePanel.begin { result in
            guard result == .OK,
                let fileURL = savePanel.url else { return }
            try? self.textBusinessLogic.text.write(to: fileURL,
                                                   atomically: true,
                                                   encoding: .utf8)
        }
    }

    @objc
    func onTapShareMenuItem(_ sender: NSMenuItem) {
        let service = sender.representedObject as? NSSharingService
        service?.perform(withItems: [textBusinessLogic.text])
    }
    #endif
}
