import Combine
@testable import JotKit

final class MockDataService: DataService {
    @Published var internalPublisher: Void = ()
    var publisher: AnyPublisher<Void, Never> { $internalPublisher.eraseToAnyPublisher() }

    var loadStringReturnValues = [String?]()
    func load(key: String) -> String? {
        loadStringReturnValues.removeFirst()
    }

    struct SaveStringParam: Equatable {
        let value: String
        let key: String
    }

    var saveStringParams = [SaveStringParam]()
    func save(value: String, key: String) {
        saveStringParams.append(.init(value: value, key: key))
    }

    var loadIntReturnValues = [Int?]()
    func load(key: String) -> Int? {
        loadIntReturnValues.removeFirst()
    }

    struct SaveIntParam: Equatable {
        let value: Int
        let key: String
    }

    var saveIntParams = [SaveIntParam]()
    func save(value: Int, key: String) {
        saveIntParams.append(.init(value: value, key: key))
    }
}
