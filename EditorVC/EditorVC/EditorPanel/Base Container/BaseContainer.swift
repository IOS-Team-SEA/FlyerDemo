//
//  BaseContainer.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 11/04/24.
//

import SwiftUI
import IOS_CommonEditor

struct BaseContainer: View {
    
    var baseContentType: EditorUIStates
//    @Binding var didUseMeTapped: Bool
//    @Binding var didGroupTapped: Bool
//    @Binding var didCancelTapped: Bool
    @Binding var thumbImage: UIImage?
    @StateObject var actionStates: ActionStates
    // conflict genrating for jay merge
    @StateObject var exportSettings: ExportSettings
    @State var heightConform : Bool = false
    weak var delegate : ContainerHeightProtocol?
    
    
    var body: some View {
        VStack{
            switch baseContentType {
            case .SelectThumbnail:
                
                VStack{
                    Spacer(minLength: 40)
                    SelectThumbnailView(thumbnailImage: $thumbImage, watchAdsTapped: $actionStates.didWatchAdsTapped, goPremiumTapped: $actionStates.didGetPremiumTapped, isLastSelectedModel: $actionStates.isCurrentModelDeleted, exportSettings: exportSettings).environmentObject(UIStateManager.shared)
                }
                .frame(height: containerHeight + 60 , alignment: .top)
                .cardBorderStyle( lineWidth: 0, padding: 0,  internalPadding: 0, shadow: false )
                    .offset(y:40)
//                .offset(y:30)
            
                
//                .frame(height: containerHeight)
                
                
//                .directionalShadow(edges: [.top, .leading, .trailing])

            case .UseMe:
                Button{
                    actionStates.didUseMeTapped = true
                }label: {
                    Text("Use_Me")
                        .font(.callout)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                }
                .frame(width: 200, height: 50)
                .background(AppStyle.accentColor_SwiftUI)
                .cornerRadius(5)
                .padding()
                
            case .Purchase:
                Button{
//                    if !actionStates.didPurchasedTapped {
                        actionStates.didPurchasedTapped = true
//                    }
                }label: {
//                    if actionStates.didPurchasedTapped{
//                        ProgressView()
//                            .font(.callout)
//                            .foregroundColor(.white)
//                            .frame(width: 150, height: 50)
//                    }
//                    else{
                        Text("Purchase_")
                            .font(.callout)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 50)
//                    }
                }
                .frame(width: 200, height: 50)
                .background(AppStyle.accentColor_SwiftUI)
                .cornerRadius(5)
                .padding()
            
            case .MultipleSelectMode:
                
                VStack{
                    selectionGroupView(selectedItemsArray: $actionStates.multiSelectedItems, unSelectedItemsArray: $actionStates.multiUnSelectItems, addItem: $actionStates.addItemToMultiSelect, removeItem: $actionStates.removeItemFromMultiSelect).frame(height: PANEL_SIZE)
                    

                }.frame(height: PANEL_SIZE)
                
            case .Preview:
                Button{
                    actionStates.didPreviewTapped = false
                }label: {
                    Text("Editor_")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                }
                .frame(width: 200, height: 50)
                .background(AppStyle.accentColor_SwiftUI)
                .cornerRadius(5)
                .padding()
            case .Personalised:
//                Button{
//                    actionStates.didPersonalizeTapped = true
//                }label: {
//                        Text("Personalise_")
//                            .font(.callout)
//                            .foregroundColor(.white)
//                            .frame(width: 150, height: 50)
//                }
//                .frame(width: 200, height: 50)
//                .background(AppStyle.accentColor_SwiftUI)
//                .cornerRadius(5)
//                .padding()
                PrimaryButton(title: "Personalise_",icon: "wand.and.sparkles",isPremium: false,isFullWidth: true) {
                    actionStates.didPersonalizeTapped = true

                }    .padding(.horizontal)
            }
        }
        .frame(height: containerHeight )
            
            .onAppear{
                delegate?.didContainerHeightChanged(height: PANEL_SIZE)
            }
    }
}

public struct PrimaryButton: View {
    let title: String
    let icon: String?
    var isLoading: Bool = false
    var isPremium: Bool = false
    var isFullWidth: Bool = true
    var isDisable: Bool = false
    let action: () -> Void

    public var body: some View {
        DS.PrimaryButton(title,
                         icon: systemIcon,
                         trailingIcon: nil,
                         isLoading: isLoading,
                         isDisabled: isDisable,
                         size: .compact,
                         isFullWidth: isFullWidth,
                         action: action)
        .overlay(alignment: .trailing) {
            if isPremium {
                Image("premiumIcon")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, DS.Spacing.x16)
            }
        }
    }

    private var systemIcon: Image? {
        guard let icon, !icon.isEmpty else { return nil }
        return Image(systemName: icon)
    }
}

struct SecondaryButton: View {
    let title: String
    let icon: String?
    var isPremium: Bool = false
    var isFullWidth: Bool = false
    let action: () -> Void

    var body: some View {
        DS.SecondaryButton(title,
                           icon: systemIcon,
                           trailingIcon: nil,
                           isDisabled: false,
                           size: .compact,
                           isFullWidth: isFullWidth,
                           action: action)
        .overlay(alignment: .trailing) {
            if isPremium {
                Image("premiumIcon")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, DS.Spacing.x16)
            }
        }
    }

    private var systemIcon: Image? {
        guard let icon, !icon.isEmpty else { return nil }
        return Image(systemName: icon)
    }
}


struct SecondaryButtonDisabled: View {
    let title: String
    let icon: String?
    var isPremium : Bool = false
    var isFullWidth: Bool = false

    let action: () -> Void

    var body: some View {

        DS.SecondaryButton(title,
                           icon: systemIcon,
                           trailingIcon: nil,
                           isDisabled: true,
                           size: .compact,
                           isFullWidth: isFullWidth,
                           action: action)
        .overlay(alignment: .trailing) {
            if isPremium {
                Image("premiumIcon")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, DS.Spacing.x16)
            }
        }
        }
    
    private var systemIcon: Image? {
        guard let icon, !icon.isEmpty else { return nil }
        return Image(systemName: icon)
    }
    
}
struct TertiaryButton: View {
    let title: String
    let icon: String?
    var isPremium: Bool = false
    var isFullWidth: Bool = false
    let action: () -> Void

    var body: some View {
        DS.TertiaryButton(title,
                          icon: systemIcon,
                          isDisabled: false,
                          size: .compact,
                          isFullWidth: isFullWidth,
                          action: action)
        .overlay(alignment: .trailing) {
            if isPremium {
                Image("premiumIcon")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, DS.Spacing.x12)
            }
        }
    }

    private var systemIcon: Image? {
        guard let icon, !icon.isEmpty else { return nil }
        return Image(systemName: icon)
    }
}


struct CustomButtonNew: View {
    let title: String
    let icon: String?
    var isPremium: Bool = false
    var isFullWidth: Bool = false
    let action: () -> Void

    var body: some View {
        DS.TertiaryButton(title,
                          icon: systemIcon,
                          isDisabled: false,
                          size: .compact,
                          isFullWidth: isFullWidth,
                          action: action)
        .overlay(alignment: .trailing) {
            if isPremium {
                Image("premiumIcon")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, DS.Spacing.x12)
            }
        }
    }

    private var systemIcon: Image? {
        guard let icon, !icon.isEmpty else { return nil }
        return Image(systemName: icon)
    }
}



struct SecondaryButton2: View {
    let title: String
    let icon: String?
    var isPremium : Bool = false
    var isFullWidth: Bool = false
    var isDisable : Bool = false

    let action: () -> Void

    var body: some View {
        DS.SecondaryButton(title,
                           icon: systemIcon,
                           trailingIcon: nil,
                           isDisabled: isDisable,
                           size: .compact,
                           isFullWidth: isFullWidth,
                           action: action)
        .overlay(alignment: .trailing) {
            if isPremium {
                Image("premiumIcon")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 20, height: 20)
                    .padding(.trailing, DS.Spacing.x16)
            }
        }
    }

    private var systemIcon: Image? {
        guard let icon, !icon.isEmpty else { return nil }
        return Image(systemName: icon)
    }
}


// MARK: - Text Buttons

struct TextBlueButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    var body: some View {
        DS.AccentTextButton(title,
                            icon: systemIcon,
                            action: action)
    }

    private var systemIcon: Image? {
        guard let icon else { return nil }
        return Image(systemName: icon)
    }
}

struct LinkTextButton: View {
    let title: String
    let icon: String?
    let url: URL
    let color: Color

    var body: some View {
        DS.LinkTextButton(title,
                          icon: systemIcon,
                          url: url)
        .tint(color)
    }

    private var systemIcon: Image? {
        guard let icon else { return nil }
        return Image(systemName: icon)
    }
}

struct AccentTextButton: View {
    let title: String
    let icon: String? = nil
    let action: () -> Void

    init(title: String, icon: String? = nil,action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        DS.AccentTextButton(title,
                            icon: systemIcon,
                            action: action)
    }

    private var systemIcon: Image? {
        guard let icon else { return nil }
        return Image(systemName: icon)
    }
}
struct AccentTextButton2: View {
    let title: String
    let icon: String? = nil
    let action: () -> Void

    init(title: String, icon: String? = nil,action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        DS.AccentTextButton(title,
                            icon: systemIcon,
                            action: action)
    }

    private var systemIcon: Image? {
        guard let icon else { return nil }
        return Image(systemName: icon)
    }
}


struct ActionButton: View {
    let title: String
   
    let icon: String?
    let action: () -> Void
    
    var body: some View {
        DS.PrimaryButton(title,
                         icon: systemIcon,
                         trailingIcon: nil,
                         isLoading: false,
                         isDisabled: false,
                         size: .regular,
                         isFullWidth: true,
                         action: action)
    }

    private var systemIcon: Image? {
        guard let icon, !icon.isEmpty else { return nil }
        return Image(systemName: icon)
    }
}




//public struct HoverButton: View {
//    @DS.Theme private var theme
//    let title: String
//    let icon: String?
//    var isLoading : Bool = false
//    var isPremium: Bool = false
//    var isFullWidth: Bool = true
//    var isDisable: Bool = false
////    var miniHeight: Bool = true          // you can ignore this if you’re standardizing at 35/44
//    let action: () -> Void
//   
////    // Tunables
//    private let visualH: CGFloat = 60   // what you SEE
//    private let tapHeight: CGFloat = 60      // what you TAP
//
//    private let labelHeightMini: CGFloat = 22        // your visual label height
////    private let tapHeight: CGFloat = 44              // desired hit target
////    private let visualMiniHeight: CGFloat = 35       // requested visual height
//    
//    public var body: some View {
////        let visualH: CGFloat = miniHeight ? visualMiniHeight : tapHeight
//        // Make the label area exactly 22pt (mini) or 44pt (normal),
//        // then pad vertically to reach visual height.
//        let baseLabelH: CGFloat =  labelHeightMini
//        let vPadForVisual = max(0, (visualH - baseLabelH) / 2)
//        let tapPad = max(0, (tapHeight - visualH) / 2) // expands hit area only
//
//        Button(action: action) {
//            HStack(spacing: 8) {
//                ZStack {
////                    if isLoading {
////                        ProgressView()
////                            .tint(.white)
////                            .frame(maxWidth: 44, maxHeight: visualH)
////                    } else {
//                        
//                        if let icon, !icon.isEmpty {
//                            Label(title, systemImage: icon)
//                                .labelStyle(.titleAndIcon)
//                                .minimumScaleFactor(0.5)
//                                .opacity(isLoading ? 0 : 1)
//
//                        } else {
//                            LText(title)
//                                .minimumScaleFactor(0.5)
//                                .opacity(isLoading ? 0 : 1)
//
//                        }
//                        ProgressView()
//                            .tint(.white)
//                            .frame(maxWidth: 44, maxHeight: visualH)
//                            .opacity(isLoading ? 1 : 0)
//                        
//                        if isPremium {
//                            Image("premiumIcon")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                                .opacity(isLoading ? 0 : 1)
//                            
//                            
//                        }
//                   // }
//                }
//            }
//            .frame(maxWidth: isFullWidth ? .infinity : nil, alignment: .center)
//            .frame(height: baseLabelH)
//            .padding(.vertical, vPadForVisual)    // reach the visual height
//            .padding(.horizontal, DS.Spacing.x16)
//            .background(isDisable
//                        ? theme.colors.border.fill(opacity: 0.25)
//                        : theme.colors.accent.fill())
//            .background(content: {
//                VisualEffectView2()
//                
//            })
//            .foregroundStyle(theme.colors.background.primaryColor)
//            
//            .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
//            .opacity(isDisable ? 0.7 : 0.7)
//            
//            .overlay(
//                // subtle pressed effect
//                RoundedRectangle(cornerRadius: DS.Radius.button_round_60, style: .continuous)
//                    .strokeBorder(theme.colors.background.primaryColor.opacity(0.12))
//            )
//            .contentShape(Rectangle())
//            
//            // better hit testing on the 44pt container below
//        }
//        // Expand tappable area to 44 without altering layout spacing:
//        .padding(.vertical, tapPad)        // increases hit area
//        .contentShape(Rectangle())         // makes added pad tappable
//        .padding(.vertical, -tapPad)       // neutralize layout expansion
//        
//
//        // If you’re on iOS 17+, you can expand the interactive hit area WITHOUT changing layout
//        // by uncommenting this line (keeps outer frame at 35 if you want):
//        // .contentShape(.interaction, Rectangle().inset(by: -4.5))
//    }
//}


extension LinearGradient {
    
    static let accentRedPink: LinearGradient =
    LinearGradient(colors: [.pink, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
}

// MARK: - AppFonts
enum AppFonts {
    static let title = Font.title3.bold()
    static let subtitle = Font.subheadline
    static let caption = Font.caption
    static let captionBold = Font.caption2.bold()
    static let footnoteBold = Font.footnote.bold()
    static let sectionTitle = Font.headline
    static let summaryTitle = Font.title3.bold()
}




// MARK: - AppSpacing
//enum AppSpacing {
//
//    static let cardCornerRadius: CGFloat = 20
//    static let cardPadding: CGFloat = 16
//    static let sectionSpacing: CGFloat = 24
//    static let itemSpacing: CGFloat = 12
//    static let badgePadding: CGFloat = 6
//    static let iconSize: CGFloat = 20
//    static let chartSize: CGFloat = 120
//    static let verticalStackSpacing: CGFloat = 16
//}

// MARK: - AppButtonStyle
struct PrimaryGradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.accentColor, .blue.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct SecondaryFilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.4))
            )
            .foregroundColor(.primary)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}
struct CardBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var borderColor: Color = .gray.opacity(0.3)
    var lineWidth: CGFloat = 1
    var backgroundColor: Color = .white
    var padding: CGFloat = 8
    var internalPadding: CGFloat = 16
    var shadow: Bool = false
    var gradientColor : LinearGradient? = nil

    func body(content: Content) -> some View {
        content
            .padding(internalPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill( gradientColor != nil ?
                           AnyShapeStyle(gradientColor!)
                                    :
                            AnyShapeStyle(backgroundColor)
                         )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
        
            .cornerRadius(cornerRadius)
            .padding(.horizontal,padding)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))

            .shadow(color: shadow ? .black.opacity(0.1) : .clear, radius: shadow ? 6 : 0)
    }
}
// MARK: - View Extensions
extension View {
    func defaultCardStyle(gradient:LinearGradient? = nil) -> some View {
        self.cardBorderStyle(gradientColor:gradient)

        
    }

    
        func cardBorderStyle(
            cornerRadius: CGFloat = AppViewStyle.XlargeCornerRadius,
            borderColor: Color = .gray.opacity(0.3),
            lineWidth: CGFloat = 1,
            backgroundColor: Color = Color.systemBackground,
            padding: CGFloat = 16,
            internalPadding: CGFloat = 16,
            shadow: Bool = false,
            gradientColor : LinearGradient? = nil

        ) -> some View {
            self.modifier(CardBorderModifier(
                cornerRadius: cornerRadius,
                borderColor: borderColor,
                lineWidth: lineWidth,
                backgroundColor: backgroundColor,
                padding: padding,
                 internalPadding: internalPadding,
                shadow: shadow,
                gradientColor: gradientColor
            ))
        }
    
    
    func sectionPadding() -> some View {
        self.padding(.vertical, DS.Spacing.sectionSpacing)
    }

    func capsuleBadgeStyle(color: Color) -> some View {
        self
            .font(AppFonts.captionBold)
            .foregroundColor(.white)
            .padding(.horizontal, DS.Spacing.badgePadding)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(8)
    }

    func cardCornerRadius(_ radius: CGFloat = DS.CornerRadius.x16) -> some View {
        self.cornerRadius(radius, corners: [.topLeft, .topRight])
    }
    
}
extension View {
   func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
       clipShape(RoundedCorner2(radius: radius, corners: corners))
   }
}
struct RoundedCorner2: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


// MARK: - Usage Examples
// .font(AppFonts.title)
// .buttonStyle(PrimaryGradientButtonStyle())
// .defaultCardStyle()
// AppTextStyle.badge("Pending", color: AppColors.badgeYellow)

// MARK: - Usage Examples
// .font(AppFonts.title)
// .buttonStyle(PrimaryGradientButtonStyle())
// .defaultCardStyle()
// AppTextStyle.badge("Pending", color: AppColors.badgeYellow)
struct VisualEffectView3: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style = .prominent

    func makeUIView(context: Context) -> UIVisualEffectView {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return visualEffectView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}


struct DirectionalShadowModifier: ViewModifier {
    var edges: Set<Edge> = [.top, .leading, .trailing]
    var color: Color = .black.opacity(0.6)
    var radius: CGFloat = 10
    var distance: CGFloat = 10
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .overlay(
                // Use a shape overlay that only casts shadows on selected edges
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.clear) // keep same outline
                    // Top
                    .shadow(color: edges.contains(.top) ? color : .clear,
                            radius: radius, x: 0, y: -distance)
                    // Left
                    .shadow(color: edges.contains(.leading) ? color : .clear,
                            radius: radius, x: -distance, y: 0)
                    // Right
                    .shadow(color: edges.contains(.trailing) ? color : .clear,
                            radius: radius, x: distance, y: 0)
                    // Bottom (off by default)
                    .shadow(color: edges.contains(.bottom) ? color : .clear,
                            radius: radius, x: 0, y: distance)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
    }
}

extension View {
    /// Apply a shadow only on specific edges, clipped to a rounded rect.
    func directionalShadow(
        edges: Set<Edge> = [.top, .leading, .trailing],
        color: Color = .black.opacity(0.12),
        radius: CGFloat = 8,
        distance: CGFloat = 3,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(DirectionalShadowModifier(
            edges: edges,
            color: color,
            radius: radius,
            distance: distance,
            cornerRadius: cornerRadius
        ))
    }
}

extension Color {
     
    // MARK: - Text Colors
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)

    // MARK: - Label Colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    // MARK: - Background Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)
    
    // MARK: System Colors
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)

}
