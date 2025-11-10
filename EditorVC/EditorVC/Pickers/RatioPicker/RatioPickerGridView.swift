//
//  RatioPickerGridView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 12/04/24.
//

import SwiftUI
import IOS_CommonEditor

struct RatioPickerGridView: View {
    @StateObject var currentActionState: ActionStates
    var onRatioSelected: (() -> Void)?
    var createNewTapped:Bool
    
    
    var body: some View {
        let allRatioModels = fetchAllRatioModels()
        NavigationView{
            ScrollView(.vertical) {
                ForEach(allRatioModels.keys.sorted(), id: \.self) { category in
                    RatioCategoryView(category: category, ratioModels: allRatioModels[category]!, createNewTapped: createNewTapped, didRatioSelected: $currentActionState.didRatioSelected, onRatioSelected: onRatioSelected)
                    //                        .padding()
                    
                }
            }
            .navigationTitle("Ratio_")
            .navigationBarItems(trailing: Button(action: {
                // Action for done button
                onRatioSelected?()
            }) {
                Text("Done_")
                    .foregroundColor(AppStyle.accentColor_SwiftUI)
            })
            
        }
    }
    
    func getRatioCategory() -> [String]{
        let ratioCategoryList = DBManager.shared.getRatioCategories()
        
        return ratioCategoryList
    }
    
    func fetchAllRatioModels() -> [String: [DBRatioTableModel]] {
        var allRatioModels: [String: [DBRatioTableModel]] = [:]
        let ratioCategoryList = DBManager.shared.getRatioCategories()
        
        for category in ratioCategoryList {
            let ratioModels = DBManager.shared.getRatioModelList(category: category)
            allRatioModels[category] = ratioModels
        }
        
        return allRatioModels
    }
}

//struct RatioPickerGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        let actionState = ActionStates()
//        RatioPickerGridView(currentActionState: actionState, createNewTapped: true)
//    }
//}


struct RatioCategoryView: View {
    let category: String
    let ratioModels: [DBRatioTableModel]
     var createNewTapped:Bool
    @Binding var didRatioSelected: DBRatioTableModel
   // @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
//    var didRatioSelected: ((DBRatioTableModel)->Void)?
    var onRatioSelected: (() -> Void)?
    @State var showPremium: Bool = false
    @EnvironmentObject var uiStateManager : UIStateManager
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: -10){
                
                Text(RatioDetail.categoryMap[category] ?? category)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                if RatioDetail.categoryMap[category] != "Default"{
                    // ** Neeshu
                    if !uiStateManager.isPremium{
                        SwiftUI.Image("premiumIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.top, -20)
                    }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(ratioModels, id: \.id) { ratioModel in
                        VStack {
                            Spacer()
                            let mySize = calculatedWidth2(for: ratioModel)
                            AspectRatioView(ratioModel: ratioModel)
                                .frame(width: mySize.width, height: mySize.height)
                                .onTapGesture {
                                    //if RatioDetail.categoryMap[category] == "Default"
                                    //check if is user subscribed
                                    //else{
                                    //
                                    if !uiStateManager.isPremium && (ratioModel.outputWidth != -1 || ratioModel.outputHeight != -1){
                                    
//                                    if RatioDetail.categoryMap[category] != "Default"{
                                        // ** Neeshu
//                                        if !PersistentStorage.shared.isUserSubscribed{
                                            showPremium = true
//                                        }
                                    }else{
                                        if createNewTapped{
                                            let templateInfo: TemplateInfo = TemplateInfo.createDefaultTemplate()
                                            templateInfo.ratioId = ratioModel.id
                                            //
                                            do{
                                                try DBManager.shared.updateTemplateRatio(templateId: templateInfo.templateId, templateRatioId: templateInfo.ratioId)
                                            }catch{
                                                print(" template insertion failed")
                                            }
                                        }
                                        didRatioSelected = ratioModel
                                        onRatioSelected?()
                                    }
                                    
                                }
                            if ratioModel.outputWidth == -1 || ratioModel.outputHeight == -1{
                                Text("\(ratioModel.ratioWidth, specifier: "%.f") x \(ratioModel.ratioHeight, specifier: "%.f")")
                                    .font(.caption)
                                    .frame(width: mySize.width)
                                    .fixedSize(horizontal: false, vertical: false)
                            }else{
                                
                                MarqueeText(
                                                text: "\(RatioDetail.categoryDescriptionMap[ratioModel.categoryDescription] ?? ratioModel.categoryDescription)",
                                                font: .caption2,
                                                width: mySize.width
                                                
                                            )
                                .frame(height: 20)
                                
//                                Text("\(RatioDetail.categoryDescriptionMap[ratioModel.categoryDescription] ?? ratioModel.categoryDescription)")
//                                    .font(.caption2)
//                                    .frame(width: mySize.width, height: 20)
//                                    .fixedSize(horizontal: false, vertical: true)
//                                    
//                                    .fixedSize(horizontal: false, vertical: false)
//                                Text(String(format: "%.0f x %.0f", ratioModel.outputWidth, ratioModel.outputHeight))
//                                    .font(.caption2)
//                                    .frame(width: mySize.width, height: 20)
                                
                                MarqueeText(
                                                text: String(format: "%.0f x %.0f", ratioModel.outputWidth, ratioModel.outputHeight),
                                                font: .caption2,
                                                width: mySize.width
                                                
                                            )
                                .frame(height: 20)

                                
                            }
                              
                        }
                        .frame( height: 150)
                        .sheet(isPresented: $showPremium) {
                            // ** Neeshu
//                            let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal)
//                            IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled()
//                            PremiumPage(checkForRestore: false)
                        }
                        
                    }
                }
                .frame(height: 150)
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    func calculatedWidth(for ratioModel: DBRatioTableModel) -> CGFloat {
        let aspectRatio = CGFloat(ratioModel.ratioWidth) / CGFloat(ratioModel.ratioHeight)
        let height: CGFloat = 80 // Fixed height for the AspectRatioView
        return height * aspectRatio
    }
    func calculatedWidth2(for ratioModel: DBRatioTableModel) -> CGSize {
        let aspectRatio = CGFloat(ratioModel.ratioWidth) / CGFloat(ratioModel.ratioHeight)
        let height: CGFloat = 80 // Fixed height for the AspectRatioView
        let newWidth = height * aspectRatio
        
        return getProportionalSize(currentSize: CGSize(width: ratioModel.ratioWidth, height: ratioModel.ratioHeight), newSize: CGSize(width: 80, height: 80))
    }
}

struct RatioDetail{
    static let categoryDescriptionMap: [String: String] = [
        "txt_facebook": "Facebook",
        "txt_insta": "Instagram",
        "txt_youtube": "Youtube",
        "txt_twitter": "X",
        "txt_link": "LinkedIn",
        "txt_twi": "Twitch_".translate(),
        "txt_paper": "Paper_".translate(),
        "txt_letter": "Letter_".translate(),
        "txt_device": "Device_".translate(),
        "txt_desk": "Desktop_".translate(),
        "txt_logosize": "Logo_size".translate(),
        "txt_google": "Google_cover".translate(),
        "txt_tumbler": "Tumblr",
        "txt_pinterst": "Pinterest",
        "txt_present": "Presentations_".translate(),
        "txt_info": "Infographic_".translate(),
        "fc": "Cover_".translate(),
        "fp": "Post_".translate(),
        "fai": "App_Image".translate(),
        "fadi": "Ad_Image".translate(),
        "fapi": "Profile_Image".translate(),
        "fagcp": "Cover_Photo".translate(),
        "ip": "Post_".translate(),
        "yc": "Cover_".translate(),
        "tc": "Cover_".translate(),
        "lc": "Cover_".translate(),
        "thc": "Cover_".translate(),
        "ap": "72 DPI",
        "l": "72 DPI",
        "dwp": "Portrait_".translate(),
        "dw": "Wallpaper_".translate(),
        "logo": "Logo_".translate(),
        "logo_go": "Google" + "Logo_".translate(),
        "logo_fa": "FB" + "Logo_".translate(),
        "logo_tw": "Twitter" + "Logo_".translate(),
        "logo_li": "LinkedIn" + "Logo_".translate(),
        "gc": "Cover_".translate(),
        "gcp": "Cover_Photo".translate(),
        "gpp": "Profile_Image".translate(),
        "tg": "Graphic_".translate(),
        "ti": "Image_".translate(),
        "pp": "Pinterest Pin",
        "pbd": "Board_Display".translate(),
        "ppi": "Profile_Image".translate(),
        "p": "Presentations_".translate(),
        "i": "Basic_".translate(),
        "ia": "Average_".translate(),
        "im": "Medium_".translate(),
        "imo": "Mode_".translate(),
        "yt": "Thumbnail_".translate(),
        "ytd": "Tablet_Display".translate(),
        "tp": "Post_".translate(),
        "tpi": "Profile_Image".translate(),
        "lb": "Banner_".translate(),
        "lp": "Profile_".translate(),
        "tvi": "Video_Image".translate(),
        "ap2": "200 DPI",
        "ap3": "300 DPI",
        "l2": "200 DPI",
        "l3": "300 DPI",
        "dwl": "Landscape_".translate(),
        "ratio": "Ratio".translate()
    ]
    
    static let categoryMap: [String: String] = [
        "ratio_default": "Default",
        "txt_facebook": "Facebook",
        "txt_insta": "Instagram",
        "txt_youtube": "Youtube",
        "txt_twitter": "X",
        "txt_link": "LinkedIN",
        "txt_twi": "Twitch",
        "txt_paper": "Paper",
        "txt_letter": "Letter",
        "txt_device": "Device",
        "txt_desk": "Desktop",
        "txt_logosize": "Logo size",
        "txt_google": "Google cover",
        "txt_tumbler": "Tumblr",
        "txt_pinterst": "Pinterest",
        "txt_present": "Presentations",
        "txt_info": "Infographic"
    ]
    
    static let categoryBorderColorMap: [String: Color] = [
        "ratio_default": Color(.secondaryLabel),
        "txt_facebook": Color(uiColor: UIColor(hexString: "1976D2") ?? .blue),
        "txt_insta": Color(uiColor: UIColor(hexString: "DC3873") ?? .red),
        "txt_youtube": Color(uiColor: UIColor(hexString: "E53935") ?? .red),
        "txt_twitter": Color(uiColor: UIColor(hexString: "000000") ?? .gray),
        "txt_link": Color(uiColor: UIColor(hexString: "0A66C2") ?? .gray),
        "txt_twi": Color(uiColor: UIColor(hexString: "5A3E85") ?? .gray),
        "txt_paper": Color(.secondaryLabel),
        "txt_letter": Color(.secondaryLabel),
        "txt_device": Color(.secondaryLabel),
        "txt_desk": Color(.secondaryLabel),
        "txt_logosize": Color(.secondaryLabel),
        "txt_google": Color(uiColor: UIColor(hexString: "F88B24") ?? .yellow),
        "txt_tumbler": Color(uiColor: UIColor(hexString: "34526F") ?? .gray),
        "txt_pinterst": Color(uiColor: UIColor(hexString: "E60019") ?? .gray),
        "txt_present": Color(.secondaryLabel),
        "txt_info": Color(.secondaryLabel)
    ]
    
}

struct AspectRatioView: View {
    let ratioModel: DBRatioTableModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(
                        RatioDetail.categoryBorderColorMap[ratioModel.category]
                            .opacity(0.2)
                            .cornerRadius(5)
                    )
                    .aspectRatio(CGFloat(ratioModel.ratioWidth) / CGFloat(ratioModel.ratioHeight), contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(
                                RatioDetail.categoryBorderColorMap[ratioModel.category] ?? .clear,
                                lineWidth: 1
                            )
                    )
                    
                SwiftUI.Image("\(ratioModel.category)")
                    .resizable()
                    .frame(width: 20, height: 20)
                    
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct MarqueeText: View {
    var text: String
    var font: Font
    var width: CGFloat

    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            let textSize = textSize(text: text, font: font, width: width)
            let animationOffset = textSize.width > geometry.size.width ? textSize.width - geometry.size.width : 0

            Text(text)
                .font(font)
                .fixedSize(horizontal: true, vertical: false)
                .offset(x: animate ? -animationOffset : 0)
                .animation(
                    Animation.linear(duration: 3)
                        .repeatForever(autoreverses: false),
                    value: animate
                )
                .onAppear {
                    if animationOffset > 0 {
                        animate = textSize.width > width
                    }
                }
        }
        .frame(width: width)
        .clipped()
    }

    private func textSize(text: String, font: Font, width: CGFloat) -> CGSize {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.sizeToFit()
        return label.frame.size
    }
}
