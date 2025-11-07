////
////  ImagePickerView.swift
////  VideoInvitation
////
////  Created by SEA PRO2 on 18/03/24.
////
//
//import SwiftUI
//import IOS_LoaderSPM
//
//
//
//struct ImagePickerView: View {
//    
//    @State private var selection: ImagePickerTab = .gallery
//    @State var selectedImageURL: URL?
//    @Binding var isImagePickerPresented: Bool
//    @State private var selectedImage: UIImage?
//    @State private var isLoading = true
//    @State var isCropperViewPresented = false
//    @Binding var addImage: ImageModel?
//    @Binding var previousImage : ImageModel?
//    @Binding var replaceImage : ImageModel?
//    
//    @State var cropRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
//    @Binding var type: ImageCropperType
//    @State var cropType : ImageCropperType = .faceDetection
//    @State var isShowingFiles: Bool = false
////    var ratioSize: CGSize
//    @Binding var ratioInfo: RatioInfo?
//    @Binding var updateThumb: Bool
//    @State var isDetectingFace : Bool = false
//    @State var detectBothFace : Bool = false
//    @State var rect = CGRect.zero
//    
//    enum ImagePickerTab {
//        case files
//        case unsplash
//        case gallery
//    }
//    
//    var body: some View {
//            if isLoading {
//                // Show a loader while the ImagePicker is loading
//                ProgressView("Loading_Image_Picker")
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .task {
//                        Task.detached {
//                            sleep(UInt32(0.5))
//                            await MainActor.run {
//                                isLoading = false
//                            }
//                            
//                        }
//                    }
//                
//                
//                
//            } else {
//                TabView(selection: $selection) {
//                    galleryTab
//                        .tabItem {
//                            Label("Gallery_", systemImage: "photo.fill")
//                        }
//                        .tag(ImagePickerTab.gallery)
//                    
//                    //            unsplashTab
//                    //                .tabItem {
//                    //                    Label("Unsplash_", systemImage: "music.note")
//                    //                }
//                    //                .tag(ImagePickerTab.unsplash)
//                    
//                    filesTab
//                        .tabItem {
//                            Label("Files_", systemImage: "filemenu.and.cursorarrow")
//                        }
//                        .tag(ImagePickerTab.files)
//                }
//                .accentColor(AppStyle.accentColor_SwiftUI)
//                .onChange(of: addImage) { _ in
//                    isImagePickerPresented = false
//                }
//                .onChange(of: replaceImage) { _ in
//                    isImagePickerPresented = false
//                }
//                .onChange(of: cropRect) { newCrop in
//                    
//                    do{
//                        let uuid = UUID()
//                        if let imageData = selectedImage?.pngData() {
//                            var file = File(name: "\(uuid)", data: imageData, fileExtension: "png")
//                            try AppFileManager.shared.localAssets?.addFile(file: &file)
//                            if previousImage != nil && !detectBothFace{
//                                replaceImage = ImageModel(imageType: .IMAGE, serverPath: "", localPath: "\(uuid).png", cropRect: newCrop, sourceType: .DOCUMENT, tileMultiple: 1.0, cropType: (previousImage?.cropType) ?? .ratios, imageWidth : 300 ,imageHeight : 300)
//                            }
//                            else{
//                                addImage = ImageModel(imageType: .IMAGE, serverPath: "", localPath: "\(uuid).png", cropRect: newCrop, sourceType: .DOCUMENT, tileMultiple: 1.0, cropType: (previousImage?.cropType) ?? .ratios, imageWidth : 300 ,imageHeight : 300)
//                            }
//                            updateThumb = true
//                        }
//                    }catch{
//                        print("image is not downloaded for local Path Path")
//                    }
//                    
//                    
//                }
//            }
//            
//        }
//        
//        private var galleryTab: some View {
//            NavigationView{
//                // Show the ImagePicker once it's ready
//                ImagePicker(sourceType: .photoLibrary) { image in
//                    Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "Fetching_Image".translate())
//                    // Handle the selected image
//                    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 500, height: 500))
//                    selectedImage = resizedImage//image
//                    
//                    Loader.stopLoader()
//                     
////                    isCropperViewPresented = true
//                } imagePickerDismiss: { value in
//                    isImagePickerPresented = false
//                }
//                .onChange(of: isDetectingFace, perform: { newValue in
//                    if newValue {
//                        Loader.shared.setAnimationFile("faceDetection")
//                        Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "AI Detecting Face".translate())
//                    }
//                    else{
//                        Loader.stopLoader()
//                    }
//                })
//                .onChange(of: selectedImage) { newImage in
//                    print("Image changed, attempting face detection")
//                    guard let resizedImage = resizeImage(image: newImage ?? UIImage(systemName: "xmark.octagon")!, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)) else {
//                        print("Resized image is nil")
//                        return
//                    }
//                    Task {
//                        await detectFaceAndAlignWithPrevious(image: resizedImage)
//                    }
//                }
//                
//                .onChange(of: rect) { rect in
//                    isCropperViewPresented = true
//                   // cropRect = rect
//                }
//                .sheet(isPresented: $isCropperViewPresented) {
//                    // NK resize the image before sending it on crop editor.
//                    let resizedImage = resizeImage(image: selectedImage ?? UIImage(systemName: "xmark.octagon")!, targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//
//                    ImageEditor(faceDetectedCroprect : rect, newImage: $addImage, image: resizedImage ?? UIImage(systemName: "xmark.octagon")!, isShowing: $isImagePickerPresented, type: $cropType, isCropperiewPresented: $isCropperViewPresented, cropRect: $cropRect,
//                                /*customRatio: ratioSize*/ratioInfo: $ratioInfo).interactiveDismissDisabled()
//                    
//                   
//                }
//            }
//            .navigationViewStyle(.stack)
//        }
//        
//        private var filesTab: some View {
//            NavigationView{
//                Button {
//                    isShowingFiles = true
//                } label: {
//                    Text("Import_from_Files")
//                        .foregroundColor(.white)
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .frame(width: 200, height: 50)
//                }
//                .frame(width: 200, height: 50)
//                .background(AppStyle.accentColor_SwiftUI)
//                .cornerRadius(8)
//                .fileImporter(isPresented: $isShowingFiles, allowedContentTypes: [.image], allowsMultipleSelection: false, onCompletion: { results in
//                    
//                    switch results {
//                    case .success(let fileurls):
//                        
//                        if let selectedURL = fileurls.first {
//                            if selectedURL.startAccessingSecurityScopedResource() {
//                                
//                                defer { selectedURL.stopAccessingSecurityScopedResource() }
//                                if let imageData = try? Data(contentsOf: selectedURL), let image = UIImage(data: imageData) {
//                                    selectedImage = image
//                                    isCropperViewPresented = true
//                                }else{
//                                    print("failed to load image from files")
//                                }
//                            }
//                        }
//                        
//                    case .failure(let error):
//                        print(error)
//                    }
//                    
//                })
//                .onChange(of: isDetectingFace, perform: { newValue in
//                    if newValue {
//                        Loader.shared.setAnimationFile("faceDetection")
//                        Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "AI Detecting Face".translate())
//                    }
//                    else{
//                        Loader.stopLoader()
//                    }
//                })
//                .sheet(isPresented: $isCropperViewPresented) {
//                    ImageEditor(newImage: $addImage, image: selectedImage ?? UIImage(systemName: "xmark.octagon")!, isShowing: $isImagePickerPresented, type: $type, isCropperiewPresented: $isCropperViewPresented, cropRect: $cropRect, /*customRatio: ratioSize*/ratioInfo: $ratioInfo).interactiveDismissDisabled()
//                }
//                .navigationBarItems(leading: Button(action: {
//                    // Action for done button
//                    doneButtonTapped()
//                }) {
//                    Text("Cancel_")
//                })
//                
//            }
//            .navigationViewStyle(.stack)
//            
//        }
//        
//        private func doneButtonTapped() {
//            // Action for done button
//            isImagePickerPresented = false
//            print("Done button tapped")
//            // Add your action here
//        }
//        
//    private func detectFaceForFailedCondition(image: UIImage){
//        detectFace(image: image) { faceRect in
//            if let faceRect = faceRect {
//                isDetectingFace = false
//                //isCropperViewPresented = true
//                rect = CGRect(x: faceRect.origin.x / image.mySize.width,
//                              y: faceRect.origin.y / image.mySize.height,
//                              width: faceRect.size.width / image.mySize.width,
//                              height: faceRect.size.height / image.mySize.height)
//                
//            }
//            else {
//                rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//            }
//        }
//    }
//    
//    private func detectFaceAndAlignWithPrevious(image: UIImage) async {
//        guard let previousImageModel = previousImage else {
//            detectFaceForFailedCondition(image: image)
//            return
//        }
//        
//        isDetectingFace = true
//        
//        do {
//            // Get previous image
//            guard let previousImage = await previousImageModel.getImage() else {
//                isDetectingFace = false
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            // Resize previous image
//            guard let resizedPrevious = resizeImage(
//                image: previousImage,
//                targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            ) else {
//                isDetectingFace = false
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            // Calculate old rect
//            let prevRect = previousImageModel.cropRect
//            let imageSize = resizedPrevious.mySize
//            let oldRect = CGRect(
//                x: prevRect.origin.x * imageSize.width,
//                y: prevRect.origin.y * imageSize.height,
//                width: prevRect.size.width * imageSize.width,
//                height: prevRect.size.height * imageSize.height
//            )
//            
//            // Crop and detect faces
//            guard let croppedPreviousImage = cropImage(image: resizedPrevious, faceBoundingBox: oldRect) else {
//                isDetectingFace = false
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            // Convert callback-based face detection to async
//            let oldFaceRect = await withCheckedContinuation { continuation in
//                detectFace(image: croppedPreviousImage) { result in
//                    continuation.resume(returning: result)
//                }
//            }
//            
//            guard let oldFaceRect = oldFaceRect else {
//                isDetectingFace = false
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            // Detect face in new image
//            let newFaceRect = await withCheckedContinuation { continuation in
//                detectFace(image: image) { result in
//                    continuation.resume(returning: result)
//                }
//            }
//            
//            guard let newFaceRect = newFaceRect else {
//                isDetectingFace = false
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            // Calculate crop rect
//            let cropDenRect = getUserImageCropRect(
//                previousFaceRect: oldFaceRect,
//                previousImageWidth: croppedPreviousImage.mySize.width,
//                previousImageHeight: croppedPreviousImage.mySize.height,
//                userFaceRect: newFaceRect,
//                userImageWidth: image.mySize.width,
//                userImageHeight: image.mySize.height
//            ) ?? newFaceRect
//            
//            // Calculate normalized rect
//            let normalizedCropRect = CGRect(
//                x: cropDenRect.origin.x / image.mySize.width,
//                y: cropDenRect.origin.y / image.mySize.height,
//                width: cropDenRect.size.width / image.mySize.width,
//                height: cropDenRect.size.height / image.mySize.height
//            )
//            
//            // Update UI on main thread
//            await MainActor.run {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                    isDetectingFace = false
//                    rect = normalizedCropRect
//                })
//            }
//            
//        } catch {
//            await MainActor.run {
//                isDetectingFace = false
//                detectFaceForFailedCondition(image: image)
//            }
//        }
//    }
//        
//
//        
//        
//        func replaceImage(selectedImage: UIImage?, newCrop: CGRect) {
//            do {
//                let uuid = UUID()
//                if let imageData = selectedImage?.pngData() {
//                    var file = File(name: "\(uuid)", data: imageData, fileExtension: "png")
//                    try AppFileManager.shared.localAssets?.addFile(file: &file)
//                    replaceImage = ImageModel(
//                        imageType: .IMAGE,
//                        serverPath: "",
//                        localPath: "\(uuid).png",
//                        cropRect: newCrop,
//                        sourceType: .DOCUMENT,
//                        tileMultiple: 1.0,
//                        cropType: (previousImage?.cropType) ?? .ratios,
//                        imageWidth: previousImage?.imageWidth ?? 300,
//                        imageHeight: previousImage?.imageHeight ?? 300
//                    )
//                }
//            } catch {
//                print("Image is not downloaded for local path")
//            }
//        }
//}
//
//
///// Crop the detected face from the image
//func cropImage(image: UIImage, faceBoundingBox: CGRect) -> UIImage? {
//    guard let cgImage = image.cgImage?.cropping(to: faceBoundingBox) else { return nil }
//    return UIImage(cgImage: cgImage)
//}
