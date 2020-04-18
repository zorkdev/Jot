import XCTest

extension XCTestCase {
    func wait() {
        let newExpectation = expectation(description: "New expectation")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
