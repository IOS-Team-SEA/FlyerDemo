//
//  StickerCategoryDetailListViewIpad.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 23/05/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerCategoryDetailListViewIpad: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var stickerInfo: [String:String]
    @Binding var category: String
    @Binding var stickerName: String
    @Binding var isStickerPickerPresented: Bool
    @Binding var stickerModel: [StickerModel]
    @Binding var newStickerAdded: ImageModel?
    @State private var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            let columns: [GridItem] = horizontalSizeClass == .compact ? [
                GridItem(.adaptive(minimum: 100)),
                GridItem(.adaptive(minimum: 100))
            ] : [
                GridItem(.adaptive(minimum: 150)),
                GridItem(.adaptive(minimum: 150)),
                GridItem(.adaptive(minimum: 150))
            ]
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(stickerModel.indices, id: \.self) { index in
                    let model = stickerModel[index]
                    if model.categoryName == category{
                        VStack {
                            StickerThumbnailCell(stickerModel: model, index: index, isStickerPickerPresented: $isStickerPickerPresented, newStickerAdded: $newStickerAdded, isLoading: $isLoading, category: $category).environmentObject(UIStateManager.shared)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    StickerCategoryDetailListViewIpad()
//}
