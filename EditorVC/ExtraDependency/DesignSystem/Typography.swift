//
//  Typography.swift
//  DesignSystem
//
//  Created by Codex on 26/10/25.
//

import SwiftUI

extension DS {
    enum TextLayoutStyle {
        case flexible
        case fixedWidth(CGFloat)
        case fixedFontSize(CGFloat)
        case autoAdjust(width: CGFloat, minimumScaleFactor: CGFloat = 0.7)
    }
}

private extension View {
    @ViewBuilder
    func apply(_ style: DS.TextLayoutStyle?) -> some View {
        switch style {
        case .flexible:
            self
                .fixedSize(horizontal: false, vertical: false)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .fixedWidth(let width):
            self
                .frame(width: width, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        case .fixedFontSize(let size):
            self
                .font(.system(size: size))
                .minimumScaleFactor(1.0)
        case .autoAdjust(let width, let scale):
            self
                .frame(width: width, alignment: .leading)
                .minimumScaleFactor(scale)
                .lineLimit(1)
        case .none:
            self
                .fixedSize(horizontal: false, vertical: false)
        }
    }
}

extension DS {
    
    struct TitleText: View {
        @DS.Theme private var theme
        
        let text: String
        
        var layout: DS.TextLayoutStyle?
        var alignment: TextAlignment
        
        init(_ text: String,
             layout: DS.TextLayoutStyle? = nil,
             alignment: TextAlignment = .leading) {
            self.text = text
            self.layout = layout
            self.alignment = alignment
        }
        
        var body: some View {
            Text(text)
                .font(.largeTitle.bold())
                .multilineTextAlignment(alignment)
                .foregroundColor(theme.colors.textPrimary.primaryColor)
                .apply(layout)
        }
    }
    
    struct SubtitleText: View {
        @DS.Theme private var theme
        
        let text: String
        var layout: DS.TextLayoutStyle?
        var alignment: TextAlignment
        
        init(_ text: String,
             layout: DS.TextLayoutStyle? = nil,
             alignment: TextAlignment = .leading) {
            self.text = text
            self.layout = layout
            self.alignment = alignment
        }
        
        var body: some View {
            Text(text)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(alignment)
                .foregroundColor(theme.colors.textSecondary.primaryColor)
                .apply(layout)
        }
    }
    
    struct BodyText: View {
        @DS.Theme private var theme
        
        let text: String
        var layout: DS.TextLayoutStyle?
        var alignment: TextAlignment
        
        init(_ text: String,
             layout: DS.TextLayoutStyle? = nil,
             alignment: TextAlignment = .leading) {
            self.text = text
            self.layout = layout
            self.alignment = alignment
        }
        
        var body: some View {
            Text(text)
                .font(.body)
                .multilineTextAlignment(alignment)
                .foregroundColor(theme.colors.textPrimary.primaryColor)
                .apply(layout)
        }
    }
    
    struct CaptionText: View {
        @DS.Theme private var theme
        
        let text: String
        var layout: DS.TextLayoutStyle?
        var alignment: TextAlignment
        
        init(_ text: String,
             layout: DS.TextLayoutStyle? = nil,
             alignment: TextAlignment = .leading) {
            self.text = text
            self.layout = layout
            self.alignment = alignment
        }
        
        var body: some View {
            Text(text)
                .font(.caption)
                .multilineTextAlignment(alignment)
                .foregroundColor(theme.colors.textSecondary.primaryColor)
                .apply(layout)
        }
    }
    
    struct FootnoteText: View {
        @DS.Theme private var theme
        
        let text: String
        var layout: DS.TextLayoutStyle?
        var alignment: TextAlignment
        
        init(_ text: String,
             layout: DS.TextLayoutStyle? = nil,
             alignment: TextAlignment = .leading) {
            self.text = text
            self.layout = layout
            self.alignment = alignment
        }
        
        var body: some View {
            Text(text)
                .font(.footnote)
                .multilineTextAlignment(alignment)
                .foregroundColor(theme.colors.textTertiary.primaryColor)
                .apply(layout)
        }
    }
}
