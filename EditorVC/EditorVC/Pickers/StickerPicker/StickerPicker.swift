//
//  StickerPicker.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 13/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerPicker: View {
    
//    @Binding var stickerInfo: [String:String]
    @State var stickerName: String = ""
    @Binding var newStickerAdded: ImageModel?
    @Binding var isStickerPickerPresented: Bool
    @Binding var uniqueCategories: [String]
    @State var didGalleryButtonClicked : Bool = false
    @State var cropType : ImageCropperType = .ratios
    @State var previousSticker : ImageModel?
    @Binding var replaceSticker : ImageModel?
    @Binding var updateThumb : Bool
    var body: some View {
//        if #available(iOS 16.0, *), UIDevice.current.userInterfaceIdiom == .pad {
//            StickerCategoryListViewForIPad(stickerCategories: $uniqueCategories/*, stickerInfo: $stickerInfo*/, stickerName: $stickerName, isStickerPickerPresented: $isStickerPickerPresented, newStickerAdded: $newStickerAdded)
//                .background(Color(uiColor: .secondarySystemBackground))
//        }else{
        VStack{
            Button(action: {
                didGalleryButtonClicked = true
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle") // Gallery symbol
                        .font(.system(size: 20)) // Adjust size if needed
                    Text("Gallery_")
                        .font(.headline)
                }
                .padding()
                .foregroundColor(.white)
                .background(AppStyle.accentColor_SwiftUI)
                .cornerRadius(10) // Rounded corners
            }
            StickerCategoryListView(stickerCategories: $uniqueCategories/*, stickerInfo: $stickerInfo*/, stickerName: $stickerName, isStickerPickerPresented: $isStickerPickerPresented, newStickerAdded: $newStickerAdded)
                .background(Color(uiColor: .secondarySystemBackground))
                    .sheet(isPresented: $didGalleryButtonClicked, onDismiss: {
                        // Prevent StickerPicker from dismissing when ImagePickerView closes
                        if !didGalleryButtonClicked {
                            isStickerPickerPresented = false
                        }
                    }) {
            //            ImagePickerView(isImagePickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: $previousSticker, replaceImage: $replaceSticker, type: $cropType, ratioInfo: $ratioInfo, updateThumb: $updateThumb).interactiveDismissDisabled()
            
                       // CustomGalleryPickerView(isGalleryPickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: previousSticker ,replaceImage: $replaceSticker, cropStyle: .ratios, aspectSize: CGSize.zero).interactiveDismissDisabled()
//                        CustomGalleryPickerView2(isGalleryPickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: previousSticker ,replaceImage: $replaceSticker,  cropStyle: .ratios, aspectSize: CGSize.zero,fixedAspectRatio : false , needFaceDetection : false )
                           
                        CustomGalleryPickerView2(isGalleryPickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: previousSticker, replaceImage:  $replaceSticker,cropStyle: .ratios, aspectSize: CGSize.zero, fixedAspectRatio: false, needFaceDetection: false)
                            .presentationDetents([.height(150)])
            
                    }
            
            // .background()
            //        }
        }
//        .fullScreenCover(isPresented: $didGalleryButtonClicked, onDismiss: {
//            if !didGalleryButtonClicked {
//                isStickerPickerPresented = false
//            }
//        }, content: {
//            CustomGalleryPickerView2(isGalleryPickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: previousSticker ,replaceImage: $replaceSticker, cropStyle: .ratios, aspectSize: CGSize.zero)
//                .presentationDetents([.height(150)])
//
//        })
//        .sheet(isPresented: $didGalleryButtonClicked, onDismiss: {
//            // Prevent StickerPicker from dismissing when ImagePickerView closes
//            if !didGalleryButtonClicked {
//                isStickerPickerPresented = false
//            }
//        }) {
////            ImagePickerView(isImagePickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: $previousSticker, replaceImage: $replaceSticker, type: $cropType, ratioInfo: $ratioInfo, updateThumb: $updateThumb).interactiveDismissDisabled()
//            
//           // CustomGalleryPickerView(isGalleryPickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: previousSticker ,replaceImage: $replaceSticker, cropStyle: .ratios, aspectSize: CGSize.zero).interactiveDismissDisabled()
//            CustomGalleryPickerView2(isGalleryPickerPresented: $didGalleryButtonClicked, addImage: $newStickerAdded, previousImage: previousSticker ,replaceImage: $replaceSticker, cropStyle: .ratios, aspectSize: CGSize.zero)
//                .presentationDetents([.height(150)])
//
//            
//        }
    }
}
