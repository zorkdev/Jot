import Foundation
import Combine

protocol DataService {
    var publisher: AnyPublisher<Void, Never> { get }
    func load(key: String) -> String?
    func save(value: String, key: String)
    #if os(iOS)
    func load(key: String) -> Int?
    func save(value: Int, key: String)
    #endif
}

final class CloudDataService: DataService {
    private static let store = NSUbiquitousKeyValueStore.default

    let publisher: AnyPublisher<Void, Never>

    init(loggingService: LoggingService) {
        publisher = NotificationCenter.default
            .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .map {
                Self.log(notification: $0, loggingService: loggingService)
                Self.store.synchronize()
            }.eraseToAnyPublisher()
    }

    func load(key: String) -> String? {
        Self.store.string(forKey: key)
    }

    func save(value: String, key: String) {
        Self.store.set(value, forKey: key)
        Self.store.synchronize()
    }

    #if os(iOS)
    func load(key: String) -> Int? {
        Int(Self.store.longLong(forKey: key))
    }

    func save(value: Int, key: String) {
        Self.store.set(Int64(value), forKey: key)
    }
    #endif
}

private extension CloudDataService {
    static func log(notification: Notification, loggingService: LoggingService) {
        guard let userInfo = notification.userInfo,
            let reasonCode = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int else { return }

        let reasonString: String

        switch reasonCode {
        case NSUbiquitousKeyValueStoreServerChange: reasonString = "Server change"
        case NSUbiquitousKeyValueStoreInitialSyncChange: reasonString = "Initial sync"
        case NSUbiquitousKeyValueStoreQuotaViolationChange: reasonString = "Quota violation"
        case NSUbiquitousKeyValueStoreAccountChange: reasonString = "Account change"
        default: reasonString = "Unknown"
        }

        var content = "Change reason: " + reasonString

        if let changedKeys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] {
            content += "\nChanged keys: \(changedKeys)"
        }

        loggingService.log(title: "KeyValueStoreDidChange", content: content)
    }
}
