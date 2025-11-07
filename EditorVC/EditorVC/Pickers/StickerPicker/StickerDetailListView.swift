//
//  StickerDetailListView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerDetailListView: View {
    
    @Binding var stickerInfo: [String:String]
    @Binding var category: String
    @Binding var stickerName: String
    @Binding var isStickerPickerPresented: Bool
    @Binding var stickerModel: [StickerModel]
    @State private var filteredStickerModel: [StickerModel] = []
    @Binding var newStickerAdded: ImageModel?
    @State private var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 100)),
                GridItem(.adaptive(minimum: 100)),
                GridItem(.adaptive(minimum: 100))
            ], spacing: 5, pinnedViews: .sectionHeaders) {
                Section{
                //                ForEach(stickerInfo.sorted(by: { $0.value < $1.value }), id: \.key) { pair in
                //                    if pair.value == category {
                //                        VStack{
                //                            StickerThumbnailCell(resID: pair.key, stickerName: $stickerName, isStickerPickerPresented: $isStickerPickerPresented)
                //                        }
                //                        .padding()
                //                        .cornerRadius(8)
                //                    }
                //                }
                
                ForEach(filteredStickerModel.indices, id: \.self){ index in
                    let model = filteredStickerModel[index]
                    //                    if model.categoryName == category{
                    VStack{
                        StickerThumbnailCell(stickerModel: model, index: index, isStickerPickerPresented: $isStickerPickerPresented, newStickerAdded: $newStickerAdded, isLoading: $isLoading, category: $category).environmentObject(UIStateManager.shared)
                        
                        
                    }
                    .padding()
                    .cornerRadius(8)
                    //                    }
                }
                .onChange(of: category) { category in
                    filteredStickerModel = stickerModel.filter { $0.categoryName == category }
                }
                } header:{
                    if !UIStateManager.shared.isPremium {
//                        BannerAdView().environmentObject(UIStateManager.shared)
                    }
                }
        }
            .padding()
            
        }
        .onAppear(){
//            loadStickerData()
            filteredStickerModel = stickerModel.filter { $0.categoryName == category }
        }
    }
    
//    private func loadStickerData() {
//        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            stickerInfo = DataSourceRepository.shared.getStickerInfo()
//            isLoading = false
//        }
//    }
}

//#Preview {
//    StickerDetailListView()
//}
