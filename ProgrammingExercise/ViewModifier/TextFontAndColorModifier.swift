import SwiftUI

struct TextFontAndColorModifier: ViewModifier {
    var font: Font
    var color: Color

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {

    func primaryLargeTitleMediumText() -> some View {
        self.modifier(
            TextFontAndColorModifier(
                font: AppFont.largeTitleMedium(),
                color: AppUIColor.primaryText.color
            )
        )
    }

    func primarySmallTitleText() -> some View {
        self.modifier(
            TextFontAndColorModifier(
                font: AppFont.smallTitle(),
                color: AppUIColor.primaryText.color
            )
        )
    }

    func primarySmallTitleMediumText() -> some View {
        self.modifier(
            TextFontAndColorModifier(
                font: AppFont.smallTitleMedium(),
                color: AppUIColor.primaryText.color
            )
        )
    }

    func secondarySmallTitleText() -> some View {
        self.modifier(
            TextFontAndColorModifier(
                font: AppFont.smallTitle(),
                color: AppUIColor.secondaryText.color
            )
        )
    }

    func secondarySmallTitleMediumText() -> some View {
        self.modifier(
            TextFontAndColorModifier(
                font: AppFont.smallTitleMedium(),
                color: AppUIColor.secondaryText.color
            )
        )
    }
}
