#if os(iOS)
import UIKit
typealias Font = UIFont
#elseif os(macOS)
import AppKit
typealias Font = NSFont
#endif

extension Font {
    static var monospaced: Font {
        #if os(iOS)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withDesign(.monospaced)!
        return .init(descriptor: descriptor, size: .zero)
        #elseif os(macOS)
        return .monospacedSystemFont(ofSize: 13, weight: .regular)
        #endif
    }
}
