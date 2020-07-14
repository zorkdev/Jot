@testable import JotKit

final class MockAppState: AppStateType {
    var textBusinessLogic: TextBusinessLogicType = MockTextBusinessLogic()
    var highlighterBusinessLogic: HighlighterBusinessLogicType = MockHighlighterBusinessLogic()
    var shareBusinessLogic: ShareBusinessLogicType = MockShareBusinessLogic()
    var activityHandler: ActivityHandlerType = MockActivityHandler()
}
