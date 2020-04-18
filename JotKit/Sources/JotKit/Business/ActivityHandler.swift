#if os(iOS)
import UIKit
//swiftlint:disable:next unused_import
import MobileCoreServices
import Intents
#elseif os(macOS)
import AppKit
#endif

public protocol ActivityHandlerType: AnyObject {
    var appState: AppStateType! { get set }

    func handle(activity: NSUserActivity)
    #if os(iOS)
    func handle(activities: Set<NSUserActivity>)
    @discardableResult
    func handle(shortcutItem: UIApplicationShortcutItem?) -> Bool
    func handle(extensionItems: [NSExtensionItem]?)
    func handle(urls: [URL])
    func handle(intent: INAppendToNoteIntent, completion: @escaping (INAppendToNoteIntentResponse) -> Void)
    #endif
}

final class ActivityHandler: ActivityHandlerType {
    private var currentActivity: NSUserActivity?

    weak var appState: AppStateType!

    init() {
        #if os(macOS)
        NSApp?.servicesProvider = self
        NSAppleEventManager.shared().setEventHandler(self,
                                                     andSelector: #selector(handle(event:)),
                                                     forEventClass: .init(kInternetEventClass),
                                                     andEventID: .init(kAEGetURL))
        #endif
    }

    func handle(activity: NSUserActivity) {
        activate(activity: activity)
        switch activity.type {
        case .share:
            appState.shareBusinessLogic.share()
        case .delete:
            appState.textBusinessLogic.delete()
        case .append:
            guard let text = activity.userInfo?[TextBusinessLogic.key] as? String else { return }
            appState.textBusinessLogic.append(text)
        #if os(macOS)
        case .save:
            appState.shareBusinessLogic.save()
        #endif
        case .url:
            guard let url = activity.webpageURL else { return }
            handle(url: url)
        case nil:
            break
        }
    }

    #if os(iOS)
    func handle(activities: Set<NSUserActivity>) {
        activities.forEach {
            handle(activity: $0)
        }
    }

    @discardableResult
    func handle(shortcutItem: UIApplicationShortcutItem?) -> Bool {
        guard shortcutItem?.type == ActivityType.share.activity else { return false }
        handle(activity: Activity.share)
        return true
    }

    func handle(extensionItems: [NSExtensionItem]?) {
        guard let extensionItems = extensionItems else { return }
        let textType = kUTTypeText as String
        let urlType = kUTTypeURL as String

        extensionItems
            .compactMap { $0.attachments }
            .flatMap { $0 }
            .forEach {
                if $0.hasItemConformingToTypeIdentifier(textType) {
                    $0.loadItem(forTypeIdentifier: textType, options: nil) { text, _ in
                        guard let text = text as? String else { return }
                        self.handle(activity: Activity.append(text: text))
                    }
                } else if $0.hasItemConformingToTypeIdentifier(urlType) {
                    $0.loadItem(forTypeIdentifier: urlType, options: nil) { url, _ in
                        guard let url = url as? URL else { return }
                        self.handle(activity: Activity.append(text: url.absoluteString))
                    }
                }
            }
    }

    func handle(urls: [URL]) {
        urls.forEach { handle(url: $0) }
    }

    func handle(intent: INAppendToNoteIntent, completion: @escaping (INAppendToNoteIntentResponse) -> Void) {
        guard let text = (intent.content as? INTextNoteContent)?.text else {
            completion(.init(code: .failure, userActivity: nil))
            return
        }
        let activity = Activity.append(text: text)
        handle(activity: activity)
        let response = INAppendToNoteIntentResponse(code: .success, userActivity: activity)
        response.note = .init(title: .init(spokenPhrase: Copy.productName),
                              contents: [INTextNoteContent(text: appState.textBusinessLogic.text)],
                              groupName: nil,
                              createdDateComponents: nil,
                              modifiedDateComponents: nil,
                              identifier: nil)
        completion(response)
    }
    #endif

    #if os(macOS)
    @objc
    func handle(event: NSAppleEventDescriptor) {
        guard let eventDescription = event.paramDescriptor(forKeyword: keyDirectObject),
            let urlString = eventDescription.stringValue,
            let url = URL(string: urlString) else { return }
        handle(url: url)
    }

    @objc
    func handleServiceInvocation(_ pboard: NSPasteboard,
                                 userData: String,
                                 error: NSErrorPointer) {
        guard let text = pboard.string(forType: .string) else { return }
        handle(activity: Activity.append(text: text))
    }
    #endif
}

private extension ActivityHandler {
    func activate(activity: NSUserActivity) {
        switch activity.type {
        case .share, .delete, .append:
            currentActivity = activity
            activity.becomeCurrent()
        #if os(macOS)
        case .save:
            currentActivity = activity
            activity.becomeCurrent()
        #endif
        case .url, nil:
            break
        }
    }

    func handle(url: URL) {
        switch url.type {
        case .share:
            handle(activity: Activity.share)
        case .delete:
            handle(activity: Activity.delete)
        case .append:
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let queryItem = components.queryItems?.first(where: { $0.name == TextBusinessLogic.key }),
                let text = queryItem.value else { return }
            handle(activity: Activity.append(text: text))
        #if os(macOS)
        case .save:
            handle(activity: Activity.save)
        #endif
        case .url, nil:
            break
        }
    }
}
