import Foundation

enum ActivityType: CaseIterable {
    case share
    case delete
    case append
    #if os(macOS)
    case save
    #endif
    case url

    private static let productIdentifier = "com.zorkdev.Jot."

    var activity: String {
        switch self {
        case .share: return "share"
        case .delete: return "delete"
        case .append: return "append"
        #if os(macOS)
        case .save: return "save"
        #endif
        case .url: return NSUserActivityTypeBrowsingWeb
        }
    }

    var type: String {
        switch self {
        case .share, .delete, .append: return Self.productIdentifier + activity
        #if os(macOS)
        case .save: return Self.productIdentifier + activity
        #endif
        case .url: return NSUserActivityTypeBrowsingWeb
        }
    }

    init?(_ activity: NSUserActivity) {
        guard let activityType = Self.allCases.first(where: { $0.type == activity.activityType }) else { return nil }
        self = activityType
    }

    init?(_ activity: String) {
        guard let activityType = Self.allCases.first(where: { $0.activity == activity }) else { return nil }
        self = activityType
    }
}

extension NSUserActivity {
    var type: ActivityType? { ActivityType(self) }
}

extension URL {
    var type: ActivityType? { ActivityType(lastPathComponent) }
}
