import SwiftUI
import StoreKit
import IOS_LoaderSPM
import IOS_CommonUtilSPM


struct IAPView: View {
//    @Injected var analyticsLogger : AnalyticsLogger
    var onConsumablePurchased: ((Bool) -> Void)?
    @Environment(\.presentationMode) var presentationMode
    @State var isPresented : Bool = false
    //@EnvironmentObject var iapViewModel: uiStateManager.iapVM
    @State private var selectedProductId: String? = nil
    @State private var activeAlert: ActiveAlert?
    @State private var count: Int = 0
     private var isSingleTemplateSelectedOrNot: Bool = false
    @State  var consumableImage : Image?
    @State var normalThumbImage : Image? = Image("SubImage")
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    @Environment(\.openURL) var openURL
    @EnvironmentObject var uiStateManager: UIStateManager
    var defaultProductType : DefaultProductType = .year
    @State var showCrossButton : Bool = false
    @State var showOfferCard : Bool = false
    
    @StateObject var iapViewModel : IAPViewModel = Injection.shared.inject(type: IAPViewModel.self)!
    
    
    
//    init() {
//        uiStateManager.iapVM.singleTemplateProduct?.cellImage =
//    }
//
    
    init(onConsumablePurchased: ( (Bool) -> Void)? = nil,  isSingleTemplateSelectedOrNot: Bool = false, consumableImage: Image? = nil) {
        self.onConsumablePurchased = onConsumablePurchased
        self.isSingleTemplateSelectedOrNot = isSingleTemplateSelectedOrNot
        if let consumableImage = consumableImage{
            _consumableImage = State(initialValue: consumableImage)
        }
        defaultProductType = isSingleTemplateSelectedOrNot ? .onetime : .year
    }
    
    enum ActiveAlert: Identifiable {
        case error(String)
        case noItemsFound(String)

        var id: String {
            switch self {
            case .error(let message): return message
            case .noItemsFound(let message): return message
            }
        }
    }

    var attributedText: AttributedString {
        var attributedString = AttributedString("By_continuing_you_agree_to_the_".translate())
        var termsAndConditions = AttributedString("Terms & Conditions")
        termsAndConditions.foregroundColor = .blue
        attributedString.append(termsAndConditions)
        attributedString.append(AttributedString("."))
        return attributedString
    }

    var attributedPremiumText: AttributedString {
        var attributedString = AttributedString("Go_Premium_and_".translate())
        var standOut = AttributedString("Stand_Out_".translate())
        standOut.foregroundColor = AppStyle.accentColorUIKit
        let lastString = AttributedString("with_Premium_Content".translate())
        attributedString.append(standOut)
        attributedString.append(lastString)
        return attributedString
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    // Header
                    HStack {
                        Image("PremiumSubscription").resizable().renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .padding(.bottom, 10)
                            .foregroundStyle(Color.accentColor)
                        
                        Image("Partyza")
                            .resizable()
                            .frame(width: 90, height: 40)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            uiStateManager.premiumPageDismissed = true
//                            analyticsLogger.logPremiumInteraction(action: .dismissed)
                            //                        onConsumablePurchased?(false)
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(AppStyle.accentColor_SwiftUI)
                                .padding()
                        }.opacity(showCrossButton ? 1.0 : 0)
                    }
                    .padding(.horizontal)
                    
                    // Title
                    VStack {
                        Text(attributedPremiumText)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                    }.frame(height: 100)
                    
                    if !uiStateManager.isPremium {
                        ScrollView {
                            VStack(spacing: 10) {
                                if  iapViewModel.productLoadingStatus == .productsAvailable {
                                    
                                    ForEach(iapViewModel.availableProducts, id: \.id) { product in
                                        if product.type.rawValue == "Consumable" && isSingleTemplateSelectedOrNot {
                                            SubscriptionOptionView(iaProduct: iapViewModel.singleTemplateProduct!,
                                                                   price: product.displayPrice,
                                                                   selectedProductId: $selectedProductId,
                                                                   product: product,
                                                                   purchasedProduct: $iapViewModel.purchasedProducts,
                                                                   consumableImage : $consumableImage)
                                            .onAppear {
                                                if defaultProductType == .onetime {
                                                    selectedProductId = product.id
                                                    iapViewModel.currentSelectedProduct = product
                                                }
                                            }
                                            .frame(height: 130)
                                            .onTapGesture {
                                                impactFeedback.impactOccurred()
                                                selectedProductId = product.id
                                                iapViewModel.currentSelectedProduct = product
                                            }
                                        } else if product.subscription?.subscriptionPeriod.unit == .month {
                                            SubscriptionOptionView(iaProduct: iapViewModel.monthlyTemplateProduct!,
                                                                   price: product.displayPrice,
                                                                   selectedProductId: $selectedProductId,
                                                                   product: product,
                                                                   purchasedProduct: $iapViewModel.purchasedProducts,
                                                                   consumableImage : $normalThumbImage)
                                            .onAppear {
                                                if defaultProductType == .month {
                                                    selectedProductId = product.id
                                                    iapViewModel.currentSelectedProduct = product
                                                }
                                            }
                                            .frame(height: 130)
                                            .onTapGesture {
                                                impactFeedback.impactOccurred()
                                                selectedProductId = product.id
                                                iapViewModel.currentSelectedProduct = product
                                            }
                                        } else if product.subscription?.subscriptionPeriod.unit == .year {
                                            SubscriptionOptionView(iaProduct: iapViewModel.yearlyTemplateProduct!,
                                                                   price: product.displayPrice,
                                                                   selectedProductId: $selectedProductId,
                                                                   product: product,
                                                                   purchasedProduct: $iapViewModel.purchasedProducts,
                                                                   consumableImage : $normalThumbImage)
                                            .onAppear {
                                                if defaultProductType == .year {
                                                    selectedProductId = product.id
                                                    iapViewModel.currentSelectedProduct = product
                                                }
                                            }
                                            .frame(height: 130)
                                            .onTapGesture {
                                                impactFeedback.impactOccurred()
                                                selectedProductId = product.id
                                                iapViewModel.currentSelectedProduct = product
                                            }
                                        }
                                    }
                                } else {
//                                    ForEach(0..<2, id: \.self) { _ in
//                                        ShimmerEffectBox()
//                                            .frame(height: 120)
//                                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 5, y: 5)
//                                            .cornerRadius(10)
//                                            .padding(.horizontal)
//                                    }
                                }
                            }.padding()
                            
                        }
                        
                        // Subscription Info
                        if let currentSelectedProduct = iapViewModel.currentSelectedProduct,
                           currentSelectedProduct.type.rawValue != "Consumable" {
                            Text("Subscriptions_are_auto_renewed_Cancel_anytime")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        
                        // Continue Button
                        //                    Button(action: {
                        //                        if let currentSelectedProduct = iapViewModel.currentSelectedProduct {
                        //                            Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "Loading_".translate())
                        //                            iapViewModel.purchaseProduct(product: currentSelectedProduct)
                        //                        }
                        //                    }) {
                        //                        Text("Continue_")
                        //                            .font(.headline)
                        //                            .foregroundColor(.white)
                        //                            .frame(maxWidth: geometry.size.width * 0.9)
                        //                            .padding()
                        //                            .background(Color.pink)
                        //                            .cornerRadius(10)
                        //                            .disabled(iapViewModel.productLoadingStatus == .productsAvailable ? false : true)
                        //                    }
                        //                    .padding(.top, 20)
                        
                        PrimaryButton(title: "Continue_".translate(), icon: nil, isFullWidth: true) {
                            if let currentSelectedProduct = iapViewModel.currentSelectedProduct {
                                Loader.showLoader(in: UIApplication.shared.keyWindowPresentedController!.view!, text: "Loading_".translate())
                                iapViewModel.purchaseProduct(product: currentSelectedProduct)
                            }
                        }
                        .padding(.horizontal)
                        .disabled(iapViewModel.productLoadingStatus == .productsAvailable ? false : true)
                        .padding(.top, 10)
                        
                        // Restore Purchases
                        Button(action: {
                            //                        Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "Restoring_".translate())
                            Task {
                                await iapViewModel.restorePurchases()
//                                analyticsLogger.logPremiumInteraction(action: .restorePurchase)
                            }
                        }) {
                            Text("Restore_Purchase")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                        
                        Text(attributedText)
                            .font(.caption2)
                            .padding(.top, 10)
                            .onTapGesture {
//                                analyticsLogger.logPremiumInteraction(action: .readDetails)
//                                GetUrl.openTermsAndConditions()
//                                if let url = URL(string: App.) {
//                                    openURL(url)
//                                }
                            }
                        
                        Spacer()
                    } else {
                     
                        if PersistentStorage.isMonthlySubscribed {
                            SubscribedView(subscriptionType: "Monthly ", iapViewModel: iapViewModel)
                        } else if PersistentStorage.isYearlySubscribed{
                            SubscribedView(subscriptionType: "Yearly ", iapViewModel: iapViewModel)
                        }
                    }
                }
                .frame(width: geometry.size.width)
                .padding(.vertical)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                        withAnimation {
                            showCrossButton = true
                        }
                    }
                    //                if let initialImage = initialImage{
                    //                    consumableImage = initialImage
                    //                }
                    //                if iapViewModel.premiumPageLoadingState == .restore {
                    //                    iapViewModel.restorePurchases()
                    //                } else if iapViewModel.premiumPageLoadingState == .manage {
                    //                    if let currentSelectedProduct = iapViewModel.currentSelectedProduct {
                    //                        iapViewModel.purchaseProduct(product: currentSelectedProduct)
                    //                    }
                    //                }
                }
                //            .onReceive(iapViewModel.$productLoadingStatus) { purchaseStatus in
                //                if purchaseStatus == .productsAvailable {
                //                    Loader.stopLoader()
                //                    onConsumablePurchased?(true)
                //                    if count > 0, !iapViewModel.purchasedProducts.isEmpty {
                //                        let product = iapViewModel.purchasedProducts.first!
                //                        let currency = getCurrencySymbol(from: product)!
                //                        analyticsLogger.logPremiumInteraction(action: .purchased, pageName: "Premium Page", planType: product.displayName, currency: currency)
                //                    }
                //                    count += 1
                //                } else if purchaseStatus == .failure || purchaseStatus == .processing {
                ////                    Loader.stopLoader()
                ////                    if let errorMessage = iapViewModel.errorMessage{
                ////                        activeAlert = .error(errorMessage)
                ////                    }
                //
                //                }
                //            }
                
                .onReceive(iapViewModel.$purchaseStatus) { purchaseStatus in
                    if purchaseStatus == .success {
                        Loader.stopLoader()
                        onConsumablePurchased?(true)
                        if count > 0, !iapViewModel.purchasedProducts.isEmpty {
                            let product = iapViewModel.purchasedProducts.first!
                            let currency = getCurrencySymbol(from: product)!
//                            analyticsLogger.logPremiumInteraction(action: .purchased, planType: product.displayName, currency: currency)
                            
                        }
                        count += 1
                    } else if purchaseStatus == .failure {
                        //                    Loader.stopLoader()
                        //                    if let errorMessage = iapViewModel.errorMessage{
                        //                        activeAlert = .error(errorMessage)
                        //                    }
                    }
                }
                .onReceive(iapViewModel.$errorMessage) { errorMessage in
                    Loader.stopLoader()
                    logError("\(errorMessage ?? "")")
                    
                    if let errorMessage = errorMessage{
                        activeAlert = .noItemsFound(errorMessage)
                    }
                }
                
                .onReceive(iapViewModel.$consumablePurchasedProduct) { consumableProduct in
                    if consumableProduct != nil{
                        
                        //                    onConsumablePurchased?(true)
                        Loader.stopLoader()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .onReceive(iapViewModel.$noItemFoundForRestore) { message in
                    if !message.isEmpty {
                        logError("Restore No Items Found \(message)")
                        activeAlert = .noItemsFound(message)
                    }
                }
                .alert(item: $activeAlert) { activeAlert in
                    switch activeAlert {
                    case .error(let message):
                        return Alert(
                            title: Text("_Error"),
                            message: Text(message),
                            dismissButton: .default(Text("OK_"), action: {
                                iapViewModel.errorMessage = nil
                            })
                        )
                    case .noItemsFound(let message):
                        return Alert(
                            title: Text("No_Items_Found"),
                            message: Text(message),
                            dismissButton: .default(Text("OK_"), action: {
                                iapViewModel.errorMessage = nil
                            })
                        )
                    }
                }
                
            }
            
//            OfferCardView(primaryColor: DS.Colors.g1, secondaryColor: .black, bgImage: "OfferBG", title: "LIMITED_TIME_OFFER".translate(), discountPrice: "50", prevPrice: "2000Rs", newPrice: "3000Rs", buttonTitle: "CLAIM_NOW".translate()) {
//                
//            } onClaim: {
//                
//            }.frame(width: .infinity , height : .infinity)

        }
        .onAppear{
            iapViewModel.isViewAppeared = true
//            analyticsLogger.logPremiumInteraction(action: .pageViewed)
        }
        
        .onDisappear{
            iapViewModel.isViewAppeared = false
            iapViewModel.purchaseStatus = .idle
            if iapViewModel.consumablePurchasedProduct != nil {
                iapViewModel.consumablePurchasedProduct = nil
            }
        }
    }
}


// Function to get the currency symbol from the product
func getCurrencySymbol(from product: Product) -> String? {
    // Access the currency code from the product's price formatter
    let currencyCode = product.priceFormatStyle.currencyCode

    // Create a NumberFormatter to retrieve the currency symbol
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.currencyCode = currencyCode
    
    // Return the currency symbol
    return numberFormatter.currencySymbol
}
