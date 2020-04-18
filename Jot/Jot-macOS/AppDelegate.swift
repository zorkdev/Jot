import AppKit
import JotKit

@NSApplicationMain
// swiftlint:disable:next unused_declaration
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let appState: AppStateType = AppState()

    @IBOutlet var fileMenu: NSMenu!
    @IBOutlet var shareMenuItem: NSMenuItem!

    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        fileMenu.delegate = self
        window = HomeWindow(appState: appState)
        window?.makeKeyAndOrderFront(nil)
    }

    func application(_ application: NSApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
        appState.activityHandler.handle(activity: userActivity)
        return true
    }

    @IBAction func onSave(_ sender: Any) {
        appState.activityHandler.handle(activity: Activity.save)
    }

    @IBAction func onTapDeleteAll(_ sender: Any) {
        appState.activityHandler.handle(activity: Activity.delete)
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        fileMenu.setSubmenu(appState.shareBusinessLogic.shareMenu, for: shareMenuItem)
    }
}
