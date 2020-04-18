import Foundation

public enum Activity {
    public static var share: NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.share.type)
        activity.title = Copy.shareActivity
        activity.keywords = [Copy.shareKeyword, Copy.noteKeyword]
        activity.isEligibleForSearch = true
        activity.isEligibleForPublicIndexing = true
        #if os(iOS)
        activity.isEligibleForPrediction = true
        activity.suggestedInvocationPhrase = Copy.shareActivity
        #endif
        return activity
    }

    public static var delete: NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.delete.type)
        activity.title = Copy.deleteActivity
        activity.keywords = [Copy.deleteKeyword, Copy.noteKeyword]
        return activity
    }

    public static func append(text: String) -> NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.append.type)
        activity.title = Copy.appendActivity
        activity.keywords = [Copy.appendKeyword, Copy.noteKeyword]
        activity.addUserInfoEntries(from: [TextBusinessLogic.key: text])
        return activity
    }

    #if os(macOS)
    public static var save: NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.save.type)
        activity.title = Copy.saveActivity
        activity.keywords = [Copy.saveKeyword, Copy.noteKeyword]
        return activity
    }
    #endif
}
