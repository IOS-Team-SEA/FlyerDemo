//
//  UnsplashItem.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 18/03/24.
//

import SwiftUI

//struct UnsplashItem: View {
//    var category: String
//    var photos: [Photo]
//    @Binding var selectedImage : UIImage?
//    @Namespace var animations
//    var shared = NetworkManager.shared
//    @Binding var addImage: UIImage?
//    @Binding var isImagePickerPresented : Bool
//    @State var isCropperViewPresented: Bool = false
//    @Binding var cropRect: CGRect
//    @Binding var type: ImageCropperType
//    var ratioSize: CGSize
//    
//    var body: some View {
//        VStack {
//            HStack{
//                Text(category)
////                    .padding(.leading, -180)
//                Spacer()
//                
//                NavigationLink("See_All"){
//                    ScrollView(.vertical, showsIndicators: false){
//                        StaggeredGridView(columns: 2, list: photos) { photo in
//                            UnsplashDetailView(photo: photo, addImage: $addImage, isImagePickerPresented: $isImagePickerPresented, cropRect: $cropRect, type: $type, customRatio: ratioSize)
//                                .matchedGeometryEffect(id: photo.id, in: animations)
//                            
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal, 10)
//                        .navigationTitle(category)
//                        .padding(.vertical)
//                    }
////                    .navigationTitle(category)
//                }
//                .font(.caption)
//                .foregroundColor(AppStyle.accentColor_SwiftUI)
//            }
//            ScrollView (.horizontal){
//                LazyHStack {
//                    ForEach(photos, id: \.id) { photo in
//                        Button(action: {
//                            
//                            if let fullURLString = photo.urls["regular"], let fullURL = URL(string: fullURLString) {
//                                Task{
//                                    do {
//                                        selectedImage = try await shared.fetchImage(from: fullURL)
//                                        addImage = selectedImage
//                                        isCropperViewPresented = true
//                                            
//                                        print("Image fetched successfully!")
//                                    } catch {
//                                        print("Error fetching image: \(error)")
//                                    }
//                                }} else {
//                                 print("Invalid URL")
//                             }
//                        }){
//                            UnsplashRow(photo: photo , isImagePickerPresented: $isImagePickerPresented)
//                        }
//                        .sheet(isPresented: $isCropperViewPresented){
////                            ImageEditor(newImage: $addImage, image: selectedImage ?? UIImage(systemName: "xmark.octagon")!, isShowing: $isImagePickerPresented, type: $type, isCropperiewPresented: $isCropperViewPresented, cropRect: $cropRect, customRatio: ratioSize)
//                        }
////                        .onChange(of: cropRect) { newCrop in
//////                            do{
//////                                let uuid = UUID()
//////                                if let imageData = selectedImage?.pngData() {
//////                                    var file = File(name: "\(uuid)", data: imageData, fileExtension: "png")
//////                                    try AppFileManager.shared.assets?.addFile(file: &file)
//////                                    addImage = ImageModel(imageType: .IMAGE, serverPath: "", localPath: "\(uuid)", cropRect: newCrop, sourceType: .DOCUMENT, tileMultiple: 1.0, cropType: .ratios)
//////                                }
//////                            }catch{
//////                                print("image is not downloaded for local Path Path")
//////                            }
////                            
////                        }
//                        
//                    }
//                }
//            }
//        }
//    }
//}

//#Preview {
//    UnsplashItem()
//}

//struct UnsplashDetailView: View {
//    
//    var photo: Photo
//    
//    @State var selectedImage : UIImage?
//    var shared = NetworkManager.shared
//    @Binding var addImage: UIImage?
//    @Binding var isImagePickerPresented : Bool
//    @State var isCropperViewPresented: Bool = false
//    @Binding var cropRect: CGRect
//    @Binding var type: ImageCropperType
//    var customRatio: CGSize
//    
//    var body: some View {
//        
//        VStack{
//            if let image = selectedImage{
//                SwiftUI.Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                //                    .frame(maxWidth: .infinity)
//                    .cornerRadius(10)
//                    .shadow(radius: 4.0)
//                    .onTapGesture {
//                        addImage = image
//                        isCropperViewPresented = true
//                    }
//                    .sheet(isPresented: $isCropperViewPresented){
////                        ImageEditor(newImage: $addImage, image: image, isShowing: $isImagePickerPresented, type: $type, isCropperiewPresented: $isCropperViewPresented, cropRect: $cropRect, customRatio: customRatio)
//                    }
////                    .onChange(of: cropRect) { newCrop in
////                        
//////                        do{
//////                            let uuid = UUID()
//////                            if let imageData = image.pngData() {
//////                                var file = File(name: "\(uuid)", data: imageData, fileExtension: "png")
//////                                try AppFileManager.shared.assets?.addFile(file: &file)
//////                                addImage = ImageModel(imageType: .IMAGE, serverPath: "", localPath: "\(uuid)", cropRect: newCrop, sourceType: .DOCUMENT, tileMultiple: 1.0, cropType: .ratios)
//////                            }
//////                        }catch{
//////                            print("image is not downloaded for local Path Path")
//////                        }
////                        
////
////                    }
//                    
//            }
//        }
//        .onAppear(){
//            if let fullURLString = photo.urls["regular"], let fullURL = URL(string: fullURLString) {
//                Task{
//                    do {
//                        selectedImage = try await shared.fetchImage(from: fullURL)
//                        print("Image fetched successfully!")
//                    } catch {
//                        print("Error fetching image: \(error)")
//                    }
//                }} else {
//                 print("Invalid URL")
//             }
//        }
//        
//    }
//}
