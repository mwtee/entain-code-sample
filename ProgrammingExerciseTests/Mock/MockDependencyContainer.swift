@testable import ProgrammingExercise

final class MockDependencyContainer: DependencyContaining {
    private(set) var registrations: [String: Any] = [:]
    private(set) var resolvations: [String] = []

    func register<T>(_ type: T.Type, dependency: @escaping () -> T) {
        let key = String(describing: type)
        registrations[key] = dependency
    }

    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        resolvations.append(key)

        guard let dependency = registrations[key] as? () -> T else {
            fatalError("Please register the missing mock dependency \(key)")
        }
        return dependency()
    }
}
