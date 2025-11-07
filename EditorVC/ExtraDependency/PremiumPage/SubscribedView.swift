//
//  SubscribedView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 18/09/24.
//

import SwiftUI
import StoreKit
import Lottie

struct SubscribedView: View {
    var subscriptionType: String
    @State var isManagedClicked : Bool = false
    @StateObject var iapViewModel: IAPViewModel
    @Environment(\.openURL) var openURL

    var attributedPremiumText: AttributedString {
        var attributedString = AttributedString("You_are_".translate())

        var subscriptionType = AttributedString(subscriptionType)
        subscriptionType.foregroundColor = AppStyle.accentColorUIKit
        
        var lastString = AttributedString("Subscribed_Successfully".translate())
        
        if subscriptionType == "OneTime "{
            lastString = AttributedString("Purchased ☺️")
        }

      

        attributedString.append(subscriptionType)
        attributedString.append(lastString)

        return attributedString
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack {
                    
                    Spacer()
                    // Subscribed text
                    
                    Text(attributedPremiumText)
                        .fontWeight(.bold)
                        .font(.system(size: 55))
                        .lineLimit(4)
                        .multilineTextAlignment(.center)
                        .blastEffectOverlay(hideBlast: .constant(false))
                    Spacer()
                    
                    // Manage Plans button
                    Button(action: {
                      //  isManagedClicked.toggle()
                        
                        if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
                            openURL(url)
                        }
                        
                    }) {
                        Text("Manage_Plans")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: geometry.size.width * 0.9)
                            .padding()
                            .background(AppStyle.accentColor_SwiftUI)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
                
                
//                .manageSubscriptionsSheet(isPresented: $isManagedClicked, subscriptionGroupID: "21611831")
                
//                // Display the blast effect using Lottie animation
//                PremiumLottieView(animationName: "blastEffect", loopMode: .playOnce, isCompleted: .constant(false))
//                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.75)
                
                // Overlay the image at the top right corner
//               Image("celebrate")
//                   .resizable()
//                   .frame(width: 80, height: 80)
//                   .padding(.trailing)
//                   .position(x: geometry.size.width - 35, y: 50)
            }
        }
    }
}
