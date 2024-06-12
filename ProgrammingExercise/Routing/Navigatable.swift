import UIKit

protocol Navigatable {
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool
    )
}
