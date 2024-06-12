@testable import ProgrammingExercise

final class MockStorage: Storage {
    var store = [String: Bool]()

    func bool(forKey defaultName: String) -> Bool {
        return store[defaultName] ?? false
    }

    func set(_ value: Bool, forKey defaultName: String) {
        store[defaultName] = value
    }

    func synchronize() -> Bool {
        return true
    }
}
