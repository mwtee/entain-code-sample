import UIKit

protocol AlertPresentable {
    func presentAlert(
        title: String,
        message: String,
        actions: [UIAlertAction]
    )
}

extension AlertPresentable where Self: UIViewController {
    func presentAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alert.addAction)
        present(alert, animated: true)
    }
}
