//
//  SubscriptionDataSource.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 11/09/24.
//

import Foundation
import SwiftUI

enum SubscriptionType{
    case consumable
    case monthly
    case yearly
}

class PremiumDataSource {
    static let shared = PremiumDataSource()

    private init() {}

    private var dataSources: [SubscriptionType: SubscriptionOptionViewModel] = [:]

    func loadData() {
        dataSources[.consumable] = SubscriptionOptionViewModel(
            image: Image("none"),
            title: "Single_".translate(),
            subtitle: "Only_One_Template".translate(),
            price: "$3.99",
            description: ["No_App_Label".translate(), "Unlock_Single_Template".translate()],
            tag: "/" + "Only_One".translate(),
            isHighlighted: false,
            status: ""
        )
        
        dataSources[.monthly] = SubscriptionOptionViewModel(
            image: Image("p2"),
            title: "Monthly_".translate(),
            subtitle: "Full_Access_Subscription".translate(),
            price: "$4.99",
            description: ["No_Ads".translate() + "No_App_Label".translate(), "All_Premium_Content".translate(), "RSVP_Analytics_And_Preferences".translate()],
            tag: "/" + "Monthly_".translate(),
            isHighlighted: true,
            status: "Most_Popular".translate()
        )
        
        dataSources[.yearly] = SubscriptionOptionViewModel(
            image: Image("p2"),
            title: "Yearly_".translate(),
            subtitle: "Full_Access_Subscription".translate(),
            price: "$14.99",
            description: ["No_Ads".translate() + "No_App_Label".translate(), "All_Premium_Content".translate(), "RSVP_Analytics_And_Preferences".translate()],
            tag: "/" + "Yearly_".translate(),
            isHighlighted: false,
            status: "Save_".translate() + "80%"
        )
    }

    func getData(for type: SubscriptionType) -> SubscriptionOptionViewModel? {
        return dataSources[type]
    }
}
