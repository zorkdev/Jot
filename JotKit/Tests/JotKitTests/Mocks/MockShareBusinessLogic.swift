import Combine
#if os(macOS)
import AppKit
#endif
@testable import JotKit

final class MockShareBusinessLogic: ShareBusinessLogicType {
    var sharePublisher = PassthroughSubject<Void, Never>()

    #if os(macOS)
    var shareMenu = NSMenu()
    #endif

    var didCallShare = false
    func share() {
        didCallShare = true
    }

    #if os(macOS)
    var didCallSave = false
    func save() {
        didCallSave = true
    }
    #endif
}
