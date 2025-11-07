//
//  PremiumCellView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//


import SwiftUI
import StoreKit

struct SubscriptionOptionView: View {
   // @EnvironmentObject var subscriptionEnvironmentObj: SubscriptionEnvironmentObj
    var iaProduct : IAPProduct
    var price : String
    @Binding var selectedProductId: String?
    var product : Product
    var subscription : Subscription?
    @Binding var purchasedProduct : Set<Product> 
     @Binding var consumableImage : Image?

    
    var body: some View {
        VStack{
            VStack {
            HStack(alignment: .center) {
                // Placeholder for the image
                if let consumableImage = iaProduct.cellImage{
                    consumableImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                    //                .cornerRadius(10)
                        .padding(.trailing, 10)
                }
                else {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    // Title and Subtitle
                    Text(iaProduct.title)
                        .font(.headline).bold()
                        .foregroundColor(selectedProductId == product.id ? AppStyle.accentColor_SwiftUI : Color.label)
                    
                    Text(iaProduct.subtitle).bold()
                        .font(.caption)
                        .foregroundColor(selectedProductId == product.id ? AppStyle.accentColor_SwiftUI : Color.secondaryLabel)
                    
                    // Features
                    
                }
                
                Spacer()
                
                // Price and Tag
                VStack(alignment: .trailing) {
                    Text("\(price)")
                        .font(.headline)
                        .foregroundColor(Color.label)
                    
                    Text(iaProduct.tag)
                        .font(.caption)
                        .foregroundColor(Color.secondaryLabel)
                }
            }
                ScrollView(.vertical) {
                    ForEach(iaProduct.features, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 2) {
                            AutoScrollingTextView(longText: "• \(item)")
//                            AutoWrappingTextView(longText: "• \(item)")
                        }
                        .padding(.vertical, 0) // Optional padding for spacing between items
                    }
                }
        }
        
//            VStack(alignment: .center, content: {
//                if purchasedProduct.contains(product){
//                    Text("Purchased").foregroundColor(.green)
//                }
//            })
    }
        .padding()
        .overlay(
            Group {
                if iaProduct.status != "" {
                    // "Most Popular" Badge
                    Text(iaProduct.status)
                        .font(.caption)
                        .foregroundColor(Color.label)
                        .padding(.horizontal, DS.Spacing.eight)
                        .padding(.vertical,  DS.Spacing.eight/2.0)
                        .background(iaProduct.status == "Most Popular" ? Color(red: 0.690, green: 0.812, blue: 0.494, opacity: 1.0) :  Color(red: 1.0, green: 0.8078, blue: 0.0, opacity: 1.0))
//                        .cornerRadius(5)
                        .clipShape(RoundedCorner(radius: AppViewStyle.normalCornerRadius, corners: [.topRight]))
                        .padding(.top, 1.1)
                        .padding(.trailing, 1.1)
                }
            },
            alignment: .topTrailing
        )
        .background(
            RoundedRectangle(cornerRadius: AppViewStyle.normalCornerRadius)
                .stroke(
                    purchasedProduct.contains(product) ? Color.green :
                        (selectedProductId == product.id ? AppStyle.accentColor_SwiftUI : Color.secondarySystemBackground), lineWidth: (selectedProductId == product.id ? 2 : 1)
                )
        )
        .padding(.horizontal)
    }
    
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

//
//#Preview {
//    SubscriptionOptionView(image: Image("p1"), title: "Single", subtitle: "Only One Template", price: "$3.99", description: ["No Watermark", "Unlock Single Template"], tag: "/ Only One", isHighlighted: true, status: "Save 80%")
//}
