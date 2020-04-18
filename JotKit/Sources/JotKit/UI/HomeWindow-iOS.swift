#if os(iOS)
import UIKit

public final class HomeWindow: UIWindow {
    public convenience init(windowScene: UIWindowScene, appState: AppStateType) {
        self.init(windowScene: windowScene)
        rootViewController = UINavigationController(rootViewController: HomeViewController(appState: appState))
    }
}
#endif
