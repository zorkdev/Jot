import Intents
import JotKit

// swiftlint:disable:next unused_declaration
class IntentHandler: INExtension {
    private let appState: AppStateType = AppState()

    override func handler(for intent: INIntent) -> Any? { self }
}

extension IntentHandler: INAppendToNoteIntentHandling {
    func handle(intent: INAppendToNoteIntent, completion: @escaping (INAppendToNoteIntentResponse) -> Void) {
        appState.activityHandler.handle(intent: intent, completion: completion)
    }
}

extension IntentHandler: AppendIntentHandling {
    func handle(intent: AppendIntent, completion: @escaping (AppendIntentResponse) -> Void) {
        guard let text = intent.text else {
            completion(.init(code: .failure, userActivity: nil))
            return
        }
        let activity = Activity.append(text: text)
        appState.activityHandler.handle(activity: activity)
        completion(.init(code: .success, userActivity: activity))
    }

    func resolveText(for intent: AppendIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let text = intent.text else {
            completion(.confirmationRequired(with: nil))
            return
        }
        completion(.success(with: text))
    }
}

extension IntentHandler: ExportIntentHandling {
    func handle(intent: ExportIntent, completion: @escaping (ExportIntentResponse) -> Void) {
        let response = ExportIntentResponse(code: .success, userActivity: Activity.share)
        response.text = appState.textBusinessLogic.text
        completion(response)
    }
}

extension IntentHandler: DeleteIntentHandling {
    func handle(intent: DeleteIntent, completion: @escaping (DeleteIntentResponse) -> Void) {
        let activity = Activity.delete
        appState.activityHandler.handle(activity: activity)
        completion(.init(code: .success, userActivity: activity))
    }
}
