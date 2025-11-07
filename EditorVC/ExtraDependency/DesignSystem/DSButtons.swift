//
//  Buttons.swift
//  DesignSystem
//
//  Created by Codex on 26/10/25.
//

import SwiftUI

public enum DSButtonSize {
    case compact
    case regular
    case custom(visualHeight: CGFloat, tapHeight: CGFloat, labelHeight: CGFloat)

    fileprivate var layout: DSButtonLayout {
        switch self {
        case .compact:
            return DSButtonLayout(visualHeight: 35, tapHeight: 44, labelHeight: 22)
        case .regular:
            return DSButtonLayout(visualHeight: 44, tapHeight: 50, labelHeight: 24)
        case let .custom(visual, tap, label):
            return DSButtonLayout(visualHeight: visual, tapHeight: tap, labelHeight: label)
        }
    }
}

private struct DSButtonLayout {
    let visualHeight: CGFloat
    let tapHeight: CGFloat
    let labelHeight: CGFloat

    var contentPadding: CGFloat {
        max(0, (visualHeight - labelHeight) / 2)
    }

    var tapPadding: CGFloat {
        max(0, (tapHeight - visualHeight) / 2)
    }
}

private extension View {
    func applyLayout(_ layout: DSButtonLayout) -> some View {
        self
            .frame(height: layout.labelHeight)
            .padding(.vertical, layout.contentPadding)
    }

    func extendTapArea(_ layout: DSButtonLayout) -> some View {
        self
            .padding(.vertical, layout.tapPadding)
            .contentShape(Rectangle())
            .padding(.vertical, -layout.tapPadding)
    }
}

private struct DSButtonLabel: View {
    let title: String
    let icon: Image?
    let trailingIcon: Image?
    let isLoading: Bool
    let spacing: CGFloat
    let font: Font
    let foreground: Color
    let loadingColor: Color

    var body: some View {
        ZStack {
            HStack(spacing: spacing) {
                if let icon, !isLoading {
                    icon
                        .renderingMode(.template)
                }
                Text(title)
                    .font(font)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)
                if let trailingIcon, !isLoading {
                    trailingIcon
                        .renderingMode(.template)
                }
            }
            .foregroundColor(foreground)
            .opacity(isLoading ? 0 : 1)

            ProgressView()
                .progressViewStyle(.circular)
                .tint(loadingColor)
                .opacity(isLoading ? 1 : 0)
        }
    }
}
extension DS {
    public struct PrimaryButton: View {
        @DS.Theme private var theme
        
        let title: String
        let icon: Image?
        let trailingIcon: Image?
        var isLoading: Bool
        var isDisabled: Bool
        var size: DSButtonSize
        var isFullWidth: Bool
        var shouldAnimate : Bool
        let action: () -> Void
        
        public init(_ title: String,
                    icon: Image? = nil,
                    trailingIcon: Image? = nil,
                    isLoading: Bool = false,
                    isDisabled: Bool = false,
                    size: DSButtonSize = .compact,
                    isFullWidth: Bool = true,
                    shouldAnimate : Bool = false,
                    action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.trailingIcon = trailingIcon
            self.isLoading = isLoading
            self.isDisabled = isDisabled
            self.size = size
            self.isFullWidth = isFullWidth
            self.shouldAnimate = shouldAnimate
            self.action = action
        }
        
        public var body: some View {
            let layout = size.layout
            let disabled = isDisabled || isLoading
            let foregroundColor = disabled ? DS.DSColor.textPrimary() : theme.colors.background.primaryColor
            let backgroundGradient = disabled
            ? DSGradient(start: theme.colors.border.primaryColor, end: theme.colors.border.primaryColor)
            : theme.colors.accent
            
            Button(action: action) {
                DSButtonLabel(title: title,
                              icon: icon,
                              trailingIcon: trailingIcon,
                              isLoading: isLoading,
                              spacing: DS.Spacing.x8,
                              font: .callout,
                              foreground: foregroundColor,
                              loadingColor: foregroundColor)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .applyLayout(layout)
                .padding(.horizontal, DS.Spacing.x16)
                .background {
                    backgroundGradient.fill(opacity: disabled ? 0.65 : 1)
                }
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.CornerRadius.x12, style: .continuous)
                        .stroke(theme.colors.background.primaryColor.opacity(0.12), lineWidth: DS.LineWidth.x1)
                )
            }
            .buttonStyle(.plain)
            .disabled(disabled)
            .extendTapArea(layout)
//            .butterAnimate(duration: shouldAnimate ? 1.0 : 0.0, scale: 1.05, repeatMode: .infinite)
            
        }
    }
    
    public struct SecondaryButton: View {
        @DS.Theme private var theme
        
        let title: String
        let icon: Image?
        let trailingIcon: Image?
        var isDisabled: Bool
        var size: DSButtonSize
        var isFullWidth: Bool
        let action: () -> Void
        
        public init(_ title: String,
                    icon: Image? = nil,
                    trailingIcon: Image? = nil,
                    isDisabled: Bool = false,
                    size: DSButtonSize = .compact,
                    isFullWidth: Bool = true,
                    action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.trailingIcon = trailingIcon
            self.isDisabled = isDisabled
            self.size = size
            self.isFullWidth = isFullWidth
            self.action = action
        }
        
        public var body: some View {
            let layout = size.layout
            let gradient = theme.colors.accent
            let textColor = isDisabled ? theme.colors.textTertiary.primaryColor : gradient.primaryColor
            
            Button(action: action) {
                DSButtonLabel(title: title,
                              icon: icon,
                              trailingIcon: trailingIcon,
                              isLoading: false,
                              spacing: DS.Spacing.x8,
                              font: .callout,
                              foreground: textColor,
                              loadingColor: textColor)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .applyLayout(layout)
                .padding(.horizontal, DS.Spacing.x16)
                .background {
                    theme.colors.background.fill()
                }
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.CornerRadius.x12, style: .continuous)
                        .strokeBorder(gradient.linearGradient.opacity(isDisabled ? 0.5 : 1), lineWidth: DS.LineWidth.x2)
                )
                .opacity(isDisabled ? 0.6 : 1)
            }
            .buttonStyle(.plain)
            .disabled(isDisabled)
            .extendTapArea(layout)
        }
    }
    
    public struct TertiaryButton: View {
        @DS.Theme private var theme
        
        let title: String
        let icon: Image?
        var isDisabled: Bool
        var size: DSButtonSize
        var isFullWidth: Bool
        let action: () -> Void
        
        public init(_ title: String,
                    icon: Image? = nil,
                    isDisabled: Bool = false,
                    size: DSButtonSize = .compact,
                    isFullWidth: Bool = false,
                    action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.isDisabled = isDisabled
            self.size = size
            self.isFullWidth = isFullWidth
            self.action = action
        }
        
        public var body: some View {
            let layout = size.layout
            let gradient = theme.colors.accent
            let textColor = isDisabled ? theme.colors.textTertiary.primaryColor : gradient.primaryColor
            
            Button(action: action) {
                DSButtonLabel(title: title,
                              icon: icon,
                              trailingIcon: nil,
                              isLoading: false,
                              spacing: DS.Spacing.x8,
                              font: .callout,
                              foreground: textColor,
                              loadingColor: textColor)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .applyLayout(layout)
                .padding(.horizontal, DS.Spacing.x12)
                .background {
                    gradient.fill(opacity: isDisabled ? 0.08 : 0.16)
                }
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x12, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(isDisabled)
            .extendTapArea(layout)
        }
    }
    
    public struct AccentTextButton: View {
        @DS.Theme private var theme
        
        let title: String
        let icon: Image?
        let action: () -> Void
        
        public init(_ title: String,
                    icon: Image? = nil,
                    action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.action = action
        }
        
        public var body: some View {
            Button(action: action) {
                HStack(spacing: DS.Spacing.x4) {
                    if let icon {
                        icon
                            .renderingMode(.template)
                            .imageScale(.small)
                    }
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        //.foregroundStyle(theme.colors.accent.fill())
                }
                .foregroundStyle(DS.DSColor.accentGradient())
            }
            .buttonStyle(.plain)
        }
    }
    
    public struct LinkTextButton: View {
        @DS.Theme private var theme
        
        let title: String
        let icon: Image?
        let url: URL
        
        public init(_ title: String,
                    icon: Image? = nil,
                    url: URL) {
            self.title = title
            self.icon = icon
            self.url = url
        }
        
        public var body: some View {
            Link(destination: url) {
                HStack(spacing: DS.Spacing.x4) {
                    if let icon {
                        icon
                            .renderingMode(.template)
                            .imageScale(.small)
                    }
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(theme.colors.accent.primaryColor)
            }
        }
    }
    
}
