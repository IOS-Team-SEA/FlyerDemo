//
//  DesignSystemDemoView.swift
//  DesignSystem
//
//  Created by Codex on 26/10/25.
//

import SwiftUI

struct DesignSystemDemoView: View {
    @DS.Theme private var theme
//    @StateObject private var paywallViewModel: PremiumViewModel
    @State private var showPremiumSheet = false
    @State private var showSubscriptionSheet = false

    init() {
//        let configuration = PremiumConfiguration(heroTitle: "Get Premium",
//                                                 heroSubtitle: "Unlock all experiences with one membership",
//                                                 plans: DemoPremiumData.plans,
//                                                 features: DemoPremiumData.features,
//                                                 primaryCTA: "Continue",
//                                                 secondaryCTA: "Restore purchases",
//                                                 consumableCTA: "Add to library",
//                                                 disclaimer: "Prices vary by region. Cancel anytime.",
//                                                 experimentKey: "demo_paywall",
//                                                 isEligibleForTrial: true,
//                                                 subscriptionSectionTitle: "Memberships",
//                                                 consumableSectionTitle: "Extras & consumables")
//
//        let dependencies = PremiumEngine.Dependencies(purchaseProvider: StoreKitPurchaseProvider(plans: DemoPremiumData.plans),
//                                                       analytics: DemoAnalyticsTracker(),
//                                                       experiments: DemoExperimentProvider(),
//                                                       eligibility: DemoEligibilityProvider())
//        let engine = PremiumEngine(configuration: configuration, dependencies: dependencies)
//        _paywallViewModel = StateObject(wrappedValue: PremiumViewModel(engine: engine, experiments: dependencies.experiments))
    }

    private var colors: DS.ThemeColors { theme.colors }

    private var styleBinding: Binding<DS.ThemeStyle> {
        Binding(
            get: { theme.style },
            set: { theme.style = $0 }
        )
    }

    private var accentBinding: Binding<Color> {
        Binding(
            get: { theme.colors.accent.primaryColor },
            set: { theme.setAccentGradient(start: $0, end: $0) }
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.x24) {
                header
                themeControls
              //  premiumStatus
                typographyPreview
                buttonPreview
                palettePreview
                paywallPreview
            }
            .padding(DS.Spacing.x16)
        }
        .background { colors.background.fill() }
        .tint(colors.accent.primaryColor)
        .sheet(isPresented: $showSubscriptionSheet) {
//            SubscriptionDetailsView()

        }
        .sheet(isPresented: $showPremiumSheet) {
//                        PremiumPaywallContainer {
//                            showPremiumSheet = false
//                        }
           // CreativePaywallView(viewModel: paywallViewModel)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.x8) {
            DS.TitleText("Gradient Design System", layout: .flexible)
            DS.SubtitleText("All tokens defined through gradients. Use identical start/end colors for solids.")
        }
        .padding()
        .background {
            colors.surface.fill()
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
        }
    }

    private var themeControls: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.x12) {
            Text("Appearance")
                .font(.headline)
                .foregroundColor(colors.textPrimary.primaryColor)

            Picker("Theme", selection: styleBinding) {
                ForEach(DS.ThemeStyle.allCases) { style in
                    Text(style.rawValue.capitalized).tag(style)
                }
            }
            .pickerStyle(.segmented)

            ColorPicker("Accent start/end", selection: accentBinding, supportsOpacity: false)
                .foregroundColor(colors.textPrimary.primaryColor)

            Button("Reset accent") {
                theme.resetAccentGradient()
            }
            .buttonStyle(.borderless)
            .foregroundColor(colors.accent.primaryColor)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            colors.surface.fill()
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
        }
    }

    private var typographyPreview: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.x12) {
            Text("Typography")
                .font(.headline)
                .foregroundColor(colors.textPrimary.primaryColor)

            DS.TitleText("Large and bold for hero moments", layout: .flexible)
            DS.SubtitleText("Subtitle example with semibold weight", layout: .flexible)
            DS.BodyText("Body text sits on the accent gradient system and automatically switches to the right foreground color.", layout: .flexible)
            DS.CaptionText("Caption text – use for helper information.")
            DS.FootnoteText("Footnote text – lighter for metadata.")
        }
        .padding()
        .background {
            colors.surface.fill()
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
        }
    }

    private var buttonPreview: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.x12) {
            Text("Buttons")
                .font(.headline)
                .foregroundColor(colors.textPrimary.primaryColor)

            DS.PrimaryButton("Continue", icon: Image(systemName: "arrow.right"),trailingIcon: Image(systemName: "sparkles")) {}
            DS.PrimaryButton("Loading", icon: Image(systemName: "hourglass"), isLoading: true) {}
            DS.SecondaryButton("Learn more", icon: Image(systemName: "sparkles")) {}
            DS.SecondaryButton("Disabled", icon: Image(systemName: "xmark"), isDisabled: true) {}
            DS.TertiaryButton("Maybe later", icon: Image(systemName: "clock")) {}
            HStack {
                DS.AccentTextButton("Help", icon: Image(systemName: "questionmark.circle")) {}
                if let url = URL(string: "https://developer.apple.com") {
                    DS.LinkTextButton("Docs", icon: Image(systemName: "link"), url: url)
                }
            }
        }
        .padding()
        .background {
            colors.surface.fill()
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
        }
    }

    private var palettePreview: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.x12) {
            Text("Palette")
                .font(.headline)
                .foregroundColor(colors.textPrimary.primaryColor)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DS.Spacing.x16), count: 2),
                      spacing: DS.Spacing.x16) {
                ForEach(colors.all) { entry in
                    VStack(alignment: .leading, spacing: DS.Spacing.x8) {
                        RoundedRectangle(cornerRadius: DS.CornerRadius.x12, style: .continuous)
                            .fill(entry.gradient.linearGradient)
                            .frame(height: 72)
                            .overlay(
                                RoundedRectangle(cornerRadius: DS.CornerRadius.x12, style: .continuous)
                                    .stroke(colors.border.primaryColor.opacity(0.15), lineWidth: DS.LineWidth.x1)
                            )
                        Text(entry.name)
                            .font(.subheadline)
                            .foregroundColor(colors.textPrimary.primaryColor)
                    }
                }
            }
        }
        .padding()
        .background {
            colors.surface.fill()
                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
        }
    }

//    private var premiumStatus: some View {
//        let entitlement = paywallViewModel.state.entitlement
//
//        var iconName = "lock.fill"
//        var primaryText = "Not subscribed"
//        var secondaryText = "Tap Continue below to try the demo purchase flow."
//        var infoText: String?
//        var accentColor = colors.textSecondary.primaryColor
//
//        switch entitlement {
//        case .none:
//            break
//        case let .subscription(plan, renewalDate):
//            iconName = "checkmark.seal.fill"
//            primaryText = "\(plan.title) subscription active"
//            if let renewalDate {
//                let formatted = renewalDate.formatted(date: .abbreviated, time: .omitted)
//                secondaryText = "Renews on \(formatted)"
//            } else {
//                secondaryText = "Renews automatically"
//            }
//            infoText = plan.storeInfo?.displayPrice
//            accentColor = colors.accent.primaryColor
//        case let .lifetime(plan):
//            iconName = "infinity"
//            primaryText = "\(plan.title) unlocked forever"
//            secondaryText = "Enjoy permanent access to all premium features."
//            infoText = plan.storeInfo?.displayPrice
//            accentColor = colors.accent.primaryColor
//        case let .consumable(plan, balance):
//            iconName = "bag.fill.badge.plus"
//            let remaining = balance ?? 0
//            primaryText = "\(plan.title) available"
//            secondaryText = "You currently hold \(remaining) credits."
//            infoText = plan.storeInfo?.displayPrice
//            accentColor = colors.accent.primaryColor
//        }
//
//        return VStack(alignment: .leading, spacing: DS.Spacing.x16) {
//            Text("Premium Status")
//                .font(.headline)
//                .foregroundColor(colors.textPrimary.primaryColor)
//
//            HStack(alignment: .top, spacing: DS.Spacing.x12) {
//                Image(systemName: iconName)
//                    .foregroundColor(accentColor)
//                    .imageScale(.large)
//                    .frame(width: 36, height: 36)
//                    .background {
//                        colors.surface.fill()
//                            .clipShape(Circle())
//                            .overlay(
//                                Circle()
//                                    .stroke(colors.border.primaryColor.opacity(0.3), lineWidth: DS.LineWidth.x1)
//                            )
//                    }
//
//                VStack(alignment: .leading, spacing: DS.Spacing.x4) {
//                    Text(primaryText)
//                        .font(.subheadline.weight(.semibold))
//                        .foregroundColor(colors.textPrimary.primaryColor)
//                    Text(secondaryText)
//                        .font(.footnote)
//                        .foregroundColor(colors.textSecondary.primaryColor)
//                    if let infoText {
//                        DS.CaptionText(infoText)
//                    }
//                }
//            }
//        }
//        .padding()
//        .background {
//            colors.surface.fill()
//                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
//        }
//        .overlay(
//            RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous)
//                .stroke(colors.border.primaryColor.opacity(0.25), lineWidth: DS.LineWidth.x1)
//        )
//    }

    private var paywallPreview: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.x12) {
            Text("Premium Paywall Preview")
                .font(.headline)
                .foregroundColor(colors.textPrimary.primaryColor)

            DS.PrimaryButton("Present Premium Sheet", size: .regular) {
                showPremiumSheet = true
            }
            DS.PrimaryButton("Open Subscription Sheet", size: .regular) {
                showSubscriptionSheet = true
            }

//            CreativePaywallView(viewModel: paywallViewModel)
//                .frame(maxWidth: .infinity)
//                .clipShape(RoundedRectangle(cornerRadius: DS.CornerRadius.x16, style: .continuous))
        }
    }
}
