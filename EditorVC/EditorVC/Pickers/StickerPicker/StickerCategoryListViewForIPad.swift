//
//  StickerCategoryListViewForIPad.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 23/05/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerCategoryListViewForIPad: View {
    
    @Binding var stickerCategories: [String]
    @State var stickerModel: [StickerModel] = []
//    @Binding var stickerInfo: [String:String]
    @State var stickerInfo: [String:String] = [:]
    @Binding var stickerName: String
    @Binding var isStickerPickerPresented: Bool
    @Binding var newStickerAdded: ImageModel?
    @State var currentCategory: String = "Animals"
    
    var body: some View {
        
        VStack(spacing: 20){
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(stickerCategories, id: \.self) { category in
                        Button(action: {
                            //                        viewModel.currentCategory = category
                            //                        viewModel.fetchTemplates()
                            currentCategory = category
                        }) {
                            Text(category)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(currentCategory == category ? AppStyle.accentColor_SwiftUI : Color(UIColor.systemGray6))
                                .foregroundColor(currentCategory == category ? .white : .gray)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.leading, 16)
            }
            
            StickerCategoryDetailListViewIpad(stickerInfo: $stickerInfo, category: $currentCategory, stickerName: $stickerName, isStickerPickerPresented: $isStickerPickerPresented, stickerModel: $stickerModel, newStickerAdded: $newStickerAdded)
        }
        .padding(.top, 10)
        .onAppear(){
            stickerModel = StickerDBManager.shared.getAllStickerInfo()
            
            print("stickerModel: \(stickerModel)")
        }
    }
}

//#Preview {
//    StickerCategoryListViewForIPad()
//}
