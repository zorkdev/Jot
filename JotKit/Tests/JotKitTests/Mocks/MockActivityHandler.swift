import Foundation
#if os(iOS)
import UIKit
import Intents
#endif
@testable import JotKit

final class MockActivityHandler: ActivityHandlerType {
    var appState: AppStateType!

    var handleActivityParams = [NSUserActivity]()
    func handle(activity: NSUserActivity) {
        handleActivityParams.append(activity)
    }

    #if os(iOS)
    func handle(activities: Set<NSUserActivity>) {}

    @discardableResult
    func handle(shortcutItem: UIApplicationShortcutItem?) -> Bool { true }

    func handle(extensionItems: [NSExtensionItem]?) {}

    func handle(urls: [URL]) {}

    func handle(intent: INAppendToNoteIntent, completion: @escaping (INAppendToNoteIntentResponse) -> Void) {}
    #endif
}
