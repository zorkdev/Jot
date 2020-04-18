#if os(macOS)
import AppKit

public final class HomeWindow: NSWindow {
    public convenience init(appState: AppStateType) {
        self.init(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
                  styleMask: [.titled, .closable, .miniaturizable, .resizable],
                  backing: .buffered,
                  defer: false)
        title = Copy.productName
        setFrameAutosaveName(Copy.productName)
        tabbingMode = .disallowed
        titleVisibility = .hidden
        center()
        contentView = HomeView(appState: appState)
        toolbar = HomeToolbar(appState: appState)
    }
}
#endif
