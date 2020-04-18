import Foundation
import JotKit

// swiftlint:disable:next unused_declaration
final class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    private let appState: AppStateType = AppState()

    func beginRequest(with context: NSExtensionContext) {
        appState.activityHandler.handle(extensionItems: context.inputItems as? [NSExtensionItem])
        context.completeRequest(returningItems: context.inputItems, completionHandler: nil)
    }
}
