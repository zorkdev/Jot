// swiftlint:disable:next unused_import
import Foundation

protocol Configurable {
    init()
}

extension Configurable {
    init(configure: (Self) -> Void) {
        self.init()
        configure(self)
    }
}

extension NSObject: Configurable {}
