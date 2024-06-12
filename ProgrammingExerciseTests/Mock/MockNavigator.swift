import UIKit
@testable import ProgrammingExercise

final class MockNavigator: Navigatable {
    private(set) var pushedViewController: UIViewController?

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
    }
}
