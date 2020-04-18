@testable import JotKit

final class MockLoggingService: LoggingService {
    struct LogParam: Equatable {
        let title: String
        let content: String
    }

    var logParams = [LogParam]()
    func log(title: String, content: String) {
        logParams.append(.init(title: title, content: content))
    }
}
