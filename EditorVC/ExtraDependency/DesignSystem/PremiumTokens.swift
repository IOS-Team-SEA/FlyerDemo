//
//  PremiumTokens.swift
//  VideoInvitation
//
//  Created by Codex on 30/10/25.
//

import SwiftUI

extension DS {
    enum Gradients {
        static let premiumHero = DSGradient(start: Color(red: 0.17, green: 0.16, blue: 0.37),
                                            end: Color(red: 0.07, green: 0.08, blue: 0.18),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
        static let premiumGlow = DSGradient(start: Color(red: 0.56, green: 0.34, blue: 0.88),
                                            end: Color(red: 0.21, green: 0.43, blue: 0.93),
                                            startPoint: .top,
                                            endPoint: .bottom)
        static let premiumCard = DSGradient(start: Color(red: 0.43, green: 0.26, blue: 0.86),
                                            end: Color(red: 0.19, green: 0.55, blue: 0.92),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
    }
     struct PremiumBadge: View {
        @DS.Theme private var theme
        let text: String

        var body: some View {
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundColor(theme.colors.accent.primaryColor)
                .padding(.horizontal, DS.Spacing.x12)
                .padding(.vertical, DS.Spacing.x4)
                .background(theme.colors.accent.fill(opacity: 0.18))
                .clipShape(Capsule())
        }
    }
}
