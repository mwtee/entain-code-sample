import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private static let dependencyContainer = AppDependencyContainer()

    private lazy var appLaunchCoordinator: AppLaunchCoordinator? = {
        guard let window = window else {
            return nil
        }
        return AppLaunchCoordinator(
            window: window,
            container: Self.dependencyContainer
        )
    }()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions:
        UIScene.ConnectionOptions) {
            guard let scene = (scene as? UIWindowScene) else { return }

            let window = UIWindow(windowScene: scene)
            self.window = window
            appLaunchCoordinator?.registerDependecies()
            appLaunchCoordinator?.setupRootViewController()
        }
}
