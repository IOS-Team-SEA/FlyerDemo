//
//  StickerCategoryListView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 13/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerCategoryListView: View {
    
    @Binding var stickerCategories: [String]
//    @Binding var stickerInfo: [String:String]
    @Binding var stickerName: String
    @Binding var isStickerPickerPresented: Bool
    @Binding var newStickerAdded: ImageModel?
    @State var stickerModel: [StickerModel] = []
    
    var body: some View {
        
        ScrollView(.vertical){
            LazyVStack(pinnedViews: .sectionHeaders) {
                Section{
                    if stickerModel.isEmpty{
//                        ShimmerStickerPicker()
                    }else{
                        VStack{
                            ForEach($stickerCategories, id: \.self) { category in
                                //                    CategoryRow(category: category, templates: viewModel.templates[category]!, delegate: $viewModel.delegate, categoryThumbPath: viewModel.categoriesImagePath.first ?? "")
                                
                                StickerCategoryRow(stickerModel: $stickerModel, category: category, stickerName: $stickerName, isStickerPickerPresented: $isStickerPickerPresented, newStickerAdded: $newStickerAdded)
                            }
                        }.padding()
                    }
                } header: {
                    if !UIStateManager.shared.isPremium {
//                        BannerAdView().environmentObject(UIStateManager.shared)
                    }
                }
            }
        }
        .onAppear(){
            stickerCategories = DataSourceRepository.shared.getUniqueStickerCategories
            loadStickerData()
        }
            
//        .onAppear(){
//            loadStickerData()
//        }
    }
    
    private func loadStickerData() {
//        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            stickerModel = DataSourceRepository.shared.getStickerInfo//StickerDBManager.shared.getAllStickerInfo()
//            isLoading = false
        }
    }
}

#Preview {
    StickerCategoryListView(stickerCategories: .constant(["Animals", "birthday", "events"]), stickerName: .constant("Animals"), isStickerPickerPresented: .constant(false), newStickerAdded: .constant(ImageModel(imageType: .COLOR, serverPath: "", localPath: "", cropRect: .zero, sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)))
}
