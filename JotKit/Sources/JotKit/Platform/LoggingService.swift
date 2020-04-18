import os.log

protocol LoggingService {
    func log(title: String, content: String)
}

final class OSLoggingService: LoggingService {
    private let log: OSLog

    init(bundleIdentifier: String) {
        log = .init(subsystem: bundleIdentifier, category: "Debug")
    }

    func log(title: String, content: String) {
        let logString = Self.createLogString(title: title, content: content)
        os_log("%@", log: log, type: .debug, logString)
    }

    static func createLogString(title: String, content: String) -> String {
        """

        🔵 ********* \(title) *********
        \(content)
        *********************************

        """
    }
}
