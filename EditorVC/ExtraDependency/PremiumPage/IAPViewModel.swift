//
//  IAPViewModel.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//
//

import StoreKit
import Combine
import SwiftUI

enum DefaultProductType{
    case year
    case onetime
    case month
    case week
}

public enum StoreError: Error {
    case failedVerification
}

//enum PremiumPageLoadingState{
//    case normal
//    case manage
//   // case restore
//}

protocol IAPViewModelProtocol: ObservableObject {
    
    /// all from appStoreConnect
    var availableProducts: [Product] { get set }
    
    /// purchased products
    var purchasedProducts: Set<Product> { get set }
    
    var purchaseStatus: PurchaseStatus { get set }
    
    var errorMessage: String? { get set }
    
  //  var currentCoins: Int { get set }
  //  var currentSubscription: Subscription? { get set }
  //  var subscriptionUpgradeOptions: [SubscriptionUpgradeOption] { get set }
//    var isReceiptValid: Bool { get set }
//    var isNetworkAvailable: Bool { get set }
    var currentSelectedProduct: Product? { get set }
    
    /// fetching from store and putting in available products
    func loadProducts()
        /// buy product and handle success failure
    func purchaseProduct(product: Product)

    /// manual restore method ( ask user promt )
    func restorePurchases()
    
    /// handles proactive restore on app launch
    func autoRestoreCheck()
    
  //  func validateReceipt()
   // func handleUpgrade(downgrade: Bool)
  //  func deductCoinsForPurchase(product: Product)
}

@MainActor
class IAPViewModel: ObservableObject {
    var purchaseRecieptHistory : String = ""
    @Published var availableProducts: [Product] = []
    @Published var purchasedProducts: Set<Product> = []
    @Published var purchaseStatus: PurchaseStatus = .idle
    @Published var productLoadingStatus : ProductLoadingState = .idle
    @Published var errorMessage: String?
    
//    @Injected var analytics : AnalyticsLogger
    
    
   // @Published var currentCoins: Int = 0
  //  @Published var currentSubscription: Subscription?
  //  @Published var subscriptionUpgradeOptions: [SubscriptionUpgradeOption] = []
  //  @Published var isReceiptValid: Bool = false
  //  @Published var isNetworkAvailable: Bool = true
    @Published var currentSelectedProduct: Product?
    var isSingleTemplateSelectedOrNot : Bool = false
  //  var consumableImage : Image?
//    var defaultProductType : DefaultProductType = .month
  //  var premiumPageLoadingState : PremiumPageLoadingState
    @Published var noItemFoundForRestore : String = ""

    private var cancellables = Set<AnyCancellable>()
    private let repository: IAPRepository = IAPRepository()
    @Published var consumablePurchasedProduct : Product?
    var isViewAppeared : Bool = false
    
    
    
    var singleTemplateProduct : IAPProduct? /*IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Watermark", "Unlock Single Template"], oldUserDefaultKeyIfAny: "", cellImage: Image("p1"), title: "Single", subTitle: "Only One Template", isHighlighted: false, status: "", tag: "/ Only One")*/
    
    var monthlyTemplateProduct : IAPProduct?  /*IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Ads - No Watermark", "All Premium Content"], oldUserDefaultKeyIfAny: "", cellImage: Image("p2"), title: "Monthly", subTitle: "Full Access Subscription", isHighlighted: false, status: "Most Popular", tag: "/ Monthly")*/
    
    var yearlyTemplateProduct : IAPProduct?  /*IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Ads - No Watermark", "All Premium Content"], oldUserDefaultKeyIfAny: "", cellImage: Image("p2"), title: "Yearly", subTitle: "Full Access Subscription", isHighlighted: true, status: "Save 80%", tag: "/ Yearly")*/
    

    init() {
      //  self.repository = repository
       // self.consumableImage = consumableImage
       // self.defaultProductType = defaultProductType
       // self.premiumPageLoadingState = premiumPageLoadingState
      //  self.consumableImage = consumableImage
//        self.singleTemplateProduct = IAPProduct(productIdentifier: "com.psma.partyza.invitation.rsvp.video.buySingleDesign", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No_App_Label".translate(), "Unlock_Single_Template".translate()], oldUserDefaultKeyIfAny: "", cellImage: Image("SubImage"), title: "Single_".translate(), subTitle: "Only_One_Template".translate(), isHighlighted: false, status: "", tag: "/" + "Only_One".translate())
        
      //  singleTemplateProduct?.cellImage = consumableImage
        
        self.monthlyTemplateProduct =  IAPProduct(productIdentifier: "com.simplyentertaining.acelogomaker.monthly", localizedTitleSuffix: "", freeTrialDays: 0, features: ["No_Ads".translate() + " " + "No_App_Label".translate(), "All_Premium_Content".translate()], oldUserDefaultKeyIfAny: "isMonthlyUser", cellImage: Image("monthly"), title: "Monthly_".translate(), subTitle: "Full_Access_Subscription".translate(), isHighlighted: false, status: "Most_Popular".translate(), tag: "/" + "Monthly_".translate())
        
        self.yearlyTemplateProduct =  IAPProduct(productIdentifier: "com.simplyentertaining.acelogomaker.yearly", localizedTitleSuffix: "", freeTrialDays: 0, features: ["No_Ads".translate() + " " + "No_App_Label".translate(), "All_Premium_Content".translate()], oldUserDefaultKeyIfAny: "isYearlyUser", cellImage: Image("yearly"), title: "Yearly_".translate(), subTitle: "Full_Access_Subscription".translate(), isHighlighted: true, status: "Save_".translate() + "80%", tag: "/" + "Yearly_".translate())
        
        loadProducts()
    }
    
    func loadProducts() {
        productLoadingStatus = .loading
        Task {
            do {
               let availableProducts = try await repository.loadProducts()
                DispatchQueue.main.async { [self] in
                    self.availableProducts = availableProducts.sorted(by: {$0.price > $1.price})
//                    for product in availableProducts {
//                        let isPurchased = purchasedProducts.contains(product)
//                        print("Product ID: \(product.id), Purchased: \(isPurchased), Type: \(product.type)")
//
//                        if isPurchased {
//                            print("This product has been purchased.")
//                        } else {
//                            print("This product has not been purchased.")
//                        }
//                    }
                    self.productLoadingStatus = .productsAvailable
                }
            
                
            } catch {
                productLoadingStatus = .noProductsAvailable
                errorMessage = "Failed_to_load_products".translate()
            }
        }
    }
    
//    func listenForTransactions() -> Task<Void, Error> {
//        return Task.detached {
//            // Iterate through any transactions that don't come from a direct call to `purchase()`.
//            for await result in Transaction.updates {
//                do {
//                    let transaction = try self.checkVerified(result)
//                    print("Transaction Updates.")
//
//                    // Deliver products to the user.
//                    await self.updateCustomerProductStatus()
//
//                    // Always finish a transaction.
//                    await transaction.finish()
//                } catch {
//                    // StoreKit has a transaction that fails verification. Don't deliver content to the user.
//                    print("Transaction failed verification.")
//                }
//            }
//        }
//    }
    
    
//    private func handleTransaction(_ transaction: VerificationResult<StoreKit.Transaction>) async {
//        switch transaction {
//        case .verified(let verifiedTransaction):
//            if let product = availableProducts.first(where: { $0.id == verifiedTransaction.productID }) {
//                purchasedProducts.insert(product)
//                await verifiedTransaction.finish()
//                purchaseStatus = .success
//            }
//        case .unverified(let transaction, let error):
//            print("Unverified transaction: \(error.localizedDescription)")
//        @unknown default:
//            print("Unknown transaction case encountered.")
//        }
//    }
    
//    private func handleTransaction(_ transaction: VerificationResult<StoreKit.Transaction>) async {
//        switch transaction {
//        case .verified(let verifiedTransaction):
//            do {
//                // Access the productID from the verifiedTransaction object
//                let productID = verifiedTransaction.productID
//
//                // Fetch the latest entitlements for the user
//                let currentEntitlements = await Transaction.currentEntitlements
//
//                // Check if the current entitlements include this productID
//                if currentEntitlements.contains(where: { $0.productID == productID }) {
//                    print("Verified transaction for product ID: \(productID)")
//                    purchaseStatus = .success
//                } else {
//                    print("Transaction verified, but the product is not currently entitled.")
//                }
//
//                // Finish the transaction
//                await verifiedTransaction.finish()
//            } catch {
//                print("Error fetching current entitlements: \(error.localizedDescription)")
//            }
//        case .unverified(_, let error):
//            print("Unverified transaction: \(error.localizedDescription)")
//        @unknown default:
//            print("Unknown transaction case encountered.")
//        }
//    }
    
    
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            // The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
    
    
    
    
    
 //   @MainActor
//    func updateCustomerProductStatus() async {
//        var hasEntitlements = false
//        var anyPremiumProduct : Product?
//        // Iterate through transactions and process them
//        for await result in Transaction.currentEntitlements {
//            hasEntitlements = true
//            do {
//                // Verify the transaction
//                let transaction = try checkVerified(result)
//
//                // Handle based on product type
//                switch transaction.productType {
////                case .nonConsumable:
////                    // Non-consumables are purchased once and never expire.
////                    if let product = availableProducts.first(where: { $0.id == transaction.productID }) {
////                        purchasedProducts.insert(product)
////                    }
//
//                case .nonRenewable:
//                    // Check for non-renewable subscriptions
//                    if let nonRenewable = availableProducts.first(where: { $0.id == transaction.productID }) {
//                        let currentDate = Date()
//                        let expirationDate = Calendar(identifier: .gregorian).date(byAdding: .year, value: 1, to: transaction.purchaseDate)!
//
//                        if currentDate < expirationDate {
//                            purchasedProducts.insert(nonRenewable)
//                            anyPremiumProduct = nonRenewable
//                            break;
//                        } else {
//                            // Handle expiration
//                            logError("Non-renewable subscription expired.")
//                        }
//                    }
//
//                case .autoRenewable:
//                    // Check for auto-renewable subscriptions
//                    if let subscription = availableProducts.first(where: { $0.id == transaction.productID }) {
//                        if let expirationDate = transaction.expirationDate {
//                            if expirationDate >  Date() /*Calendar.current.date(byAdding: .day, value: 1, to: Date())!*/ {
//                                purchasedProducts.insert(subscription)
//                                anyPremiumProduct = subscription
//                                logInfo("Auto-renewable subscription not expired.")
//
//                            } else {
//                                // Handle expiration
//                                logError("Auto-renewable subscription expired.")
//                            }
//                        } else {
//                            // No expiration date means it might still be active
//                            anyPremiumProduct = subscription
//
//                            
//                        }
//                    }
//
//                default:
//                    break
//                }
//            } catch {
//                print("Failed to verify transaction: \(error.localizedDescription)")
//            }
//
//        }
//
//        // Handle case where there are no entitlements
//        if !hasEntitlements {
//            if isViewAppeared{
//                errorMessage = "No_product_found_to_restore_purchases".translate()
//            }
//            PersistentStorage.savePurchaseHistory([])
//            UIStateManager.shared.isPremium = false
//        }
//        
//        if let premiumProduct = anyPremiumProduct {
//            activatePremium(for: premiumProduct)
//            logInfo("USER_SUbSCRIBED TRUE \(premiumProduct.displayName)")
//        } else {
//            logInfo("USER_SUbSCRIBED FALSE")
//            PersistentStorage.savePurchaseHistory([])
//            UIStateManager.shared.isPremium = false
//        }
//    }
    
  
    func collectCustomerReceipt()  {
        Task.detached(priority: .background) { [weak self] in
            
            var purchaseListCount = 0
            var purchases: [purchaseHistory] = []
            
            for await result in Transaction.all {
                purchaseListCount += 1
                guard let self = self else { return }
                
                do {
                    let transaction = try await checkVerified(result)
                    
                    guard let product = await availableProducts.first(where: { $0.id == transaction.productID }) else { continue }
                    
                    var history = purchaseHistory(
                        productName: product.id,
                        purchasedDate: transaction.purchaseDate,
                        expiryDate: transaction.purchaseDate, // updated below
                        isValid: false
                    )
                    
                    switch transaction.productType {
                    case .autoRenewable:
                        if let expiry = transaction.expirationDate {
                            history.expiryDate = expiry
                            history.isValid = expiry > Date()
                        }
                        
                    case .nonRenewable:
                        let expiry = Calendar.current.date(byAdding: .year, value: 1, to: transaction.purchaseDate)!
                        history.expiryDate = expiry
                        history.isValid = expiry > Date()
                        
                    case .nonConsumable:
                        history.expiryDate = .distantFuture
                        history.isValid = true
                        
                    default:
                        break
                    }
                    
                    purchases.append(history)
                    
                } catch {
                    printLog("❌ Failed to verify transaction: \(error.localizedDescription)")
                }
            }
            
            guard let self = self else { return }

            // Sort recent purchases
            let recentPurchases = purchases
                .sorted { $0.purchasedDate > $1.purchasedDate }
                .prefix(10)
            
            // Format string log (developer readable)
            let historyLog = recentPurchases.map {
                "\($0.productName) | Purchased: \($0.purchasedDate.formatted()) | Expiry: \($0.expiryDate.formatted()) | Valid: \($0.isValid)"
            }.joined(separator: "\n")
            
            let summary = "🧾 Receipt Count: \(purchaseListCount)\n\(historyLog)"
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                
                PersistentStorage.setPurchaseHistory(purchases: summary)
                purchaseRecieptHistory = summary
            }
         
            
            printLog("📦 Purchase History:\n\(summary)")
        }
    }
    
//    func collectCustomerReciept() async {
//        var purchaseListCount = 0
//        var purchases : [purchaseHistory] = []
//        // Iterate through transactions and process them
//        for await result in Transaction.all {
//            purchaseListCount += 1
//            do {
//                // Verify the transaction
//                let transaction = try checkVerified(result)
//
//                // Handle based on product type
//                switch transaction.productType {
//                case .nonRenewable:
//                    // Check for non-renewable subscriptions
//                    if let nonRenewable = availableProducts.first(where: { $0.id == transaction.productID }) {
//                        let currentDate = Date()
//                        let expirationDate = Calendar(identifier: .gregorian).date(byAdding: .year, value: 1, to: transaction.purchaseDate)!
//
//                        if currentDate < expirationDate {
//                            purchasedProducts.insert(nonRenewable)
//                        } else {
//                            // Handle expiration
//                            print("Non-renewable subscription expired.")
//                        }
//                    }
//
//                case .autoRenewable:
//                    // Check for auto-renewable subscriptions
//                    if let subscription = availableProducts.first(where: { $0.id == transaction.productID }) {
//                        var purchaseHistory = purchaseHistory(productName: subscription.id, purchasedDate: transaction.purchaseDate, expiryDate: transaction.purchaseDate, isValid: false)
//                        if let expirationDate = transaction.expirationDate {
//                            if expirationDate >  Date()  {
//                                purchasedProducts.insert(subscription)
//                                PersistentStorage.cachePurchaseStatus(purchasedProducts)
////                                UIStateManager.shared.isPremium = true
//                                purchaseHistory.isValid = true
//                            }
//                        }
//                        purchases.append(purchaseHistory)
//                    }
//
//                default:
//                    break
//                }
//            } catch {
//                print("Failed to verify transaction: \(error.localizedDescription)")
//            }
//        }
//        
//        let recentPurchase = purchases.sorted { $0.purchasedDate > $1.purchasedDate }
//                           .prefix(10)
//                           .map { $0 }
//        let purchaseHistory = "Reciept Count \(purchaseListCount) \(recentPurchase) "
//        PersistentStorage.setPurchaseHistory(purchases: purchaseHistory)
//        self.purchaseRecieptHistory = purchaseHistory
//        printLog("Recent Purchase \(PersistentStorage.getPurchaseHistory())")
//    }
    
    
    
    
    
    
    
    

    func purchaseProduct(product: Product) {
        Task {
            do {
                let result = try await repository.purchaseProduct(product: product)
                if let purchasedProductID = try await repository.handlePurchaseVerification(result) {
                    if let product = availableProducts.first(where: { $0.id == purchasedProductID }) {
                        // DispatchQueue.main.async{ [self] in
                        await MainActor.run {
                            
                     
                            if product.type == .consumable{
                                consumablePurchasedProduct = product
                            }
                            else{
                                purchasedProducts.insert(product)
                                let currency = getCurrencySymbol(from: product)!
//                                analytics.logPremiumInteraction(action: .purchased, planType: product.displayName, currency: currency)
                                
                            }
                            
//                            analytics.logPremiumCompleted(result: .SUCCESS, planType: product.displayName)
                        purchaseStatus = .success
                        PersistentStorage.cachePurchaseStatus(product)
                        if !purchasedProducts.isEmpty && product.type != .consumable{
                            setPremiumStatus(true)
                        }
                    }
                }
                   // }
                }
            } catch {
                handlePurchaseError(error, productName: product.displayName)
            }
        }
    }

    
    // MARK: - ✅ 1. Purchase Flow
 
        // NEW
    
    // MARK: - 🔎 Core Transaction Processor
    @discardableResult
    private func processTransaction(_ transaction: StoreKit.Transaction) async -> Bool {
        guard let product = try? await Product.products(for: [transaction.productID]).first else {
            logError("⚠️ Product not found for id: \(transaction.productID)")
            return false
        }

        switch transaction.productType {
        case .autoRenewable:
            if let expiry = transaction.expirationDate, expiry > Date() {
                await activatePremium(for: product)
                return true
            }

        case .nonRenewable:
            let expiry = Calendar.current.date(byAdding: .year, value: 1, to: transaction.purchaseDate)!
            if Date() < expiry {
                await activatePremium(for: product)
                return true
            }

        case .nonConsumable:
            await activatePremium(for: product)
            return true

        default:
            break
        }

        return false
    }
    
    // MARK: - ✅ Activate Premium
    @MainActor
       private func activatePremium(for product: Product) {
           purchasedProducts.insert(product)
           PersistentStorage.cachePurchaseStatus(product)
           logInfo("✅ Activated premium for product: \(product.id)")
       }
    @MainActor
    // MARK: - 🔐 Set Premium Status (Centralized)
       private func setPremiumStatus(_ isPremium: Bool) {
           UIStateManager.shared.isPremium = isPremium
           logInfo("🔐 Premium status set to: \(isPremium)")
       }
    
    // MARK: - 🔁 4. Apple Auto Transaction Listener
       func listenForTransactions() -> Task<Void, Never> {
           Task.detached(priority: .background) {
               for await result in Transaction.updates {
                   do {
                       let transaction = try await self.checkVerified(result)
                       if await self.processTransaction(transaction) {
                           await self.setPremiumStatus(true) // ✅ only set true (never false here)
                       }
                       await transaction.finish()
                   } catch {
                       logError("❌ Transaction update failed verification.")
                   }
               }
           }
       }
    
    // MARK: - 🚀 3. App Launch Check
       func checkEntitlementsAtLaunch()  {
           Task {
               await restorePurchases() // same logic reused
           }
       }
    
    
    private func handlePurchaseError(_ error: Error, productName: String) {
        DispatchQueue.main.async{ [self] in
            if let iapError = error as? IAPError {
                switch iapError {
                case .unverifiedTransaction(let message):
//                    analytics.logPremiumCompleted(result: .FAILED, planType: productName)
//                    analytics.logPremiumConversionError(errorType: .failPurchase, planType: productName)
                    errorMessage = "Unverified transaction: \(message)"
                    purchaseStatus = .failure
//                    analytics.logPremiumInteraction(action: .failPurchase)
                case .pendingTransaction:
                    errorMessage = "Transaction_is_Pending".translate()
                    purchaseStatus = .processing
//                    analytics.logPremiumInteraction(action: .pending)

                case .userCancelled:
//                    analytics.logPremiumCompleted(result: .FAILED, planType: productName)
//                    analytics.logPremiumConversionError(errorType: .cancelPurchase, planType: productName)
                    errorMessage = "User_Cancelled_the_Transaction".translate()
                    purchaseStatus = .failure
                    print("User Cancelled")
//                    analytics.logPremiumInteraction(action: .cancelPurchase)

                case .unknownError:
                    errorMessage = "Unknown_error_occurred".translate()
                    purchaseStatus = .failure
//                    analytics.logPremiumInteraction(action: .failPurchase)
//                    analytics.logPremiumCompleted(result: .FAILED, planType: productName)
//                    analytics.logPremiumConversionError(errorType: .failPurchase, planType: productName)
                }
            } else {
                errorMessage = "Purchase failed: \(error.localizedDescription)"
                purchaseStatus = .failure
            }
        }
    }
    // MARK: - 🔄 2. Manual Restore Button
     func restorePurchases() async {
         purchasedProducts = []
         var foundValidReceipt = false
         var hadEntitlement : Bool = false
         var restoreFailedError : Bool = false
         for await result in Transaction.currentEntitlements {
             hadEntitlement = true
             do {
                 let transaction = try checkVerified(result)
                 if await processTransaction(transaction) {
                     foundValidReceipt = true
                 }
             } catch {
                 restoreFailedError = true
                 logError("❌ Restore verification failed: \(error.localizedDescription)")
                 
             }
         }

         
         if foundValidReceipt {
              setPremiumStatus(true)
         } else {
              setPremiumStatus(false)
             PersistentStorage.cachePurchaseStatus(nil)
             
              if !hadEntitlement {
                 if isViewAppeared{
                     self.purchaseStatus = .failure
                      errorMessage = "No_product_found_to_restore_purchases".translate()
                }
                  logError("⚠️ No valid purchase found during restore.")

              } else if restoreFailedError {
                  logError("Restore verification failed")
                  if isViewAppeared{
                      self.purchaseStatus = .failure
                      errorMessage =  "Restore verification failed"
                  }

              }
             
         }
     }
    
    
    
//    func restorePurchases() {
//        Task {
//            do {
//                
////                try await AppStore.sync()
////                listenForTransactions()
//                await updateCustomerProductStatus()
////                let product = try await repository.restorePurchases()
////                PersistentStorage.savePurchaseHistory(product)
////                DispatchQueue.main.async {
////                    self.purchasedProducts = product
////                    self.purchaseStatus = .success
////                    if product.isEmpty{
////                        self.noItemFoundForRestore = "No product found to restore."
////                    }
////                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.purchaseStatus = .failure
//                }
//                errorMessage = "Failed to restore purchases."
//            }
//        }
//    }
    
//    func autoRestoreCheck() {
//        Task {
//          //  do {
//            if PersistentStorage.getTypeOfProduct() != "None" {
//                UIStateManager.shared.isPremium = true
//            }
//            
//            await updateCustomerProductStatus()
//                
////              //  try await AppStore.sync()
////                let product = try await repository.restorePurchases()
////                PersistentStorage.savePurchaseHistory(product)
////                DispatchQueue.main.async {
////                    self.purchasedProducts = product
////                    self.purchaseStatus = .success
////                    if product.isEmpty{
////                        self.noItemFoundForRestore = "No product found to restore."
////                    }
////                }
////            } catch {
////                DispatchQueue.main.async {
////                    self.purchaseStatus = .failure
////                }
////                errorMessage = "Failed to restore purchases."
////            }
//        }
//    }
    

//    func validateReceipt() {
//        Task {
//            do {
//                let receiptData = try await repository.fetchReceiptData()
//                repository.validateReceipt(receiptData: receiptData) { [weak self] result in
//                    switch result {
//                    case .success(let validationResult):
//                        DispatchQueue.main.async {
//                          //  self?.isReceiptValid = validationResult.isValid
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            self?.errorMessage = "Receipt validation failed: \(error.localizedDescription)"
//                        }
//                    }
//                }
//            } catch {
//                errorMessage = "Failed to get receipt data."
//            }
//        }
//    }

    func deductCoinsForPurchase(product: Product) {
        // Deduct coins logic here
    }
}

enum PurchaseStatus {
    case idle, processing, success, failure
}
enum ProductLoadingState {
    case idle, loading, productsAvailable, noProductsAvailable
}
struct Subscription {}
struct SubscriptionUpgradeOption {}


struct purchaseHistory {
    var productName : String
    var purchasedDate : Date
    var expiryDate : Date
    var isValid : Bool
}
