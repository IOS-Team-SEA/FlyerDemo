//
//  StickerThumbnailCell.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerThumbnailCell: View {
   // @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
    var stickerModel: StickerModel
    var index: Int
//    var resID: String
//    @Binding var stickerName: String
    @Binding var isStickerPickerPresented: Bool
    @Binding var newStickerAdded: ImageModel?
    @Binding var isLoading: Bool
    @Binding var category: String
    @State var isPremiumUser: Bool = false
    @EnvironmentObject var uiStateManager : UIStateManager
    
    var renderingMode : Image.TemplateRenderingMode {
        if category.contains("SHAPES")   {
//            (ThemeManager.shared.currentTheme == .darkMode)
            return .template
        }
    
        
        return .original
    }
    var foregroundColor  : Color {
  
        if ThemeManager.shared.currentTheme == .darkMode {
            return .white
        }
    
        
        return .black
    }
    var body: some View {
        VStack {
            
            //Show the Thumbnail Image.
            ZStack{
                SwiftUI.Image("\(stickerModel.resId)")
                    .resizable()
                    .renderingMode(renderingMode)
                    .foregroundColor(foregroundColor)
                    .background(Color(uiColor: .systemBackground))
                    .frame(width: 100, height: 100)
                    .cornerRadius(10.0)
                    .shadow(radius: 3.0)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        // ** Neeshu
                        if index > 4 && !uiStateManager.isPremium {
                            isPremiumUser = true
                        }else{
                            let imageModel = ImageModel(imageType: .IMAGE, serverPath: stickerModel.resId, localPath: stickerModel.resId, cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 0.0, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                            newStickerAdded = imageModel
                            
                            isStickerPickerPresented = false
                        }
                    }
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                // ** Neeshu
                if index > 4 && !uiStateManager.isPremium {
                    VStack{
                        HStack{
                            Spacer()
                            SwiftUI.Image("premiumIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 100)
                        Spacer()
                    }
                    .frame(height: 100)
                    
                }
            }
            .sheet(isPresented: $isPremiumUser) {
                // ** Neeshu
//                let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .restore)
//                IAPView(iapViewModel: iapViewModel).environmentObject(UIStateManager.shared)
//                PremiumPage(checkForRestore: false)
                IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled()

            }
        }

    }
}

//#Preview {
//    StickerThumbnailCell(stickerModel: , index: <#Int#>, isStickerPickerPresented: <#Binding<Bool>#>, newStickerAdded: <#Binding<ImageModel?>#>, isLoading: <#Binding<Bool>#>, category: <#Binding<String>#>)
//}

//struct StickerThumbnailCell_Previews: PreviewProvider {
//    static var previews: some View {
//        var stickerModel = StickerModel()
//        StickerThumbnailCell(stickerModel: stickerModel, index: 0, isStickerPickerPresented: .constant(false), newStickerAdded: .constant(ImageModel(imageType: .IMAGE, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)), isLoading: .constant(false), category: .constant("Birthday"))
//    }
//}
