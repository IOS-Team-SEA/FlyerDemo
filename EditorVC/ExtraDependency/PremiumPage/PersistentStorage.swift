//
//  PersistentStorage.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import Foundation
import StoreKit
import SwiftUI

protocol AdsEngineSubscriptionInterface {
    var isUserSubscribed : Bool { get  }
}

class PersistentStorage : AdsEngineSubscriptionInterface{
    
    static let shared = PersistentStorage()
    
    
    private init() {}
    
    var isUserSubscribed: Bool {
        get {
            // Computed property logic for getter
            return PersistentStorage.isMonthlySubscribed || PersistentStorage.isYearlySubscribed
        }
        set {
            
        }
    }
    
//    // Add AppStorage for subscription statuses
//    @AppStorage("com.psma.partyza.invitation.rsvp.video.monthly") static var isMonthlySubscribed: Bool = false
//    @AppStorage("com.psma.partyza.invitation.rsvp.video.yearly") static var isYearlySubscribed: Bool = false
    
//    // Add AppStorage for subscription statuses
//    @AppStorage("com.irisstudio.watermarkpro.monthly") static var isMonthlySubscribed: Bool = false
//    @AppStorage("com.irisstudio.watermarkpro.yearly") static var isYearlySubscribed: Bool = false
    
    @AppStorage("com.simplyentertaining.acelogomaker.monthly") static var isMonthlySubscribed: Bool = false
    @AppStorage("com.simplyentertaining.acelogomaker.yearly") static var isYearlySubscribed: Bool = false
    @AppStorage("snappingMode") static var snappingMode : Int = 0
    @AppStorage("purchaseHistory") static var purchaseHistory : String = "No Purchase History Found"

    static func cachePurchaseStatus(_ purchase: Product? ) {
       
        
        if let product = purchase {
            if product.id == "com.simplyentertaining.acelogomaker.monthly" {
                isMonthlySubscribed = true
            } else  if product.id == "com.simplyentertaining.acelogomaker.yearly" {
                isYearlySubscribed = true
            }
            
        } else {
            isMonthlySubscribed = false
            isYearlySubscribed = false
        }
    }
    
    static func getPurchaseHistory() -> String{
        
        return purchaseHistory
    }
    
    static func setPurchaseHistory(purchases : String) {
        purchaseHistory = purchases
    }
    
//    static func getTypeOfProduct() -> String {
//        if isMonthlySubscribed{
//            return "month"
//        }
//        else if isYearlySubscribed{
//            return "year"
//        }
//        return "None"
//    }
//    
//    static func loadPurchaseHistory() -> [Product] {
//        guard let productIdentifiers = UserDefaults.standard.array(forKey: "purchaseHistory") as? [String] else {
//            return []
//        }
//        // Retrieve products from identifiers (this requires a way to fetch Product instances)
//        return productIdentifiers.compactMap { id in
//            // Example: Product(id: id)
//            return nil // Replace with actual Product fetching logic
//        }
//    }
    
//    static func saveCoinBalance(_ balance: Int) {
//        UserDefaults.standard.set(balance, forKey: "coinBalance")
//    }
//    
//    static func loadCoinBalance() -> Int {
//        return UserDefaults.standard.integer(forKey: "coinBalance")
//    }
    
//    static func saveReceiptData(_ data: Data) {
//        let keychain = KeychainManager.shared
//        keychain.save(key: "receiptData", data: data)
//    }
//    
//    static func loadReceiptData() -> Data? {
//        let keychain = KeychainManager.shared
//        return keychain.load(key: "receiptData")
//    }
}
