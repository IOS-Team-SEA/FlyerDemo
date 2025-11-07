//
//  DesignSystem.swift
//  VideoInvitation
//
//  Compatibility layer that maps historic helpers onto the new unified DS tokens.
//

import SwiftUI

extension DS.Spacing {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 10
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 28
    static let xxl: CGFloat = 36
    static let two: CGFloat = x2
    static let five: CGFloat = 5
    static let eight: CGFloat = x8
    static let sixteen: CGFloat = x16
    static let twenty24: CGFloat = x24
    
    
    static let cardCornerRadius: CGFloat = DS.CornerRadius.x16
    static let cardPadding: CGFloat = DS.Spacing.x16
    static let sectionSpacing: CGFloat = DS.Spacing.x24
    static let itemSpacing: CGFloat = DS.Spacing.x12
    static let badgePadding: CGFloat = DS.Spacing.x4
    static let iconSize: CGFloat = 20
    static let chartSize: CGFloat = 120
    static let verticalStackSpacing: CGFloat = DS.Spacing.x16
    
}

extension DS.Radius {
    static let eight: CGFloat = DS.CornerRadius.x8
    static let chip: CGFloat = DS.CornerRadius.x12
    static let tile: CGFloat = DS.CornerRadius.x16
    static let button_round_60: CGFloat = 30
    static let button_round_30: CGFloat = 15
}

extension DS {
    enum Stroke {
        static let chip: CGFloat = DS.LineWidth.x1
    }

    enum Fonts {
        static let titleWeight: Font.Weight = .bold
        static let chipWeight: Font.Weight = .semibold
        static let tileTitleWeight: Font.Weight = .semibold

        static func title() -> Font { .system(size: 20, weight: .semibold) }
        static func headline() -> Font { .system(size: 17, weight: .semibold) }
        static func body() -> Font { .system(size: 15, weight: .regular) }
        static func caption() -> Font { .system(size: 13, weight: .regular) }
        static func button() -> Font { .system(size: 16, weight: .semibold) }
    }

    enum ColorsCompat {
        static func primary(_ scheme: ColorScheme? = nil) -> Color {
            DS.DSColor.textPrimary()
        }

        static func secondary(_ scheme: ColorScheme? = nil) -> Color {
            DS.DSColor.textSecondary()
        }

        static func accentGradient(_ scheme: ColorScheme? = nil) -> LinearGradient {
            DS.DSColor.accentGradient()
        }
    }
}

extension DS {
    enum Layout {
        static let maxContentWidth: CGFloat = 560
        static let tileMin: CGFloat = 110
        static let tileMax: CGFloat = 160
    }

    enum StarSize {
        static let star: CGFloat = 34
        static let star2: CGFloat = 54
        static let starSpacing: CGFloat = 12
        static let buttonHeight: CGFloat = 44
        static let editorMinHeight: CGFloat = 118
        static let sheetSidePadding: CGFloat = 24
        static let topPadding: CGFloat = 18
    }

    enum Anim {
        static let snap: Animation = .easeInOut(duration: 0.21)
        static let subtle: Animation = .easeOut(duration: 0.11)
    }

    enum cellSize {
        case regular
        case medium
        case large
        case small
        case columnCount(count: Int)

        var value: CGFloat  {
            switch self {
            case .regular:
                return 100
            case .medium:
                return 150
            case .large:
                return SCREEN_WIDTH
            case .small:
                return 80
            case .columnCount(let count):
                return ((SCREEN_WIDTH - DS.Spacing.xxl) / CGFloat(count))
            }
        }
    }
}

let SCREEN_WIDTH : CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
let SCREEN_HEIGHT : CGFloat = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)



//enum AppShadow {
//    static let card = ShadowStyle(color: Color.black.opacity(0.15), radius: 10, y: 4)
//    struct ShadowStyle { let color: Color; let radius: CGFloat; let y: CGFloat }
//}
//
