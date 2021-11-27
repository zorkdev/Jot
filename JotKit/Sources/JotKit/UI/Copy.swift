import Foundation

enum Copy {
    static let productName = NSLocalizedString("productName", bundle: .main, comment: .empty)

    static let deleteButton = NSLocalizedString("deleteButton", bundle: .main, comment: .empty)
    static let actionButton = NSLocalizedString("actionButton", bundle: .main, comment: .empty)
    static let shareButton = NSLocalizedString("shareButton", bundle: .main, comment: .empty)

    static let plainText = NSLocalizedString("plainText", bundle: .main, comment: .empty)
    static let swift = NSLocalizedString("swift", bundle: .main, comment: .empty)

    static let shareActivity = NSLocalizedString("shareActivity", bundle: .main, comment: .empty)
    static let deleteActivity = NSLocalizedString("deleteActivity", bundle: .main, comment: .empty)
    static let appendActivity = NSLocalizedString("appendActivity", bundle: .main, comment: .empty)

    static let shareKeyword = NSLocalizedString("shareKeyword", bundle: .main, comment: .empty)
    static let deleteKeyword = NSLocalizedString("deleteKeyword", bundle: .main, comment: .empty)
    static let appendKeyword = NSLocalizedString("appendKeyword", bundle: .main, comment: .empty)
    static let noteKeyword = NSLocalizedString("noteKeyword", bundle: .main, comment: .empty)

    #if os(macOS)
    static let saveActivity = NSLocalizedString("saveActivity", bundle: .main, comment: .empty)
    static let saveKeyword = NSLocalizedString("saveKeyword", bundle: .main, comment: .empty)
    #endif
}
