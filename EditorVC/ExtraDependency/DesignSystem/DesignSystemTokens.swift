//
//  DesignSystemTokens.swift
//  DesignSystem
//
//  Created by Codex on 26/10/25.
//

import SwiftUI

enum DS {

    enum ColorToken: String, CaseIterable {
        case background
        case surface
        case primary
        case secondary
        case tertiary
        case accent
        case textPrimary
        case textSecondary
        case textTertiary
        case border
        case destructive
    }

    enum Spacing {
        static let x1: CGFloat = 1
        static let x2: CGFloat = 2
        static let x4: CGFloat = 4
        static let x6: CGFloat = 6
        static let x8: CGFloat = 8
        static let x12: CGFloat = 12
        static let x20: CGFloat = 20
        static let x16: CGFloat = 16
        static let x24: CGFloat = 24
        static let x32: CGFloat = 32
        static let x48: CGFloat = 48
    }

    enum CornerRadius {
        static let x8: CGFloat = 8
        static let x12: CGFloat = 12
        static let x16: CGFloat = 16
        static let x24: CGFloat = 24

    }
    enum Radius { }
    
    enum LineWidth {
        static let x1: CGFloat = 1
        static let x2: CGFloat = 2
    }
    
    enum Colors {
        // Brand gradient (dark, subtle blues)
        static let g1 = Color(red: 8/255,  green: 20/255, blue: 60/255)
        static let g2 = Color(red: 16/255, green: 24/255, blue: 90/255)
        static let g3 = Color(red: 24/255, green: 32/255, blue: 120/255)
        static let g4 = Color(red: 197/255, green: 202/255, blue: 232/255)

        static let surface = Color.systemBackground.opacity(0.10)
        static let surfaceStroke = Color.systemBackground.opacity(0.25)
        static let foreground = Color.systemBackground
        static let mutedFg = Color.systemBackground.opacity(0.85)
        static let glow = Color.systemBackground.opacity(0.15)
        
        static let textPrimary = SwiftUI.Color.primary
        static let textSecondary = SwiftUI.Color.secondary
        static let starFilled = SwiftUI.Color.yellow
        static let starEmpty = SwiftUI.Color.secondary.opacity(0.55)
        
        static let accentColor = SwiftUI.Color.accentColor
        
    }
}

import SwiftUI
extension Color {
    static let accentRedPink = Color("AccentColor") //  Color(red: 0.925, green: 0.251, blue: 0.478) // #ec407a
    static let purple = Color.purple
    static let cardLightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let iconGray = Color.gray.opacity(0.6)
    static let softTextGray = Color.gray.opacity(0.6)
    static let badgeYellow = Color.yellow.opacity(0.7)
    static let badgeGreen = Color.green.opacity(0.7)
    static let badgeRed = Color.red.opacity(0.7)
    static let badgeBlack = Color.black.opacity(0.6)
    static let shadow = Color.black.opacity(0.05)
    static let divider = Color.gray.opacity(0.3)
    static let screenBackground = Color(.systemBackground)
    
    var accentGraient : LinearGradient {
        DS.DSColor.accentGradient()
//        LinearGradient(colors: [Color.accentRedPink, Color(hex: "0x7928CA")], startPoint: .leading, endPoint: .trailing)
    }
    var accentGraient2 : LinearGradient {
        LinearGradient(colors: [Color.accentRedPink.opacity(0.1), Color.blue.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
    }
    
    var myGradient : LinearGradient {
        LinearGradient(colors: [self, self.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
    }
    
    
    static let outline        = Color(hex: "0x1A237E").opacity(0.9)
    static let mutedText      = Color.secondary
    static let destructive    = Color.red
    static let overlay        = Color.black.opacity(0.25)
    static let surface        = Color(.systemBackground)


}
