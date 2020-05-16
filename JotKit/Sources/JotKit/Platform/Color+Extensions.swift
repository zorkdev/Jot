#if os(iOS)
import UIKit
typealias Color = UIColor
#elseif os(macOS)
import AppKit
typealias Color = NSColor
#endif

extension Color {
    static var plainText: Color {
        #if os(iOS)
        return .label
        #elseif os(macOS)
        return .labelColor
        #endif
    }

    convenience init(light: Color, dark: Color) {
        #if os(iOS)
        self.init { traits -> Color in
            traits.userInterfaceStyle == .dark ? dark : light
        }
        #elseif os(macOS)
        self.init(name: nil) { appearance -> Color in
            appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua ? dark : light
        }
        #endif
    }

    // swiftlint:disable:next identifier_name
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}
