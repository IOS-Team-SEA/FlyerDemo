//
//  UnsplashView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 18/03/24.
//

import SwiftUI

struct Photo: Codable, Identifiable, Hashable {
    let id: String
    let urls: [String: String]
    var category: String?
}


//struct UnsplashView: View {
//    var shared = NetworkManager.shared
////    @ObservedObject var viewModel: SwiftUIViewModel
//    @State var selectedImage: UIImage?
//    @State private var categories: [String] = [
//        "Landscape_".translate(),
//        "Portrait_".translate(),
//        "Street_Photography".translate(),
//        "Wildlife_".translate(),
//        "Nature_".translate(),
//        "Macro_".translate(),
//        "Architecture_".translate(),
//        "Travel_".translate(),
//        "Black_and_White".translate(),
//        "Fine_Art".translate()
//    ]
//    @Binding var addImage: UIImage?
//    @Binding var isImagePickerPresented : Bool
//    
//    @State private var cachedPhotosByCategory: [String: [Photo]] = [:]
//    var customRatio: CGSize
//    @Binding var type: ImageCropperType
//    @Binding var cropRect: CGRect
//    
//    var body: some View {
//        ScrollView (.vertical){
//            if cachedPhotosByCategory.isEmpty{
//                Spacer()
//                ProgressView()
//                    .frame(width: 100, height: 100)
//                Spacer()
//            }else{
//                LazyVStack{
//                    ForEach(categories, id: \.self) { category in
//                        UnsplashItem(category: category, photos: cachedPhotosByCategory[category] ?? [], selectedImage: $selectedImage, addImage: $addImage, isImagePickerPresented: $isImagePickerPresented, cropRect: $cropRect, type: $type, ratioSize: customRatio)
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal, 10)
//            }
//        }
//        .onAppear {
//            Task {
//                do {
//                     cachedPhotosByCategory = try await shared.fetchData(for: categories)
//                } catch {
//                    print("Error fetching data: \(error)")
//                }
//            }
//        }
//    }
//}

//#Preview {
//    UnsplashView(addImage: .constant(ImageModel(imageType: .IMAGE, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .SERVER, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)), isImagePickerPresented: .constant(false), customRatio: CGSize(width: 1, height: 1), type: .constant(.ratios))
//}
