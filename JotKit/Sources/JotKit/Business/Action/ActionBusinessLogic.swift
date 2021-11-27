public protocol Action {
    static var name: String { get }

    static func process(_ text: String) throws -> String
}

enum Actions {}

public protocol ActionBusinessLogicType {
    static var actions: [Action.Type] { get }

    func execute(_ action: Action.Type) throws
}

class ActionBusinessLogic: ActionBusinessLogicType {
    static let actions: [Action.Type] = [
        Actions.Uppercase.self
    ]

    private let textBusinessLogic: TextBusinessLogicType

    init(textBusinessLogic: TextBusinessLogicType) {
        self.textBusinessLogic = textBusinessLogic
    }

    func execute(_ action: Action.Type) throws {
        textBusinessLogic.text = try action.process(textBusinessLogic.text)
    }
}
