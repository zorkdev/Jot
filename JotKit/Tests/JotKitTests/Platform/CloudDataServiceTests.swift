import XCTest
import Combine
@testable import JotKit

final class CloudDataServiceTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    var loggingService: MockLoggingService!
    var dataService: CloudDataService!

    override func setUp() {
        super.setUp()
        loggingService = .init()
        dataService = .init(loggingService: loggingService)
    }

    func testSaveLoadString() {
        XCTAssertEqual(dataService.load(key: "stringKey"), String?.none)

        dataService.save(value: "value", key: "stringKey")

        XCTAssertEqual(dataService.load(key: "stringKey"), "value")
    }

    #if os(iOS)
    func testSaveLoadInt() {
        XCTAssertEqual(dataService.load(key: "intKey"), .zero)

        dataService.save(value: 1, key: "intKey")

        XCTAssertEqual(dataService.load(key: "intKey"), 1)
    }
    #endif

    func testDidChangeNotification() {
        let newExpectation = expectation(description: "New expectation")

        dataService.publisher
            .receive(on: DispatchQueue.main)
            .sink {
                XCTAssertEqual(self.loggingService.logParams, [
                    .init(title: "KeyValueStoreDidChange",
                          content: "Change reason: Server change\nChanged keys: [\"key\"]")
                ])
                newExpectation.fulfill()
            }.store(in: &cancellables)

        NotificationCenter.default.post(
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil,
            userInfo: [
                NSUbiquitousKeyValueStoreChangeReasonKey: NSUbiquitousKeyValueStoreServerChange,
                NSUbiquitousKeyValueStoreChangedKeysKey: ["key"]
            ]
        )

        waitForExpectations(timeout: 1, handler: nil)
    }
}
