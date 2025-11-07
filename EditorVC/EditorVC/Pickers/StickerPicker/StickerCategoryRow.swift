//
//  StickerCategoryRow.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 13/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerCategoryRow: View {
    
    @Binding var stickerModel: [StickerModel]
    @Binding var category : String
    @State var stickerInfo: [String:String] = [:]
    @Binding var stickerName: String
    @Binding var isStickerPickerPresented: Bool
    @Binding var newStickerAdded: ImageModel?
    @State private var isLoading: Bool = true
    @State private var filteredStickerModel: [StickerModel] = []
    
    var body: some View {
        VStack{
//            if stickerModel.isEmpty{
//                ShimmerStickerPicker()
//            }else{
                HStack{
                    Text(category).bold()
                    Spacer()
                    
                    NavigationLink("See_All") {
                        StickerDetailListView(stickerInfo: $stickerInfo, category: $category, stickerName: $stickerName, isStickerPickerPresented: $isStickerPickerPresented, stickerModel: $stickerModel, newStickerAdded: $newStickerAdded)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .navigationTitle(category)
                            .navigationBarItems(trailing: Button(action: {
                                // Action for done button
                                isStickerPickerPresented = false
                            }) {
                                VStack{
                                    SwiftUI.Image("ic_Close")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                .frame(width: 30, height: 30)
                                .background(.white)
                                .cornerRadius(15)
                            })
//                            .environment(\.sizeCategory, .medium)
                    }
                    .font(.caption)
                    .foregroundColor(AppStyle.accentColor_SwiftUI)
                }
                ScrollView(.horizontal){
                    LazyHStack{
                        //                    if stickerModel.isEmpty{
                        //                        ForEach(0..<5, id: \.self){ count in
                        //                            ProgressView()
                        //                                .progressViewStyle(CircularProgressViewStyle())
                        //                                .frame(width: 100, height: 100)
                        //
                        //                        }
                        //                    }
                        ForEach(filteredStickerModel.indices, id: \.self){ index in
                            let model = filteredStickerModel[index]
//                            if model.categoryName == category{
                                
                            StickerThumbnailCell(stickerModel: model, index: index, isStickerPickerPresented: $isStickerPickerPresented, newStickerAdded: $newStickerAdded, isLoading: $isLoading, category: $category).environmentObject(UIStateManager.shared)
                                
//                            }
                        }
                        
                    }
                    .onChange(of: category) { category in
                        filteredStickerModel = stickerModel.filter { $0.categoryName == category }
                    }
                }
                .onAppear(){
                    filteredStickerModel = stickerModel.filter { $0.categoryName == category }
                }
//            }
        }
//        .onAppear(){
//            loadStickerData()
//        }

    }
    
//    private func loadStickerData() {
//        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////            stickerModel = StickerDBManager.shared.getAllStickerInfo()
//            isLoading = false
//        }
//    }
}

//#Preview {
//    StickerCategoryRow(category: "Animal", stickerName: .constant("Birthday"), isStickerPickerPresented: .constant(false), newStickerAdded: .constant(ImageModel(imageType: .IMAGE, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 1)))
//}
