@testable import JotKit

final class MockAppState: AppStateType {
    var textBusinessLogic: TextBusinessLogicType = MockTextBusinessLogic()
    var shareBusinessLogic: ShareBusinessLogicType = MockShareBusinessLogic()
    var activityHandler: ActivityHandlerType = MockActivityHandler()
}
