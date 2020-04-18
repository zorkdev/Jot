import UIKit
import JotKit
import Intents

// swiftlint:disable:next unused_declaration
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = HomeWindow(windowScene: windowScene, appState: appState)
        window?.makeKeyAndVisible()
        appState.activityHandler.handle(shortcutItem: connectionOptions.shortcutItem)
        appState.activityHandler.handle(activities: connectionOptions.userActivities)
        INPreferences.requestSiriAuthorization { _ in }
    }

    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(appState.activityHandler.handle(shortcutItem: shortcutItem))
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        appState.activityHandler.handle(activity: userActivity)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let urls = URLContexts.map { $0.url }
        appState.activityHandler.handle(urls: urls)
    }
}
