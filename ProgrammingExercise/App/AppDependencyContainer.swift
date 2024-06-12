protocol DependencyContaining: DependencyResolvable, DependencyRegistrable {}

protocol DependencyResolvable {
    func resolve<T>(_ type: T.Type) -> T
}

protocol DependencyRegistrable {
    func register<T>(_ type: T.Type, dependency: @escaping () -> T)
}

final class AppDependencyContainer: DependencyContaining {
    private var dependencies: [String: Any] = [:]

    func register<T>(_ type: T.Type, dependency: @escaping () -> T) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }

    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let dependency = dependencies[key] as? () -> T else {
            // Out of scope: Log error to Observability platform such as Datadog to allow
            // for error visibility and fast follow up fix.
            // logger.log(Error when resolving \(key))
            fatalError("Please register the missing dependency: \(key)")
        }
        return dependency()
    }
}
