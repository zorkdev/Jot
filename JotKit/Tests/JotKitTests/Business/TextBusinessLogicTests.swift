import XCTest
import Combine
@testable import JotKit

final class TextBusinessLogicTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    var dataService: MockDataService!
    var textBusinessLogic: TextBusinessLogic!

    override func setUp() {
        super.setUp()
        dataService = .init()
        dataService.loadStringReturnValues = [nil, nil]
    }

    func testBindings() {
        dataService.loadStringReturnValues = ["Text", "Text"]

        textBusinessLogic = .init(dataService: dataService)

        XCTAssertEqual(dataService.loadStringReturnValues, ["Text"])
        XCTAssertEqual(dataService.saveStringParams, [])
        XCTAssertEqual(textBusinessLogic.text, "Text")
        XCTAssertNotNil(textBusinessLogic.textPublisher)

        wait()

        XCTAssertEqual(dataService.loadStringReturnValues, [])
        XCTAssertEqual(dataService.saveStringParams, [
            .init(value: "Text", key: "text")
        ])

        dataService.loadStringReturnValues = ["Updated text"]
        dataService.internalPublisher = ()

        wait()

        XCTAssertEqual(dataService.loadStringReturnValues, [])
        XCTAssertEqual(dataService.saveStringParams, [
            .init(value: "Text", key: "text"),
            .init(value: "Updated text", key: "text")
        ])
        XCTAssertEqual(textBusinessLogic.text, "Updated text")

        textBusinessLogic.text = "User input text"

        wait()

        XCTAssertEqual(dataService.loadStringReturnValues, [])
        XCTAssertEqual(dataService.saveStringParams, [
            .init(value: "Text", key: "text"),
            .init(value: "Updated text", key: "text"),
            .init(value: "User input text", key: "text")
        ])
        XCTAssertEqual(textBusinessLogic.text, "User input text")

        dataService.loadStringReturnValues = [nil]
        dataService.internalPublisher = ()

        wait()

        XCTAssertEqual(dataService.loadStringReturnValues, [])
        XCTAssertEqual(dataService.saveStringParams, [
            .init(value: "Text", key: "text"),
            .init(value: "Updated text", key: "text"),
            .init(value: "User input text", key: "text"),
            .init(value: .empty, key: "text")
        ])
        XCTAssertEqual(textBusinessLogic.text, .empty)
    }

    func testDelete() {
        textBusinessLogic = .init(dataService: dataService)
        textBusinessLogic.text = "Text"

        #if os(iOS)
        let newExpectation = expectation(description: "New expectation")

        textBusinessLogic.deletePublisher
            .receive(on: DispatchQueue.main)
            .sink { newExpectation.fulfill() }
            .store(in: &cancellables)
        #endif

        textBusinessLogic.delete()
        XCTAssertEqual(textBusinessLogic.text, .empty)

        #if os(iOS)
        waitForExpectations(timeout: 1, handler: nil)
        #endif
    }

    func testAppend() {
        textBusinessLogic = .init(dataService: dataService)
        textBusinessLogic.append("Text")
        XCTAssertEqual(textBusinessLogic.text, "Text")
        textBusinessLogic.append("More\n")
        XCTAssertEqual(textBusinessLogic.text, "Text\n\nMore\n")
        textBusinessLogic.append("Copy")
        XCTAssertEqual(textBusinessLogic.text, "Text\n\nMore\n\nCopy")
    }
}
