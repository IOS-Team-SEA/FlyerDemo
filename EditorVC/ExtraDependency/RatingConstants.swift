import SwiftUI
import IOS_CommonUtilSPM

// MARK: - Design System (tokens)

//struct RatingFlowSheet: View {
//    @State private var showSheet = false
//    @State private var contentHeight: CGFloat = 300
//
//    var body: some View {
//        Button("Open Rating Flow") {
//            showSheet.toggle()
//        }
//        .sheet(isPresented: $showSheet) {
//            GeometryReader { proxy in
//                RatingFlowView()
//                    .background(
//                        GeometryReader { innerProxy in
//                            Color.clear
//                                .onAppear { contentHeight = innerProxy.size.height }
//                                .onChange(of: innerProxy.size.height) { newValue in
//                                    withAnimation {
//                                        contentHeight = newValue
//                                    }
//
//                                   
//                                }
//                        }
//                    )
//            }
//            .presentationDetents([.height(contentHeight)])
//            .presentationDragIndicator(.visible)
//        }
//    }
//}


//enum DS {
//    enum Color {
//        static let background = SwiftUI.Color(.systemBackground)
//        static let textPrimary = SwiftUI.Color.primary
//        static let textSecondary = SwiftUI.Color.secondary
//        static let starFilled = SwiftUI.Color.yellow
//        static let starEmpty = SwiftUI.Color.secondary.opacity(0.55)
//        static let actionPrimary = SwiftUI.Color(red: 0/255, green: 24/255, blue: 120/255)     // Deep blue
//        static let actionPrimaryPressed = SwiftUI.Color(red: 0/255, green: 16/255, blue: 90/255)
//        static let actionSecondaryBorder = SwiftUI.Color.secondary.opacity(0.35)
//        static let surfaceAlt = SwiftUI.Color.secondary.opacity(0.12)                           // inputs bg
//        static let overlay = SwiftUI.Color.black.opacity(0.15)
//    }
//
//    enum Space {
//        static let xs: CGFloat = 6
//        static let sm: CGFloat = 10
//        static let md: CGFloat = 16
//        static let lg: CGFloat = 20
//        static let xl: CGFloat = 28
//    }
//
//    enum Radius {
//        static let sm: CGFloat = 8
//        static let md: CGFloat = 12
//        static let lg: CGFloat = 16
//    }
//
//   
//
//   
//}

// MARK: - Variant thresholds

private enum RatingThresholds {
    static let low: ClosedRange<Double> = 0.0...1.0
    static let mid: ClosedRange<Double> = 2.0...3.0
    static let high: ClosedRange<Double> = 4.0...5.0
}

// MARK: - Flow Variant

enum RatingFlowVariant: Equatable {
    case idle
    case needHelp(Double)
    case suggestion(Double)
    case thankYou(Double)

    static func from(_ rating: Double) -> Self {
        switch rating {
        case RatingThresholds.low:  return .needHelp(rating)
        case RatingThresholds.mid:  return .suggestion(rating)
        case RatingThresholds.high: return .thankYou(rating)
        default: return .idle
        }
    }
}

// MARK: - Services (Mock)

//protocol RatingServiceProtocol {
//    func submitFeedback(rating: Double, note: String?) async throws
//}



// MARK: - ViewModel

@MainActor
final class RatingFlowVM: ObservableObject {
    enum SubmitState: Equatable { case idle, loading, success, error(String) }

    @Published var liveRating: Double = 0
    @Published var committedRating: Double = 0
    @Published var note: String = ""
    @Published var submitState: SubmitState = .idle
    @Published var askForAppleReview : Bool = false
    @Published var showRating : Bool = false

    let maxRating: Double = 5
    let step: Double = 1.0
    private let service: RatingServiceProtocol = APIRatingService()

    
    func setCommitted(_ value: Double) {
        committedRating = value
    }

    func dismiss() {
        askForAppleReview = false
        showRating = false
    }
    
    func getAppStoreURL () -> URL? {
       
        return URL(string:App.info.Appstore__AppLink)
    }
    func submit(askAppleReview:Bool = false) {
        guard submitState != .loading else { return }
        submitState = .loading
        let r = committedRating
        let n = note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note

        Task {
            do {
                try await service.submitFeedback(rating: r, note: n)
                submitState = .success
                UserDefaultKeyManager.shared.showFeedback = false

                if askAppleReview {
                    askForAppleReview = true
                } else {
                    dismiss()
                }
            } catch {
                submitState = .error(error.localizedDescription)
            }
        }
    }
}

// MARK: - Reusable: Buttons

//struct PrimaryButton: View {
//    let title: String
//    var isLoading = false
//    var action: () -> Void
//
//    var body: some View {
//        Button {
//            guard !isLoading else { return }
//            action()
//        } label: {
//            ZStack {
//                if isLoading {
//                    ProgressView()
//                        .tint(.white)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else {
//                    Text(title)
//                        .font(DS.Font.button())
//                        .foregroundColor(.white)
//                }
//            }
//            .frame(height: DS.Size.buttonHeight)
//            .frame(maxWidth: .infinity)
//        }
//        .background(DS.Color.actionPrimary)
//        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md))
//        .contentShape(RoundedRectangle(cornerRadius: DS.Radius.md))
//        .pressEffect(background: DS.Color.actionPrimaryPressed)
//    }
//}
//
//struct SecondaryButton: View {
//    let title: String
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(DS.Font.button())
//                .foregroundColor(DS.Color.actionPrimary)
//                .frame(height: DS.Size.buttonHeight)
//                .frame(maxWidth: .infinity)
//        }
//        .background(
//            RoundedRectangle(cornerRadius: DS.Radius.md)
//                .stroke(DS.Color.actionSecondaryBorder, lineWidth: 1)
//        )
//    }
//}

// Small pressed visual feedback
private struct PressEffect: ViewModifier {
    let background: SwiftUI.Color
    @GestureState private var pressed = false
    func body(content: Content) -> some View {
        content
            .background(pressed ? background : .clear)
            .scaleEffect(pressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.1), value: pressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($pressed) { _, s, _ in s = true }
            )
    }
}
private extension View { func pressEffect(background: Color) -> some View { modifier(PressEffect(background: background)) } }

// MARK: - Reusable: Text Editor

struct RoundedTextEditor: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(DS.Fonts.body())
                .frame(minHeight: DS.StarSize.editorMinHeight)
                .padding(DS.Spacing.sixteen)
                .background(Color.tertiarySystemFill, in: RoundedRectangle(cornerRadius: DS.Radius.chip))

            if text.isEmpty {
                Text(placeholder)
                    .font(DS.Fonts.body())
                    .foregroundStyle(DS.Colors.textPrimary)
                    .padding(.horizontal, DS.Spacing.sixteen)
                    .padding(.vertical, DS.Spacing.twenty24)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - Stars

struct StarRow: View {
    @Binding var rating: Double
    let maxRating: Double
    let step: Double
    let starSize: CGFloat
    let spacing: CGFloat
    var onEnd: ((Double) -> Void)? = nil

    private var starCount: Int { Int(maxRating.rounded()) }
    private var totalWidth: CGFloat {
        (CGFloat(starCount) * starSize) + (CGFloat(starCount - 1) * spacing)
    }
    
    var duration : Double = 1.0
    

    var body: some View {
//        ZStack(alignment: .leading) {
//            stars(filled: false)
//            stars(filled: true)
////                .mask(Rectangle().frame(width: fillWidth(for: rating))).offset(x:0,y:0)
////                .mask(
//                                    ZStack(alignment: .leading) {
//                                        Rectangle()
//                                            .frame(width: fillWidth(for: rating))
//                                    }
////                                )
//                                .mask(maskLayer(for: rating))
//                .animation(DS.Anim.subtle, value: rating)
//        }
//        .frame(width: totalWidth, height: starSize, alignment: .leading)
//        .contentShape(Rectangle())
        ZStack(alignment: .leading) {
            // Base (empty) stars
            stars(filled: false)
                .frame(width: totalWidth, height: starSize, alignment: .leading)

            // Filled stars masked by current rating width
            stars(filled: true)
                .frame(width: totalWidth, height: starSize, alignment: .leading)
//                .mask(
//                    ZStack(alignment: .leading) {
//                        Rectangle()
//                            .frame(width: fillWidth(for: rating))
//                    }
//                )
                .mask(maskLayer(for: rating))
        }
        .onAppear() {
            rating = 0
                     withAnimation(.easeInOut(duration: duration)) {
                         rating = maxRating
                     }
                     
                     // Trigger callback and haptic at the end
                     DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                         UIImpactFeedbackGenerator(style: .light).impactOccurred()
                         onEnd?(maxRating)
                     }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + duration * 1.0) {
//                withAnimation {
//                    rating = 1.0
//                
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2.0) {
//                withAnimation {
//                    
//                    rating = 2.0
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + duration * 3.0) {
//                withAnimation {
//                    
//                    rating = 3.0
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + duration * 4.0) {
//                withAnimation {
//                    
//                    rating = 4.0
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + duration * 5.0) {
//                withAnimation {
//                    
//                    rating = 5.0
//                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                    onEnd?(5.0)
//                }
//            }
                   
                
            
        }
        .frame(width: totalWidth, height: starSize, alignment: .leading)
        .contentShape(Rectangle()) // full hit area

        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let x = clamp(Double(value.location.x), 0, Double(totalWidth))
                    let exact = (x / Double(totalWidth)) * maxRating
                    rating = clamp(exact, 0, maxRating)
                }
                .onEnded { value in
                    let x = clamp(Double(value.location.x), 0, Double(totalWidth))
                    let exact = (x / Double(totalWidth)) * maxRating
                    let snapped = snap(exact, to: step, within: 0...maxRating)
                    rating = snapped
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onEnd?(snapped) // 1, 2.5, 4, etc
                }
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Rating")
        .accessibilityValue("\(rating, format: .number.precision(.fractionLength(1))) out of \(Int(maxRating))")
    }

    @ViewBuilder
    private func stars(filled: Bool) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<starCount, id: \.self) { _ in
                Image(systemName: filled ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: starSize, height: starSize)
                    .foregroundStyle(filled ? DS.Colors.starFilled : DS.Colors.starEmpty)
                
            }
        }
    }

    private func fillWidth(for rating: Double) -> CGFloat {
        CGFloat(rating / maxRating) * totalWidth
    }

    private func snap(_ value: Double, to step: Double, within range: ClosedRange<Double>) -> Double {
        let snapped = (value / step).rounded(.up) * step
        return min(max(snapped, range.lowerBound), range.upperBound)
    }
    private func clamp<T: Comparable>(_ v: T, _ lo: T, _ hi: T) -> T { min(max(v, lo), hi) }
    private func maskLayer(for rating: Double) -> some View {
        // Percentage of total width based on rating
        let percent = rating / maxRating
        let fillWidth = CGFloat(percent) * totalWidth

        return GeometryReader { geo in
            let centerX = geo.size.width / 2
            Rectangle()
                .frame(width: fillWidth, height: geo.size.height)
                .offset(x: 0, y: 0)
        }
    }
}

// MARK: - Rating Flow View
struct RatingFlowView: View {
    @EnvironmentObject  var vm : RatingFlowVM
    @Environment(\.openURL) var openURL
    // NEW: A/B group selector (flip to .groupB for experiment)
    private let abGroup: ABGroup = .groupA

    private var variant: RatingFlowVariant {
        vm.committedRating == 0 ? .idle : .from(vm.committedRating)
    }

    var body: some View {
        VStack(spacing: DS.Spacing.lg) {
            Color.white.frame(height:1)
            StarRow(
                rating: $vm.liveRating,
                maxRating: vm.maxRating,
                step: vm.step,
                starSize: variant == .idle ? DS.StarSize.star2 : DS.StarSize.star,
                spacing: DS.StarSize.starSpacing
            ) { final in
                withAnimation(DS.Anim.snap) { vm.setCommitted(final) }
            }
            .padding(.top, DS.StarSize.topPadding)

            content(for: variant)
        }
        .padding(.horizontal, DS.StarSize.sheetSidePadding)
        .padding(.bottom, DS.Spacing.lg)
        .background(Color.systemBackground)
        .animation(DS.Anim.snap, value: variant)
        .overlay(loadingOverlay, alignment: .center)
        .alert(isPresented: .constant(isError)) {
            Alert(title: Text("Something went wrong"),
                  message: Text(errorMessage),
                  dismissButton: .default(Text("OK")) { vm.submitState = .idle })
        }
        .sheet(isPresented: $vm.askForAppleReview) {
            VStack {
                VStack {
                    Text(RatingCopy.reviewSheetTitle(abGroup)) // A/B
                        .font(DS.Fonts.title())
                        .multilineTextAlignment(.center)
                }
                .frame(height: 66)

                Text(RatingCopy.reviewSheetBody(abGroup)) // A/B
                    .font(DS.Fonts.body())
                    .foregroundColor(DS.Colors.textSecondary)
                    .multilineTextAlignment(.center)

                HStack {
                    TertiaryButton(
                        title: RatingCopy.reviewSheetLeft(abGroup), // A/B
                        icon: nil
                        
                    ) {
                        vm.dismiss()
                    }

                    PrimaryButton(
                        title: RatingCopy.reviewSheetRight(abGroup), // A/B
                        icon: nil
                    ) {
                        if let url = vm.getAppStoreURL() {
                            openURL(url)
                            vm.dismiss()
                        }
                       
                        
                    }
                }
                .padding()
            }
            .presentationDetents([.height(250)])
        }
    }

    // MARK: Variant Content

    @ViewBuilder
    private func content(for variant: RatingFlowVariant) -> some View {
        switch variant {
        case .idle:
            VStack(spacing: DS.Spacing.xs) {
                Text(RatingCopy.idleTitle(abGroup))        // A/B
                    .font(DS.Fonts.headline())
                    .multilineTextAlignment(.center)

                Text(RatingCopy.idleSubtitle(abGroup))     // A/B
                    .font(DS.Fonts.body())
                    .foregroundColor(DS.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, DS.Spacing.sm)

        case .needHelp(_):
            VStack(alignment: .center, spacing: DS.Spacing.sm) {
                Text(RatingCopy.helpTitle(abGroup))        // A/B
                    .font(DS.Fonts.headline())
                    .minimumScaleFactor(0.5)
                Text(RatingCopy.helpSubtitle(abGroup))     // A/B
                    .font(DS.Fonts.body())
                    .foregroundColor(DS.Colors.textSecondary)
                    .minimumScaleFactor(0.5)
                RoundedTextEditor(text: $vm.note, placeholder: "Write_Something_Here".translate())

                PrimaryButton(
                    title: RatingCopy.helpPrimary(abGroup), // A/B
                    icon: nil,
                    isLoading: isLoading
                ) { vm.submit() }
            }

        case .suggestion(_):
            VStack(alignment: .center, spacing: DS.Spacing.sm) {
                Text(RatingCopy.suggTitle(abGroup))        // A/B
                    .font(DS.Fonts.headline())
                    .minimumScaleFactor(0.5)
                Text(RatingCopy.suggSubtitle(abGroup))     // A/B
                    .font(DS.Fonts.body())
                    .minimumScaleFactor(0.5)
                    .foregroundColor(DS.Colors.textSecondary)

                RoundedTextEditor(text: $vm.note, placeholder: "Write_Something_Here".translate())

                PrimaryButton(
                    title: RatingCopy.suggPrimary(abGroup), // A/B
                    icon: nil,
                    isLoading: isLoading
                ) { vm.submit() }
            }

        case .thankYou:
            VStack(alignment: .center, spacing: DS.Spacing.sm) {
                Text(RatingCopy.thanksTitle(abGroup))      // A/B
                    .font(DS.Fonts.title())
                    .minimumScaleFactor(0.5)
                Text(RatingCopy.thanksBody(abGroup))       // A/B
                    .font(DS.Fonts.body())
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(DS.Colors.textSecondary)

                PrimaryButton(
                    title: RatingCopy.thanksPrimary(abGroup), // A/B
                    icon: nil,
                    isLoading: isLoading
                ) { vm.submit(askAppleReview: true) }
            }
        }
    }

    // MARK: Loading / Error (unchanged)

    private var isLoading: Bool { if case .loading = vm.submitState { return true } else { return false } }
    private var isError: Bool { if case .error = vm.submitState { return true } else { return false } }
    private var errorMessage: String { if case .error(let m) = vm.submitState { return m } else { return "" } }

    @ViewBuilder
    private var loadingOverlay: some View {
        if isLoading {
            ZStack {
                ProgressView().scaleEffect(1.15)
            }
            .transition(.opacity)
        }
    }
}
//struct RatingFlowView: View {
//    @StateObject private var vm = RatingFlowVM()
//    private var variant: RatingFlowVariant {
//        vm.committedRating == 0 ? .idle : .from(vm.committedRating)
//    }
//
//    var body: some View {
//        VStack(spacing: DS.Spacing.lg) {
//            Color.white.frame(height:1)
//            StarRow(
//                rating: $vm.liveRating,
//                maxRating: vm.maxRating,
//                step: vm.step,
//                starSize: variant == .idle ? DS.StarSize.star2 : DS.StarSize.star,
//                spacing: DS.StarSize.starSpacing
//            ) { final in
//                withAnimation(DS.Anim.snap) { vm.setCommitted(final) }
//            }
//            .padding(.top, DS.StarSize.topPadding)
//
//            content(for: variant)
//
//        }
//        .padding(.horizontal, DS.StarSize.sheetSidePadding)
//        .padding(.bottom, DS.Spacing.lg)
//        .background(Color.systemBackground)
//        .animation(DS.Anim.snap, value: variant)
//        .overlay(loadingOverlay, alignment: .center)
//        .alert(isPresented: .constant(isError)) {
//            Alert(title: Text("Something went wrong"),
//                  message: Text(errorMessage),
//                  dismissButton: .default(Text("OK")) { vm.submitState = .idle })
//        }
//        .sheet(isPresented: $vm.askForAppleReview) {
//            VStack {
//                VStack {
//                    Text("Thank You!")
//                        .font(DS.Fonts.title())
//                        .multilineTextAlignment(.center)
//                }.frame(height: 66)
//                Text("A Quick Review On Appstore would help us reach more users like you.")
//                    .font(DS.Fonts.body())
//                    .foregroundColor(DS.Colors.textSecondary)
//                    .multilineTextAlignment(.center)
//                HStack {
//                    PrimaryButton(title: "Not Now",icon: nil , isLoading: isLoading) { vm.submit() }
//                    SecondaryButton(title: "Write Review ( 1min )",icon: nil) { vm.submit() }
//
//                }.padding()
//            }.presentationDetents([.height(250)])
//        }
//    }
//
//    // MARK: Variant Content
//
//    @ViewBuilder
//    private func content(for variant: RatingFlowVariant) -> some View {
//        switch variant {
//        case .idle:
//            VStack(spacing: DS.Spacing.xs) {
//                Text("We tried to make this app helpful and easy to use.")
//                    .font(DS.Fonts.headline())
//                    .multilineTextAlignment(.center)
//                Text("Please select how to feel.")
//                    .font(DS.Fonts.body())
//                    .foregroundColor(DS.Colors.textSecondary)
//                    .multilineTextAlignment(.center)
//            }
//            .padding(.top, DS.Spacing.sm)
//
//        case .needHelp(let r):
//            VStack(alignment: .center, spacing: DS.Spacing.sm) {
//                Text("Need Help?")
//                    .font(DS.Fonts.headline())
//                Text("Don't worry, we are here to help you.")
//                    .font(DS.Fonts.body())
//                    .foregroundColor(DS.Colors.textSecondary)
//                RoundedTextEditor(text: $vm.note, placeholder: "Write Something Here")
//                PrimaryButton(title: "Ask for Help", icon: nil , isLoading: isLoading) { vm.submit() }
//            }
//
//        case .suggestion(let r):
//            VStack(alignment: .center, spacing: DS.Spacing.sm) {
//                Text("Give Suggestion")
//                    .font(DS.Fonts.headline())
//                Text("Or maybe, ask for a new feature.")
//                    .font(DS.Fonts.body())
//                    .foregroundColor(DS.Colors.textSecondary)
//                RoundedTextEditor(text: $vm.note, placeholder: "Write Something Here")
//                PrimaryButton(title: "Share your Suggestion",icon: nil ,isLoading: isLoading) { vm.submit() }
//            }
//
//        case .thankYou:
//            VStack(alignment: .center, spacing: DS.Spacing.sm) {
//                Text("Thank you. This means a Lot!")
//                    .font(DS.Fonts.title())
//                Text("""
//                     We strive to make this app better
//                     Can you please take a min to help other users
//                     And tell about your CUT OUT
//                     """)
//                    .font(DS.Fonts.body())
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(DS.Colors.textSecondary)
//                PrimaryButton(title: "Submit",icon: nil , isLoading: isLoading) { vm.submit() }
//            }
//        }
//    }
//
//    // MARK: Loading / Error
//
//    private var isLoading: Bool { if case .loading = vm.submitState { return true } else { return false } }
//    private var isError: Bool { if case .error = vm.submitState { return true } else { return false } }
//    private var errorMessage: String { if case .error(let m) = vm.submitState { return m } else { return "" } }
//
//    @ViewBuilder
//    private var loadingOverlay: some View {
//        if isLoading {
//            ZStack {
////                DS.Color.overlay.ignoresSafeArea()
//                ProgressView().scaleEffect(1.15)
//            }
//            .transition(.opacity)
//        }
//    }
//}

// MARK: - Detent Sheet (Auto-height)

//struct RatingFlowSheet: View {
//    @State private var show = false
//    @State private var measuredHeight: CGFloat = 340
//
//    var body: some View {
//        Button("Open Rating Flow") { show = true }
//            .sheet(isPresented: $show) {
////                if #available(iOS 17.0, *) {
//                    // Automatically fits to content with smooth updates
//                    RatingFlowAutoSizedContainer()
////                        .presentationDragIndicator(.visible)
////                        .presentationSizing(.fitted)
////                } else {
////                    // iOS 16 fallback: measure and set explicit height
////                    RatingFlowMeasuredContainer(height: $measuredHeight)
////                        .presentationDetents([.height(measuredHeight)])
////                        .presentationDragIndicator(.visible)
////                }
//            }
//    }
//}

//// iOS 17 – simplest path
//@available(iOS 17.0, *)
//private struct RatingFlowAutoSizedContainer: View {
//    var body: some View {
//        RatingFlowView()
// iOS 17 – simplest path
//@available(iOS 17.0, *)
//struct RatingFlowAutoSizedContainer: View {
//    var body: some View {
//        RatingFlowView()
//            // keep a little breathing room so fitted height is clean
//            .padding(.horizontal, 20)
//            .padding(.vertical, 16)
//            // key line: sheet will grow/shrink to intrinsic content height
//            .presentationSizing(.fitted)
//            .presentationDragIndicator(.visible)
//    }
//}

import SwiftUI

// MARK: - Public Container

struct AutoSizedSheetContainer<Content: View>: View {
    private let maxHeightRatio: CGFloat
    private let minHeight: CGFloat
    private let padding: EdgeInsets
    private let dragIndicator: Visibility
    @ViewBuilder private let content: () -> Content

    // measured-mode state (iOS 15/16 fallback)
    @State private var contentHeight: CGFloat = 320

    init(
        maxHeightRatio: CGFloat = 0.92,      // 92% of screen height max
        minHeight: CGFloat = 180,            // never smaller than this
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20),
        dragIndicator: Visibility = .visible,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.maxHeightRatio = maxHeightRatio
        self.minHeight = minHeight
        self.padding = padding
        self.dragIndicator = dragIndicator
        self.content = content
    }

    var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                // iOS 17+: intrinsic fitted height
                content()
                    .padding(padding)
                    .presentationSizing(.fitted)
                    .presentationDragIndicator(dragIndicator)
            } else {
                // iOS 15–16: measure content and drive a height detent
                measuredBody
                    .presentationDetents([.height(contentHeight)])
                    .presentationDragIndicator(dragIndicator)
            }
        }
    }

    // MARK: - Measured mode (iOS 15–16)

    private var measuredBody: some View {
        content()
            .padding(padding)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: _SheetHeightKey.self, value: proxy.size.height)
                }
            )
            .onPreferenceChange(_SheetHeightKey.self) { h in
                let screenMax = UIScreen.main.bounds.height * maxHeightRatio
                let clamped = max(min(h, screenMax), minHeight)
//                withAnimation(.easeInOut(duration: 0.22)) {
                    contentHeight = clamped
//                }
            }
    }
}

// MARK: - PreferenceKey

private struct _SheetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

import SwiftUI

struct AutoSizedSheetContainerV2<Content: View>: View {
    private let maxHeightRatio: CGFloat
    private let minHeight: CGFloat
    private let padding: EdgeInsets
    private let dragIndicator: Visibility
    @ViewBuilder private let content: () -> Content

    @State private var rawHeight: CGFloat = 320
    @State private var animatedHeight: CGFloat = 320

    init(
        maxHeightRatio: CGFloat = 0.92,
        minHeight: CGFloat = 180,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20),
        dragIndicator: Visibility = .visible,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.maxHeightRatio = maxHeightRatio
        self.minHeight = minHeight
        self.padding = padding
        self.dragIndicator = dragIndicator
        self.content = content
    }

    var body: some View {
        Group {
            if #available(iOS 18.0, *) {
                content()
                    .padding(padding)
                    .presentationSizing(.fitted)
                    .presentationDragIndicator(dragIndicator)
            } else {
                measuredBody
                    .presentationDetents([.height(animatedHeight)])
                    .presentationDragIndicator(dragIndicator)
            }
        }
    }

    private var measuredBody: some View {
        content()
            .padding(padding)
            .background(
                SizeReader { h in
                    updateHeight(to: h)              // pass 1
                    DispatchQueue.main.async {       // pass 2: next frame
                        updateHeight(to: h)
                    }
                }
            )
    }

    private func updateHeight(to measured: CGFloat) {
        let screenMax = UIScreen.main.bounds.height * maxHeightRatio
        let clamped = max(min(measured, screenMax), minHeight)
        rawHeight = clamped
        withAnimation(.easeInOut(duration: 0.24)) {
            animatedHeight = clamped
        }
    }
}

private struct SizeReader: View {
    var onChange: (CGFloat) -> Void
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: _SheetHeightKey.self, value: proxy.size.height)
        }
        .onPreferenceChange(_SheetHeightKey.self, perform: onChange)
        .allowsHitTesting(false)
    }
}

//private struct _SheetHeightKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}


enum ABGroup { case groupA, groupB }

// MARK: - Copy Bank (A/B)
enum RatingCopy {
    // Idle
    static func idleTitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "We_tried_to_make_this_app_helpful_and_easy_to_use._".translate()
        case .groupB: return "Enjoying_the_app?_".translate()
        }
    }
    static func idleSubtitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Please_select_how_you_feel".translate()
        case .groupB: return "Rate_your_experience—your_feedback_helps._".translate()
        }
    }

    // Need Help
    static func helpTitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Need_Help?_".translate()
        case .groupB: return "Sorry_it_wasn’t_smooth_".translate()
        }
    }
    static func helpSubtitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Dont_worry_we_are_here_to_help_you".translate()
        case .groupB: return "Tell_us_what_went_wrong—we’ll_fix_it._".translate()
        }
    }
    static func helpPrimary(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Ask_for_Help".translate()
        case .groupB: return "Send_Issue_".translate()
        }
    }

    // Suggestion
    static func suggTitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Got_suggestions".translate()
        case .groupB: return "Got_ideas?_We’re_listening_".translate()
        }
    }
    static func suggSubtitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Or_maybe,_ask_for_a_new_feature._".translate()
        case .groupB: return "Request_a_feature_or_improvement._".translate()
        }
    }
    static func suggPrimary(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Share_your_Suggestion_".translate()
        case .groupB: return "Share_Suggestion_".translate()
        }
    }

    // Thank You
    static func thanksTitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Thank_you._This_means_a_Lot!_".translate()
        case .groupB: return "You’ve_made_our_day!_".translate()
        }
    }
    static func thanksBody(_ g: ABGroup) -> String {
        switch g {
        case .groupA:
            return "We_strive_to_make_this_app_better_".translate()
        case .groupB:
            return "Love_your_design?_A_quick_star_on_the_App_Store_helps_us_reach_more_creators_like_you._".translate()
        }
    }
    static func thanksPrimary(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Submit_".translate()
        case .groupB: return "Submit_Feedback_".translate()
        }
    }

    // Review Sheet
    static func reviewSheetTitle(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Thank_You".translate()
        case .groupB: return "Thanks_for_the_love!_".translate()
        }
    }
    static func reviewSheetBody(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "A_Quick_Review_On_Appstore_would_help_us_reach_more_users_like_you._".translate()
        case .groupB: return "Mind_dropping_a_quick_star_on_the_App_Store?_It_takes_seconds_and_really_helps._".translate()
        }
    }
    static func reviewSheetLeft(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Not_Now_".translate()
        case .groupB: return "Not_now_".translate()
        }
    }
    static func reviewSheetRight(_ g: ABGroup) -> String {
        switch g {
        case .groupA: return "Write_Review_(_1min_)_".translate()
        case .groupB: return "Rate_on_App_Store_".translate()
        }
    }
}
//enum RatingCopy {
//    // Idle
//    static func idleTitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "We tried to make this app helpful and easy to use."
//        case .groupB: return "Enjoying the app?"
//        }
//    }
//    static func idleSubtitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Please select how to feel."
//        case .groupB: return "Rate your experience—your feedback helps."
//        }
//    }
//
//    // Need Help
//    static func helpTitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Need Help?"
//        case .groupB: return "Sorry it wasn’t smooth"
//        }
//    }
//    static func helpSubtitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Don't worry, we are here to help you."
//        case .groupB: return "Tell us what went wrong—we’ll fix it."
//        }
//    }
//    static func helpPrimary(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Ask for Help"
//        case .groupB: return "Send Issue"
//        }
//    }
//
//    // Suggestion
//    static func suggTitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Give Suggestion"
//        case .groupB: return "Got ideas? We’re listening 👂"
//        }
//    }
//    static func suggSubtitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Or maybe, ask for a new feature."
//        case .groupB: return "Request a feature or improvement."
//        }
//    }
//    static func suggPrimary(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Share your Suggestion"
//        case .groupB: return "Share Suggestion"
//        }
//    }
//
//    // Thank You
//    static func thanksTitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Thank you. This means a Lot!"
//        case .groupB: return "You’ve made our day! 🎉"
//        }
//    }
//    static func thanksBody(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA:
//            return """
//            We strive to make this app better
//            Can you please take a min to help other users
//            And tell about your CUT OUT
//            """
//        case .groupB:
//            return "Love your design? A quick star on the App Store helps us reach more creators like you."
//        }
//    }
//    static func thanksPrimary(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Submit"
//        case .groupB: return "Submit Feedback"
//        }
//    }
//
//    // Review Sheet
//    static func reviewSheetTitle(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Thank You!"
//        case .groupB: return "Thanks for the love! 🌟"
//        }
//    }
//    static func reviewSheetBody(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "A Quick Review On Appstore would help us reach more users like you."
//        case .groupB: return "Mind dropping a quick star on the App Store? It takes seconds and really helps."
//        }
//    }
//    static func reviewSheetLeft(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Not Now"
//        case .groupB: return "Not now"
//        }
//    }
//    static func reviewSheetRight(_ g: ABGroup) -> String {
//        switch g {
//        case .groupA: return "Write Review ( 1min )"
//        case .groupB: return "Rate on App Store"
//        }
//    }
//}


import SwiftUI

@available(iOS 16.0, *)
struct FixedDetentSheetContainer<Content: View>: View {
    @Binding var variant: RatingFlowVariant
    let spec: FixedDetentSpec
    @ViewBuilder var content: () -> Content

    @State private var selectedDetent: PresentationDetent = .height(300)

    var body: some View {
        let target = detent(for: variant)

        content()
            .ignoresSafeArea(.keyboard, edges: .bottom)  // keyboard shouldn’t force .large
            .onAppear {
                selectedDetent = target
            }
            .onChange(of: variant) { v in
                withAnimation(.easeInOut(duration: 0.24)) {
                    selectedDetent = detent(for: v)
                }
            }
        
            .presentationDetents([detent(for: .idle),
                                  detent(for: .needHelp(1)),
                                  detent(for: .suggestion(3)),
                                   detent(for: .thankYou(2)),
                                   .large], // allow user to drag up if they want
                                  selection: $selectedDetent)
            .presentationDragIndicator(.visible)
        
    }

    private func detent(for v: RatingFlowVariant) -> PresentationDetent {
        let screenH = UIScreen.main.bounds.height
        let clamped: CGFloat
        switch v {
        case .idle:
            clamped = spec.clamped(spec.idle, screenH: screenH)
        case .needHelp:
            clamped = spec.clamped(spec.help, screenH: screenH)
        case .suggestion:
            clamped = spec.clamped(spec.suggestion, screenH: screenH)
        case .thankYou:
            clamped = spec.clamped(spec.thankYou, screenH: screenH)
        }
        return .height(clamped)
    }
}

/// Hardcoded heights for each variant (+ safety clamps)
struct FixedDetentSpec {
    var idle: CGFloat
    var help: CGFloat
    var suggestion: CGFloat
    var thankYou: CGFloat
    var minHeight: CGFloat = 220
    var maxHeightRatio: CGFloat = 0.92

    func clamped(_ h: CGFloat, screenH: CGFloat) -> CGFloat {
        max(min(h, screenH * maxHeightRatio), minHeight)
    }

    /// Example defaults — tune to match your Figma exactly
    static let defaults = FixedDetentSpec(
        idle: 260,        // stars + 2 lines text
        help: 420,        // + TextEditor + primary btn
        suggestion: 420,  // same as help
        thankYou: 340     // title + body + primary btn
    )
}

protocol RatingManagerKey{
    var appOpenCount: Int {get set}
    var showSharePageCount: Int {get set}
    var timeToShowRating: Bool {get set}
    var showFeedback: Bool {get set}
}

protocol OnboardingPageKey{
    var splashScreen : Bool {get set}
    var onboardingPage : Bool {get set}
    var surveyPage : Bool {get set}
    var premiumPage : Bool {get set}
}

class UserDefaultKeyManager: RatingManagerKey, OnboardingPageKey{
    
    static let shared = UserDefaultKeyManager()
    
    @AppStorage("splashScreen") var splashScreen: Bool = false
    @AppStorage("onboardingPage") var onboardingPage: Bool = false
    @AppStorage("surveyPage") var surveyPage: Bool = false
    @AppStorage("premiumPage") var premiumPage: Bool = false
    @AppStorage("appOpenCount") var appOpenCount: Int = 0
    @AppStorage("showSharePageCount") var showSharePageCount: Int = 0
    @AppStorage("timeToShowRating") var timeToShowRating: Bool = false
    @AppStorage("showFeedback") var showFeedback: Bool = false
    @AppStorage("appFlowFinished") var appFlowFinished : Bool = false
    @AppStorage("oldAppVersion") static var oldAppVersion : String = "1.0.0"
    @AppStorage("isShowWhatsNewActive") static var isShowWhatsNewActive : Bool = false
    @AppStorage("birthdayCardDismissed") var birthdayCardDismissed: Bool = false
    @AppStorage("anniversaryCardDismissed") var anniversaryCardDismissed: Bool = false
    @AppStorage("eventCardDismissed") var eventCardDismissed: Bool = false
    @AppStorage("rsvpFeedback") var rsvpFeedback: Bool = false
    
    func setOldAppVersion(_ value : String){
        UserDefaultKeyManager.oldAppVersion = value
    }
    
    func setIsShowWhatsNewActive(_ value : Bool){
        UserDefaultKeyManager.isShowWhatsNewActive = value
    }

   
    func updateAppOpenCount(){
            appOpenCount += 1
    }
    
    func updateShowSharePageCount(){
            showSharePageCount += 1
    }
   
}
