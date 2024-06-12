import UIKit

struct AppUIColor {
    static let primaryBackground = UIColor { traitCollection -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        } else {
            return .white
        }
    }

    static let primaryText = UIColor { traitCollection -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .white
        } else {
            return .init(red: 35/255, green: 31/255, blue: 32/255, alpha: 1)
        }
    }

    static let secondaryText = UIColor { traitCollection -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .lightGray
        } else {
            return .init(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
        }
    }
}
