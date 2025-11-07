//
//  ThemeManager.swift
//  DesignSystem
//
//  Created by Codex on 26/10/25.
//

import SwiftUI

extension DS {

    enum ThemeStyle: String, CaseIterable, Identifiable {
        case system
        case light
        case dark

        var id: String { rawValue }

        var preferredColorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
    }

    final class ThemeManager: ObservableObject {
        static let shared = ThemeManager()

        @Published var style: ThemeStyle = .system
        @Published private var accentOverride: DSGradient?

        private let palette: [DSGradientToken] = [
            DSGradientToken(token: .background,
                             light: DSGradient(start: Color(red: 1, green: 1, blue: 1), end: Color(red: 1, green: 1, blue: 1)),
                             dark: DSGradient(start: Color(red: 0.07, green: 0.07, blue: 0.08), end: Color(red: 0.07, green: 0.07, blue: 0.08))),
            DSGradientToken(token: .surface,
                             light: DSGradient(start: Color(red: 0.95, green: 0.95, blue: 0.97), end: Color(red: 0.95, green: 0.95, blue: 0.97)),
                             dark: DSGradient(start: Color(red: 0.16, green: 0.16, blue: 0.18), end: Color(red: 0.16, green: 0.16, blue: 0.18))),
            DSGradientToken(token: .primary,
                             light: DSGradient(start: Color(red: 0.98, green: 0.28, blue: 0.53), end: Color(red: 0.63, green: 0.35, blue: 0.96)),
                             dark: DSGradient(start: Color(red: 0.86, green: 0.23, blue: 0.48), end: Color(red: 0.37, green: 0.45, blue: 0.98)),
                             usesAccentOverride: true),
            DSGradientToken(token: .secondary,
                             light: DSGradient(start: Color(red: 0.2, green: 0.78, blue: 0.35), end: Color(red: 0.2, green: 0.78, blue: 0.35)),
                             dark: DSGradient(start: Color(red: 0.19, green: 0.77, blue: 0.34), end: Color(red: 0.19, green: 0.77, blue: 0.34))),
            DSGradientToken(token: .tertiary,
                             light: DSGradient(start: Color(red: 1, green: 0.62, blue: 0.12), end: Color(red: 1, green: 0.62, blue: 0.12)),
                             dark: DSGradient(start: Color(red: 1, green: 0.84, blue: 0.09), end: Color(red: 1, green: 0.84, blue: 0.09))),
            DSGradientToken(token: .accent,
                             light: DSGradient(start: Color(red: 0.30, green: 0.79, blue: 0.91),
                                               end: Color(red: 0.63, green: 0.41, blue: 0.85)),
                             dark: DSGradient(start: Color(red: 0.00, green: 0.70, blue: 0.88),
                                              end: Color(red: 0.47, green: 0.16, blue: 0.79)),
                             usesAccentOverride: true),
            DSGradientToken(token: .textPrimary,
                             light: DSGradient(start: Color(red: 0.13, green: 0.16, blue: 0.2), end: Color(red: 0.13, green: 0.16, blue: 0.2)),
                             dark: DSGradient(start: Color(red: 0.94, green: 0.95, blue: 0.98), end: Color(red: 0.94, green: 0.95, blue: 0.98))),
            DSGradientToken(token: .textSecondary,
                             light: DSGradient(start: Color(red: 0.38, green: 0.42, blue: 0.47), end: Color(red: 0.38, green: 0.42, blue: 0.47)),
                             dark: DSGradient(start: Color(red: 0.74, green: 0.76, blue: 0.8), end: Color(red: 0.74, green: 0.76, blue: 0.8))),
            DSGradientToken(token: .textTertiary,
                             light: DSGradient(start: Color(red: 0.58, green: 0.62, blue: 0.67), end: Color(red: 0.58, green: 0.62, blue: 0.67)),
                             dark: DSGradient(start: Color(red: 0.55, green: 0.58, blue: 0.63), end: Color(red: 0.55, green: 0.58, blue: 0.63))),
            DSGradientToken(token: .border,
                             light: DSGradient(start: Color(red: 0.87, green: 0.89, blue: 0.92), end: Color(red: 0.87, green: 0.89, blue: 0.92)),
                             dark: DSGradient(start: Color(red: 0.26, green: 0.26, blue: 0.29), end: Color(red: 0.26, green: 0.26, blue: 0.29))),
            DSGradientToken(token: .destructive,
                             light: DSGradient(start: Color(red: 1, green: 0.23, blue: 0.19), end: Color(red: 1, green: 0.23, blue: 0.19)),
                             dark: DSGradient(start: Color(red: 1, green: 0.31, blue: 0.27), end: Color(red: 1, green: 0.31, blue: 0.27)))
        ]

        private init() {}

        func resolvedColorScheme(using systemScheme: ColorScheme) -> ColorScheme {
            switch style {
            case .system: return systemScheme
            case .light: return .light
            case .dark: return .dark
            }
        }

         func colors(for systemScheme: ColorScheme) -> ThemeColors {
            let resolvedScheme = resolvedColorScheme(using: systemScheme)
            let entries: [ThemeColors.Entry] = palette.map { token in
                var gradient = resolvedScheme == .dark ? token.dark : token.light
                if token.usesAccentOverride, let accentOverride {
                    gradient = accentOverride
                }
                return ThemeColors.Entry(token: token.token, name: token.name, gradient: gradient)
            }
            let values = Dictionary(uniqueKeysWithValues: entries.map { ($0.token.rawValue, $0.gradient) })
            return ThemeColors(values: values, entries: entries)
        }

        func setAccentGradient(start: Color, end: Color, startPoint: UnitPoint = .leading, endPoint: UnitPoint = .trailing) {
//            accentOverride = DSGradient(start: start, end: end, startPoint: startPoint, endPoint: endPoint)
        }

        func resetAccentGradient() {
            accentOverride = nil
        }
    }

    @propertyWrapper
    struct Theme: DynamicProperty {
        @Environment(\.colorScheme) private var systemScheme
        @ObservedObject private var manager = ThemeManager.shared

        var wrappedValue: Theme { self }

        var style: ThemeStyle {
            get { manager.style }
            nonmutating set { manager.style = newValue }
        }

        var colors: ThemeColors {
            manager.colors(for: systemScheme)
        }

        func setAccentGradient(start: Color, end: Color) {
            manager.setAccentGradient(start: start, end: end)
        }

        func resetAccentGradient() {
            manager.resetAccentGradient()
        }
    }

    @dynamicMemberLookup
    struct ThemeColors {
        struct Entry: Identifiable {
            let token: DS.ColorToken
            let name: String
            let gradient: DSGradient

            var id: String { token.rawValue }
        }

        private let values: [String: DSGradient]
        private let entries: [Entry]
        private static let fallback = DSGradient(start: .clear, end: .clear)

        fileprivate init(values: [String: DSGradient], entries: [Entry]) {
            self.values = values
            self.entries = entries
        }

        subscript(dynamicMember member: String) -> DSGradient {
            values[member, default: Self.fallback]
        }

        func gradient(for token: DS.ColorToken) -> DSGradient {
            values[token.rawValue, default: Self.fallback]
        }

        var all: [Entry] { entries }
    }
    
    enum DSColor {
        static func accentGradient(for scheme: ColorScheme? = nil) -> LinearGradient {
            resolvedColors(for: scheme).accent.linearGradient
        }

        static func accentColor(for scheme: ColorScheme? = nil) -> Color {
            resolvedColors(for: scheme).accent.primaryColor
        }
        static func accentColor2(for scheme: ColorScheme? = nil) -> Color {
            resolvedColors(for: scheme).accent.secondaryColor
        }
        static func textPrimary(for scheme: ColorScheme? = nil) -> Color {
            resolvedColors(for: scheme).textPrimary.primaryColor
        }
        static func textSecondary(for scheme: ColorScheme? = nil) -> Color {
            resolvedColors(for: scheme).textSecondary.primaryColor
        }

         static func resolvedColors(for scheme: ColorScheme?) -> DS.ThemeColors {
            let systemScheme = scheme ?? (UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light)
            return DS.ThemeManager.shared.colors(for: systemScheme == .dark ? .dark : .light)
        }
    }

}

// MARK: - Gradient Wrapper & Token

private struct DSGradientToken {
    let token: DS.ColorToken
    let name: String
    let light: DSGradient
    let dark: DSGradient
    let usesAccentOverride: Bool

    init(token: DS.ColorToken,
         name: String? = nil,
         light: DSGradient,
         dark: DSGradient,
         usesAccentOverride: Bool = false) {
        self.token = token
        self.name = name ?? token.rawValue.capitalized
        self.light = light
        self.dark = dark
        self.usesAccentOverride = usesAccentOverride
    }
}

public struct DSGradient {
    public let start: Color
    public let end: Color
    public let startPoint: UnitPoint
    public let endPoint: UnitPoint

    public init(start: Color,
                end: Color,
                startPoint: UnitPoint = .leading,
                endPoint: UnitPoint = .trailing) {
        self.start = start
        self.end = end
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    public var linearGradient: LinearGradient {
        LinearGradient(colors: [start, end], startPoint: startPoint, endPoint: endPoint)
    }
   

    public var primaryColor: Color {
        start
    }
    public var secondaryColor: Color {
        end
    }

    @ViewBuilder
    public func fill(opacity: Double = 1) -> some View {
        linearGradient.opacity(opacity)
    }
}
//struct DSThemeContext {
//    let colors: DS.ThemeColors
//    static func current(_ scheme: ColorScheme? = nil) -> DSThemeContext {
//        DSThemeContext(colors: DS.DSColor.resolvedColors(for: scheme))
//    }
//}
