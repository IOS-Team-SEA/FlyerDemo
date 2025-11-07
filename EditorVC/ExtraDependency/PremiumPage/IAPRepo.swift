//
//  IAPRepo.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 25/09/24.
//

import StoreKit
import Combine

enum IAPError: Error {
    case unverifiedTransaction(String)
    case pendingTransaction
    case userCancelled
    case unknownError
}


class IAPRepository {
    private let networkManager = PremiumNetworkManager()
    
    func loadProducts() async throws -> [Product] {
        let productIDs : Set<String> = [
//            "com.irisstudio.watermarkPre.pro",
//            "com.irisstudio.watermarkpro.monthly",
//            "com.irisstudio.watermarkpro.yearly",
//            "com.psma.partyza.invitation.rsvp.video.monthly",
//            "com.psma.partyza.invitation.rsvp.video.yearly",
//            "com.psma.partyza.invitation.rsvp.video.buySingleDesign",
            "com.simplyentertaining.acelogomaker.yearly",
            "com.simplyentertaining.acelogomaker.monthly"
        ]
//        let productIDs = ["Monthly", "Yearly", "singleTemplate"]
        
        
    
//        let productIDs = ["com.psma.partyza.invitation.rsvp.video.monthly", "Yearly", "com.psma.partyza.invitation.rsvp.video.yearly", "com.psma.partyza.invitation.rsvp.video.buySingleDesign"]
        
        
        
        return try await Product.products(for: productIDs)
    }
    
    func fetchReceiptData() async throws -> Data {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Receipt not found"])
        }
        return receiptData
    }
    
    func validateReceipt(receiptData: Data, completion: @escaping (Result<ReceiptValidationResult, Error>) -> Void) {
        networkManager.validateReceipt(receiptData: receiptData, completion: completion)
    }
    
    func purchaseProduct(product: Product) async throws -> Product.PurchaseResult {
        let result = try await product.purchase()
        return result
    }
    
    func handlePurchaseVerification(_ result: Product.PurchaseResult) async throws -> String? {
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
                return transaction.productID
            case .unverified(_, let error):
                throw IAPError.unverifiedTransaction(error.localizedDescription)
            }
        case .pending:
            throw IAPError.pendingTransaction
        case .userCancelled:
            throw IAPError.userCancelled
        @unknown default:
            throw IAPError.unknownError
        }
    }

    func restorePurchases() async throws -> Set<Product> {
        var purchasedProducts = Set<Product>()
        // Sync transactions with the App Store
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if let product = try! await Product.products(for: [transaction.productID]).first {
                    purchasedProducts.insert(product)
                }
            case .unverified(_, _):
                break
            }
        }
        return purchasedProducts
    }
}

