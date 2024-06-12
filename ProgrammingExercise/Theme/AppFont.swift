import SwiftUI

struct AppFont {
    static func largeTitleMedium() -> Font {
        return helveticaNeueMedium(size: 18)
    }

    static func smallTitle() -> Font {
        return helveticaNeueLight(size: 14)
    }

    static func smallTitleMedium() -> Font {
        return helveticaNeueMedium(size: 14)
    }

    private static func helveticaNeueLight(size: CGFloat) -> Font {
        return .custom("HelveticaNeue-Light", size: size)
    }

    private static func helveticaNeueMedium(size: CGFloat) -> Font {
        return .custom("HelveticaNeue-Medium", size: size)
    }
}
