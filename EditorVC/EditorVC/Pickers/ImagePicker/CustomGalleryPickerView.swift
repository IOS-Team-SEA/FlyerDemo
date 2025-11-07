//
//  GalleryPickerView.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 05/04/25.
//

import SwiftUI
import IOS_LoaderSPM
import UnifiedPickerKit
import IOS_DiagnosticsSPM

enum NeedFaceDetectionEnum{
    case personalise
    case editor
}

//struct CustomGalleryPickerView: View {
//    @State private var selection: ImagePickerTab = .gallery
//    @State var selectedImageURL: URL?
//    @State private var selectedImage: UIImage?
//    @State private var isLoading = true
//    @State var isCropperViewPresented = false
//    @State var cropRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
//    @State var isShowingFiles: Bool = false
//    @State var isDetectingFace : Bool = false
//    @State var detectBothFace : Bool = false
//    @State var rect = CGRect.zero
//    @State var didInformCropperView : Bool = false
//    @State var isGalleyActive : Bool = false
//    @State var isFilesActive : Bool = false
//    
//    // Binding that come from outiside.
//    @Binding var isGalleryPickerPresented: Bool
//    @Binding var addImage: ImageModel?
//    var previousImage : ImageModel?
//    @Binding var replaceImage : ImageModel?
//    var cropStyle: ImageCropperType
//    @State var aspectSize : CGSize
//    var needCropperPresentedOrNot : NeedFaceDetectionEnum? = .editor // Enum
//    @State var updateCropRectOrPresentCropper: Bool = false
//    var faceDetector : FaceDetector = FaceDetector()
//
//    enum ImagePickerTab {
//        case files
//        case unsplash
//        case gallery
//    }
//    
//    
//    var body: some View {
//        if isLoading {
//            // Show a loader while the ImagePicker is loading
//            ProgressView("Loading_Image_Picker")
//                .progressViewStyle(CircularProgressViewStyle())
//                .task {
//                    Task.detached {
//                        sleep(UInt32(0.5))
//                        await MainActor.run {
//                            isLoading = false
//                        }
//                        
//                    }
//                }
//        }
//        else {
//            
////            TabView(selection: $selection) {
////                galleryTab
////                    .tabItem {
////                        Label("Gallery_", systemImage: "photo.fill")
////                    }
////                    .tag(ImagePickerTab.gallery)
////                filesTab
////                    .tabItem {
////                        Label("Files_", systemImage: "filemenu.and.cursorarrow")
////                    }
////                    .tag(ImagePickerTab.files)
////            }
//            VStack {
//                // Content area shows first
//                if selection == .gallery {
//                    galleryTab
//                } else {
//                    filesTab
//                }
//                
//                Spacer() // This pushes the content up and the picker down
//                
//                // Picker at the bottom
////                Picker("", selection: $selection) {
////                    Label("Gallery_", systemImage: "photo.fill").tag(ImagePickerTab.gallery)
////                    Label("Files_", systemImage: "filemenu.and.cursorarrow").tag(ImagePickerTab.files)
////                }
////                .pickerStyle(SegmentedPickerStyle())
////                .padding(.bottom) // Add some padding at the bottom for better spacing
//                
//                customTabBar
//            }
//            .accentColor(AppStyle.accentColor_SwiftUI)
//            .onChange(of: cropRect) { newCrop in
//                do{
//                    let uuid = UUID()
//                    if let imageData = selectedImage?.pngData() {
//                        var file = File(name: "\(uuid)", data: imageData, fileExtension: "png")
//                        try AppFileManager.shared.localAssets?.addFile(file: &file)
//                        if previousImage != nil{
//                            replaceImage = ImageModel(imageType: .IMAGE, serverPath: "", localPath: "\(uuid).png", cropRect: newCrop, sourceType: .DOCUMENT, tileMultiple: 1.0, cropType: (previousImage?.cropType) ?? .ratios, imageWidth : 1000 ,imageHeight : 1000)
//                            isGalleryPickerPresented = false
//                        }
//                        else{
//                            addImage = ImageModel(imageType: .IMAGE, serverPath: "", localPath: "\(uuid).png", cropRect: newCrop, sourceType: .DOCUMENT, tileMultiple: 1.0, cropType: (previousImage?.cropType) ?? .ratios, imageWidth : 1000 ,imageHeight : 1000)
//                            isGalleryPickerPresented = false
//                        }
//                    }
//                }
//                catch{
//                    print("image is not downloaded for local Path Path")
//                }
//                
//                
//            }
//        }
//        
//    }
//        
//        private var galleryTab: some View {
//            NavigationView{
//                // Show the ImagePicker once it's ready
////                ImagePicker(sourceType: .photoLibrary) { image in
////                    Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "Fetching Image...".translate())
////                    // Handle the selected image
////                    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 500, height: 500))
////                    selectedImage = resizedImage
////                    Loader.stopLoader()
////                } imagePickerDismiss: { reason in
////                    if reason{
////                        isGalleryPickerPresented = false
////                    }
////                }
//                PHImagePicker(onImagePicked: { image in
//                    Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "Fetching Image...".translate())
//                    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 3000, height: 3000))
//                    selectedImage = resizedImage
//                    Loader.stopLoader()
//                }, pickerDismissed: { wasCancelled in
//                    if wasCancelled{
//                        isGalleryPickerPresented = false
//                    }
//                })
//                .onChange(of: isDetectingFace, perform: { newValue in
//                    if newValue {
//                        Loader.shared.setAnimationFile("faceDetection")
//                        Loader.showLoader(in: UIApplication.shared.keyWindow!, text: "AI Detecting Face".translate())
//                    }
//                    else{
//                        Loader.stopLoader()
//                        Loader.shared.setAnimationFile("loader5")
//                    }
//                })
//                .onChange(of: selectedImage) { newImage in
//                    print("Image changed, attempting face detection")
//                    
//                    
//                    
//                    if let newImage = newImage{
//                        if aspectSize == .zero {
//                            aspectSize = newImage.mySize
//                            if previousImage != nil {
//                                
//                                aspectSize = (previousImage!.cropRect.size).into(previousImage!.imageWidth, previousImage!.imageHeight)
//                            }
//                        }
//                        
//                        Task {
//                            await detectFaceAndAlignWithPrevious(image: newImage)
//                        }
//                    }
//                }
//                
//                .onChange(of:  updateCropRectOrPresentCropper) { value in
//                    if updateCropRectOrPresentCropper{
//                        print("Call or Not")
//                        // If needCropperPresentedOrNot is true then show cropper.
//                        if let needCropperPresentedOrNot = needCropperPresentedOrNot, (needCropperPresentedOrNot == .editor){
//                            isCropperViewPresented = true
//                        }
//                        else if !detectBothFace{
//                            isCropperViewPresented = true
//                        }
//                        // If needCropperPresentedOrNot is false then don't show cropper directly update image
//                        else{
//                            cropRect = rect
//                        }
//                        updateCropRectOrPresentCropper = false
//                    }
//                }
//                .sheet(isPresented: $isCropperViewPresented) {
//                    // NK resize the image before sending it on crop editor.
//                    let resizedImage = resizeImage(image: selectedImage ?? UIImage(systemName: "xmark.octagon")!, targetSize: CGSize(width: 3000, height: 3000))
//                    
//                    Cropper(fixedAspectRatio:true,cropRect: $cropRect, image: resizedImage ?? UIImage(systemName: "xmark.octagon")!, isGalleryPickerPresented: $isGalleryPickerPresented, isCropperiewPresented: $isCropperViewPresented, didInformCropperView: $didInformCropperView, aspectSize: aspectSize, cropStyle: cropStyle, faceDetectedRect : rect).interactiveDismissDisabled()
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
//                                    let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 3000, height: 3000))
//                                    selectedImage = resizedImage
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
//                .onChange(of: selectedImage) { newImage in
//                    print("Image changed, attempting face detection")
//                    if let newImage = newImage{
//                        
//                        if aspectSize == .zero {
//                            aspectSize = newImage.mySize
//                            if previousImage != nil {
//                                aspectSize = (previousImage!.cropRect.size).into(previousImage!.imageWidth, previousImage!.imageHeight)
//                            }
//                        }
//                        
//                        Task {
//                            await detectFaceAndAlignWithPrevious(image: newImage)
//                        }
//                    }
//                }
//                .onChange(of: updateCropRectOrPresentCropper) { value in
//                    if updateCropRectOrPresentCropper{
//                        // If needCropperPresentedOrNot is true then show cropper.
//                        if let needCropperPresentedOrNot = needCropperPresentedOrNot, (needCropperPresentedOrNot == .editor){
//                            isCropperViewPresented = true
//                        }
//                        else if !detectBothFace{
//                            isCropperViewPresented = true
//                        }
//                        // If needCropperPresentedOrNot is false then don't show cropper directly update image
//                        else{
//                            cropRect = rect
//                        }
//                        updateCropRectOrPresentCropper = false
//                    }
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
//                .sheet(isPresented: $isCropperViewPresented) {
//                    Cropper(cropRect: $cropRect, image: selectedImage ?? UIImage(systemName: "xmark.octagon")!, isGalleryPickerPresented: $isGalleryPickerPresented, isCropperiewPresented: $isCropperViewPresented, didInformCropperView: $didInformCropperView, aspectSize: aspectSize, cropStyle: cropStyle, faceDetectedRect : rect).interactiveDismissDisabled()
//                    
////                    let config =  CropConfig(style: cropStyle == .circle ? .circle : .quad, form: .freestyle(aspect: image.mySize), initialNormalizedRect: previousImage!.cropRect)
////                     StandaloneCropper(image: image, cropConfig: config, isPresented: $isCropperiewPresented, logger: logger) { result in
////                         switch result {
////                         case .success(let payload):
////                             let cropped = payload.image
////                             let normalized = payload
////                             if var imageModel = previousImage , let cropRect = payload.normalisedCropRect {
////                                 if  imageModel.cropRect != payload.normalisedCropRect || imageModel.cropType != cropStyle{
////                                     imageModel.cropRect = cropRect
////                                     imageModel.cropType = cropStyle
////                                     replaceImage = imageModel
////                                 }
////                             }
////                             
////                             // use results
////                         case .failure(let error):
////                             // show toast/log
////                             print(error.localizedDescription)
////                         }
////                     }
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
//            
//        }
//        
//        private func doneButtonTapped() {
//            // Action for done button
//            isGalleryPickerPresented = false
//            print("Done button tapped")
//            // Add your action here
//        }
//    
//    
//    // Detect face if the condition failed for previous and new image.
//    private func detectFaceForFailedCondition(image: UIImage){
//        faceDetector.detectFaces(image: image) { faceRectArray in
////            if let faceRectArray = faceRectArray, faceRectArray.count == 1{
////                if let faceRect = faceRectArray.first {
////                    isDetectingFace = false
////                    //isCropperViewPresented = true
////                    rect = CGRect(x: faceRect.origin.x / image.mySize.width,
////                                  y: faceRect.origin.y / image.mySize.height,
////                                  width: faceRect.size.width / image.mySize.width,
////                                  height: faceRect.size.height / image.mySize.height)
////                    updateCropRectOrPresentCropper = true
////                    
////                }
////                else {
////                    rect = CGRect(x: 0, y: 0, width: 100, height: 100)
////                    updateCropRectOrPresentCropper = true
////                }
////            }
////            else {
////                rect = CGRect(x: 0, y: 0, width: 100, height: 100)
////                updateCropRectOrPresentCropper = true
////            }
//            isDetectingFace = false
//
//            guard let face = faceRectArray?.first, faceRectArray?.count == 1 else {
//                        // Fallback if no face found
//                        rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//                        updateCropRectOrPresentCropper = true
//                        return
//                    }
////
////                    // STEP 1: Add padding
////                    let paddingFactor: CGFloat = 0.2
//                    let imageWidth = image.mySize.width
//                    let imageHeight = image.mySize.height
////
////                    let paddingX = face.width * paddingFactor
////                    let paddingY = face.height * paddingFactor
////
////                    var padded = face.insetBy(dx: -paddingX, dy: -paddingY)
////
////                    // STEP 2: Expand padded rect to match required aspect ratio (e.g. previous crop's)
////                let targetAspect = aspectSize.width/aspectSize.height
////                    var adjusted = padded
////
////                    let currentAspect = padded.width / padded.height
////
////                    if currentAspect > targetAspect {
////                        // Too wide → increase height
////                        let newHeight = padded.width / targetAspect
////                        let delta = (newHeight - padded.height) / 2
////                        adjusted.origin.y -= delta
////                        adjusted.size.height = newHeight
////                    } else {
////                        // Too tall → increase width
////                        let newWidth = padded.height * targetAspect
////                        let delta = (newWidth - padded.width) / 2
////                        adjusted.origin.x -= delta
////                        adjusted.size.width = newWidth
////                    }
////
////                    // STEP 3: Clamp to stay inside image bounds
////                    if adjusted.origin.x < 0 { adjusted.origin.x = 0 }
////                    if adjusted.origin.y < 0 { adjusted.origin.y = 0 }
////                    if adjusted.maxX > imageWidth {
////                        adjusted.size.width = imageWidth - adjusted.origin.x
////                        adjusted.size.height = adjusted.width / targetAspect
////                    }
////                    if adjusted.maxY > imageHeight {
////                        adjusted.size.height = imageHeight - adjusted.origin.y
////                        adjusted.size.width = adjusted.height * targetAspect
////                    }
//
//            let adjusted  = faceDetector.cropRectWithFacePadding(faceRect: face, imageSize: image.mySize, aspectRatio: aspectSize.width/aspectSize.height)
//
//                    // STEP 4: Normalize to 0...1
//                    rect = CGRect(
//                        x: adjusted.origin.x / imageWidth,
//                        y: adjusted.origin.y / imageHeight,
//                        width: adjusted.size.width / imageWidth,
//                        height: adjusted.size.height / imageHeight
//                    )
//
//                    updateCropRectOrPresentCropper = true
//        }
//    }
//    
//    
//    // Function used for detect and align with previous image if failed then show cropper.
//    private func detectFaceAndAlignWithPrevious(image: UIImage) async {
//        printLog("FDP: -> Detecting Started ... ")
//        guard let previousImageModel = previousImage else {
//            printLog("FDP: -> previousImageModel is Nil ... ")
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
//                printLog("FDP: -> previousImageModel Image Is Nil ... ")
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            // Resize previous image
//            guard let resizedPrevious = resizeImage(
//                image: previousImage,
//                targetSize: CGSize(width: 3000 , height: 3000)
//            ) else {
//                isDetectingFace = false
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            let image =  resizeImage(
//                image: image,
//                targetSize: CGSize(width: 3000, height: 3000)
//            )!
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
//            printLog("FDP: -> OldRect \(oldRect) , AR: \(oldRect.width/oldRect.height) ")
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
//                faceDetector.detectFaces(image: croppedPreviousImage) { result in
//                    if let faces = result , faces.count == 1{
//                        continuation.resume(returning: faces.first)
//                    }
//                    else {
//                        continuation.resume(returning: nil)
//                    }
//                }
//            }
//            
//            guard let oldFaceRect = oldFaceRect  else {
////                isDetectingFace = false
//                printLog("FDP: -> No Old Face Rect Found ... ")
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            
//            
//            printLog("FDP: -> Old Face Rect Found ... Hurray ")
//            // Detect face in new image
//            let newFaceRect = await withCheckedContinuation { continuation in
//                faceDetector.detectFaces(image: image) { result in
//                    if let faces = result , faces.count == 1{
//                        continuation.resume(returning: faces.first)
//                    } else {
//                        continuation.resume(returning: nil)
//                    }
//                }
//            }
//
//
//            guard let newFaceRect = newFaceRect else {
//                isDetectingFace = false
//                printLog("FDP: -> New Face Rect Not Found ... Sad ")
//
//                detectFaceForFailedCondition(image: image)
//                return
//            }
//            printLog("FDP: -> New Face Rect Found ... Hurray ")
//            printLog("FDP: -> NewRect \(newFaceRect) , AR: \(newFaceRect.width/newFaceRect.height) ")
//
//            // Calculate crop rect
//            let cropDenRect = faceDetector.getUserImageCropRect(
//                previousFaceRect: oldFaceRect,
//                previousImageWidth: croppedPreviousImage.mySize.width,
//                previousImageHeight: croppedPreviousImage.mySize.height,
//                userFaceRect: newFaceRect,
//                userImageWidth: image.mySize.width,
//                userImageHeight: image.mySize.height
//            ) ?? newFaceRect
//            
//                
//            // Calculate normalized rect
//            let normalizedCropRect = CGRect(
//                x: cropDenRect.origin.x / image.mySize.width,
//                y: cropDenRect.origin.y / image.mySize.height,
//                width: cropDenRect.size.width / image.mySize.width,
//                height: cropDenRect.size.height / image.mySize.height
//            )
//            printLog("FDP: -> Face Detection Finished .. Exiting ")
//            printLog("FDP: -> FinalRect \(normalizedCropRect) , AR: \(normalizedCropRect.width/normalizedCropRect.height) ")
//
//            // Update UI on main thread
//            await MainActor.run {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                    isDetectingFace = false
//                    detectBothFace = true
//                    rect = normalizedCropRect
//                    updateCropRectOrPresentCropper = true
//                })
//            }
//            
//        }
//    }
//    
//    private var customTabBar: some View {
//        HStack(spacing: 0) {
//            tabButton(title: "Gallery_".translate(), systemImage: "photo.fill", tab: .gallery)
//            tabButton(title: "Files_".translate(), systemImage: "filemenu.and.cursorarrow", tab: .files)
//        }
//        .frame(height: 50)
//        .background(Color(UIColor.systemGray6))
//        .cornerRadius(10)
//        .padding()
//    }
//
//    private func tabButton(title: String, systemImage: String, tab: ImagePickerTab) -> some View {
//        Button(action: {
//            selection = tab
//        }) {
//            HStack {
//                Image(systemName: systemImage)
//                Text(title)
//            }
//            .foregroundColor(selection == tab ? .white : .primary)
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 12)
//            .background(selection == tab ? AppStyle.accentColor_SwiftUI : Color.clear)
//            .cornerRadius(8)
//        }
//    }
//
//    
//    // Used this function for replacing the image.
//    func replaceImage(selectedImage: UIImage?, newCrop: CGRect) {
//        do {
//            let uuid = UUID()
//            if let imageData = selectedImage?.pngData() {
//                var file = File(name: "\(uuid)", data: imageData, fileExtension: "png")
//                try AppFileManager.shared.localAssets?.addFile(file: &file)
//                replaceImage = ImageModel(
//                    imageType: .IMAGE,
//                    serverPath: "",
//                    localPath: "\(uuid).png",
//                    cropRect: newCrop,
//                    sourceType: .DOCUMENT,
//                    tileMultiple: 1.0,
//                    cropType: (previousImage?.cropType) ?? .ratios,
//                    imageWidth: previousImage?.imageWidth ?? 1000,
//                    imageHeight: previousImage?.imageHeight ?? 1000
//                )
//            }
//        } catch {
//            print("Image is not downloaded for local path")
//        }
//    }
//}

/// Crop the detected face from the image
func cropImage(image: UIImage, faceBoundingBox: CGRect) -> UIImage? {
    guard let cgImage = image.cgImage?.cropping(to: faceBoundingBox) else { return nil }
    return UIImage(cgImage: cgImage)
}



import SwiftUI
import Mantis
import IOS_CommonEditor

struct CustomGalleryPickerView2: View {
    // MARK: External bindings
    @Binding var isGalleryPickerPresented: Bool
    @Binding var addImage: ImageModel?
    var previousImage: ImageModel?
    @Binding var replaceImage: ImageModel?
    
    // MARK: UI / Options
    var cropStyle: ImageCropperType
    @State var aspectSize: CGSize
    @State public var fixedAspectRatio : Bool
    @State public var needFaceDetection : Bool
// desired aspect for crop
    var needCropperPresentedOrNot: NeedFaceDetectionEnum? = .editor
    
    // MARK: Local state
    @State private var showUnifiedPicker = false
    @State private var showFilesImporter = false
   // @State private var fileImage: UIImage? = nil
    @State private var showStandaloneCropper = false
    //@State private var normalizedPresetRect: CGRect? = nil
//    @State private var didInformCropperView = false
//    @State private var cropRect: CGRect = .zero
    
    private struct CropperPayload: Identifiable {
        let id = UUID()
        let image: UIImage
        var normalizedPresetRect : CGRect? = nil
    }
    @State private var cropperPayload: CropperPayload?

    // Strategy we’ll reuse (new image → preset rect)
    @State private var faceStrategy: FaceDetectionStrategy?

    let detector = FaceDetector() // your existing detector
    let myLogger = MyLogger()
    let myLoader = MyLoaderForPicker()

    // For Future To Show Recents
    
//    struct IIMage : Identifiable , Hashable {
//        var id: Int = UUID().hashValue
//        
//        var data : Data
//        var imageName : String
//        
//    }
//    let columns = [
//        GridItem(.flexible(), spacing: 5),
//        GridItem(.flexible(), spacing: 5)
//    ]
//    @State var arrayOfImages = [IIMage]()
//    func fetchRecents() {
//       // var arrayOfImages = [IIMage]()
//        var imagesPath = try? AppFileManager.shared.localAssets?.listContents()
//        if let paths = imagesPath , !paths.isEmpty {
//            paths.forEach { path in
//                
//                if var imageName = path.components(separatedBy: "/").last, var imgData = AppFileManager.shared.localAssets?.readDataFromFile(fileName: imageName) {
//                    arrayOfImages.append(IIMage(data: imgData, imageName: imageName))
//                }
//                
//            }
//        }
//        
//    }
    
    
    var body: some View {
        HStack(spacing: 16) {
            VStack{
                Image(systemName: "photo.fill")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 30, height: 30)
                
                Text("Gallery_")
                    .font(.subheadline)
            }
            .onTapGesture {
                showUnifiedPicker = true
            }
            .frame(width: 120, height: 80)
            .background(Color.secondarySystemBackground)
            .cornerRadius(5)
            
            VStack{
                Image(systemName:"filemenu.and.cursorarrow")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 30, height: 30)
                
                Text("Files_")
                    .font(.subheadline)
            }
            .onTapGesture {
                showFilesImporter = true
            }
            .frame(width: 120, height: 80)
            .background(Color.secondarySystemBackground)
            .cornerRadius(5)
            
            
           
        }
        .sheet(isPresented: $showUnifiedPicker) {
            unifiedPickerSheet
        }
        .fileImporter(
            isPresented: $showFilesImporter,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            handleFilesImport(result)
        }
        .sheet(item: $cropperPayload, content: { cropperPayload in
            let cropConfig = CropConfig(style: cropStyle == .circle ? .circle : .quad , form: fixedAspectRatio ? .locked(aspect: aspectSize ) : .freestyle(aspect: aspectSize ), initialNormalizedRect: cropperPayload.normalizedPresetRect)
            
            StandaloneCropper(image: cropperPayload.image, cropConfig: cropConfig, isPresented: $showStandaloneCropper, logger: myLogger) { result in
                switch result {
                    case .success(let payload):
                        let cropped = payload.image
                        let normalized = payload
                    if let cropRect = payload.normalisedCropRect {
                            persistSelection(with: cropRect, fromImage: cropperPayload.image)
                        }
                    
                   
                
                // use results
            case .failure(let error):
                // show toast/log
                    print(error.localizedDescription)
            }
            }
            .interactiveDismissDisabled()
        })
//        .sheet(isPresented: $showStandaloneCropper) {
//            if let image = fileImage {
//                
//                // Standalone cropper seeded with normalizedPresetRect
////                Cropper(
////                    fixedAspectRatio: fixedAspectRatio,
////                    cropRect: $cropRect,
////                    image: image,
////                    isGalleryPickerPresented: $isGalleryPickerPresented,
////                    isCropperiewPresented: $showStandaloneCropper,
////                    didInformCropperView: $didInformCropperView,
////                    aspectSize: aspectSize,
////                    cropStyle: cropStyle,
////                    faceDetectedRect: normalizedPresetRect
////                )
//               // .interactiveDismissDisabled()
//                let cropConfig = CropConfig(style: cropStyle == .circle ? .circle : .quad , form: fixedAspectRatio ? .locked(aspect: aspectSize ) : .freestyle(aspect: aspectSize ), initialNormalizedRect: normalizedPresetRect)
//                StandaloneCropper(image: image, cropConfig: cropConfig, isPresented: $showStandaloneCropper, logger: myLogger) { result in
//                    switch result {
//                        case .success(let payload):
//                            let cropped = payload.image
//                            let normalized = payload
//                            if  let image = fileImage , let cropRect = payload.normalisedCropRect {
//                                persistSelection(with: cropRect, fromImage: image)
//                            }
//                        
//                       
//                    
//                    // use results
//                case .failure(let error):
//                    // show toast/log
//                        logError(error.localizedDescription)
//                }
//                }
//                .interactiveDismissDisabled()
//            } else {
//                Text("Issue")
//            }
//        }
        .onAppear {
            configureStrategy()
           // fetchRecents()
        }
//        .onChange(of: cropRect) { newCrop in
//            persistSelection(with: newCrop, fromImage: fileImage)
//        }
    }
    
    // MARK: Unified picker sheet
    
    private var unifiedPickerSheet: some View {
        UnifiedImagePicker(
            isPresented: $showUnifiedPicker,
            shouldPresentCropper: false,
            mode: .photoLibrary,
            allowFaceDetection: false,
            faceStrategy: nil,                // ⬅️ the DI point
//            loader: myLoader,
            logger: myLogger,
            fetchingText: "Fetching Image…"
        ) { result in
            switch result {
            case .success(let payload):
                myLoader.show(text: "Loading_".translate())
                handleGalleryImport(payload)
                // payload.image = final cropped image
                // payload.cropInfo = optional Mantis crop info (if you surfaced it)
//                let finalImage = payload.image
//                
//                // create / replace model
//                let uuid = UUID().uuidString
//                if let data = finalImage.pngData() {
//                    var file = File(name: uuid, data: data, fileExtension: "png")
//                    try? AppFileManager.shared.localAssets?.addFile(file: &file)
//                    if let prev = previousImage {
//                        // Replace flow
//                        replaceImage = ImageModel(imageType: .IMAGE,
//                                                  serverPath: "",
//                                                  localPath: "\(uuid).png",
//                                                  cropRect: /* if you store normalized from Mantis: */ cropRect,
//                                                  sourceType: .DOCUMENT,
//                                                  tileMultiple: 1.0,
//                                                  cropType: prev.cropType,
//                                                  imageWidth: prev.imageWidth,
//                                                  imageHeight: prev.imageHeight)
//                    } else {
//                        // Add new
//                        addImage = ImageModel(imageType: .IMAGE,
//                                              serverPath: "",
//                                              localPath: "\(uuid).png",
//                                              cropRect: cropRect,
//                                              sourceType: .DOCUMENT,
//                                              tileMultiple: 1.0,
//                                              cropType: .ratios,
//                                              imageWidth: Double(finalImage.mySize.width),
//                                              imageHeight: Double(finalImage.mySize.height))
//                    }
//                    isGalleryPickerPresented = false
//                }
                
            case .failure(let e):
                print("UnifiedImagePicker failed: \(e)")
                isGalleryPickerPresented = false
            }
        }
    }
    
    // MARK: Strategy config
    
    private func configureStrategy() {
        // Infer aspect if missing
        if aspectSize == .zero {
            if let prev = previousImage {
                aspectSize = prev.cropRect.size.into(prev.imageWidth, prev.imageHeight) // your helper
            } else {
                aspectSize = CGSize(width: 1, height: 1)
            }
        }
        if !needFaceDetection {
            return
        }
        
        if let prev = previousImage  {
            Task {
                let prevUIImage = await prev.getImage(engineConfig: AppEngineConfigure())
                await MainActor.run {
                    if let img = prevUIImage {
                        faceStrategy = AlignWithPreviousStrategy(
                            detector: detector,
                            aspectSize: aspectSize,
                            previousImage: img,
                            previousCrop: prev.cropRect
                        )
                    } else {
                        faceStrategy = SingleFaceStrategy(detector: detector, aspectSize: aspectSize)
                    }
                }
            }
        } else {
                faceStrategy = SingleFaceStrategy(detector: detector, aspectSize: aspectSize)
            
        }
    }
        
    
    func handleGalleryImport(_ result : UnifiedImagePickerResult) {
        let finalImage = result.image
       
         // Pre-scale to your target (3k) before detection/cropper
         
         Task {
             // Ask strategy for preset (normalized)
             let faceRect = await faceStrategy?.computeRect(image:  finalImage , aspectRatio: aspectSize.aspect)
             await MainActor.run {
                 //self.fileImage = finalImage
                 myLoader.hide()
                 if let faceRect = faceRect , faceRect != .zero {
                   //  self.normalizedPresetRect = faceRect
                     if needCropperPresentedOrNot == .editor {
                         self.showStandaloneCropper = true
                         var  load = CropperPayload(image: finalImage )
                         load.normalizedPresetRect = faceRect
                         cropperPayload = load

                     } else {
                         let oldFace = faceStrategy?.oldImageHasFace

                         if oldFace == false  {
                             self.showStandaloneCropper = true
                             var  load = CropperPayload(image: finalImage )
                             load.normalizedPresetRect = nil
                             cropperPayload = load
                            
                         }else {
                             persistSelection(with: faceRect, fromImage: finalImage)
                         }
                     }
                 }else {
                     
                    
                                    // if you have your skip-cropper logic, put it here before presenting
                                    self.showStandaloneCropper = true
                     cropperPayload = CropperPayload(image: finalImage)
                     
                 }
                
                 
                 
             }
         }
     

    }
    
        // MARK: Files flow
        
        func handleFilesImport(_ result: Result<[URL], Error>) {
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                guard url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }
                
                if let data = try? Data(contentsOf: url),
                   let img = UIImage(data: data) {
                    // Pre-scale to your target (3k) before detection/cropper
//                    let resized = resizeImage(image: img, targetSize: CGSize(width: 3000, height: 3000))
                    let resized =  resizeToSquareLongSide(image: img, side: ImagePickerConfig().targetSide)

                  
                    
                    Task {
                        // Ask strategy for preset (normalized)
                        let faceRect = await faceStrategy?.computeRect(image: resized, aspectRatio: aspectSize.aspect)
                        await MainActor.run {
                           // self.fileImage = resized
                            
                            if let faceRect = faceRect , faceRect != .zero {
                                if needCropperPresentedOrNot == .editor {
                                    self.showStandaloneCropper = true
                                    var  load = CropperPayload(image: resized )
                                    load.normalizedPresetRect = faceRect
                                    cropperPayload = load

                                } else {
                                    let oldFace = faceStrategy?.oldImageHasFace
                                    
                                    if oldFace == false  {
                                        self.showStandaloneCropper = true
                                        var  load = CropperPayload(image: resized )
                                        load.normalizedPresetRect = nil
                                        cropperPayload = load
                                    }else {
                                        persistSelection(with: faceRect, fromImage: resized)
                                    }
                                }
                            }else {
                                self.showStandaloneCropper = true
                                cropperPayload = CropperPayload(image: resized)
                            }
                           
                            
                            
                        }
                    }
                }
                
            case .failure(let e):
                print("file import failed: \(e)")
            }
        }
        
        // MARK: Persist selection into ImageModel
        
         func persistSelection(with normalizedCrop: CGRect, fromImage: UIImage) {
             let base = fromImage 
            
            do {
                let uuid = UUID().uuidString
                if let data = base.pngData() {
                    var file = File(name: uuid, data: data, fileExtension: "png")
                    try AppFileManager.shared.localAssets?.addFile(file: &file)
                    
                    if let prev = previousImage {
                        replaceImage = ImageModel(
                            imageType: .IMAGE,
                            serverPath: "",
                            localPath: "\(uuid).png",
                            cropRect: normalizedCrop,
                            sourceType: .DOCUMENT,
                            tileMultiple: 1.0,
                            cropType: prev.cropType,
                            imageWidth: prev.imageWidth,
                            imageHeight: prev.imageHeight
                        )
                    } else {
                        addImage = ImageModel(
                            imageType: .IMAGE,
                            serverPath: "",
                            localPath: "\(uuid).png",
                            cropRect: normalizedCrop,
                            sourceType: .DOCUMENT,
                            tileMultiple: 1.0,
                            cropType: .ratios,
                            imageWidth: Double((base.mySize.width)),
                            imageHeight: Double((base.mySize.height))
                        )
                    }
                    myLoader.hide()
                    isGalleryPickerPresented = false
                }
            } catch {
                print("Failed to persist image: \(error)")
            }
        }
    }

extension CGSize {
    var aspect: CGFloat {
        max(0.0001, width) / max(0.0001, height)
    }
}

import SwiftUI
import UIKit
import Mantis
import Vision
import CoreGraphics
import UnifiedPickerKit

public class FaceDetector  {
    
    // Detect the single face and pass the single face rect.
    func detectFace(image: UIImage, completion: @escaping (CGRect?) -> Void) {
        guard let ciImage = CIImage(image: image) else { return }
        let request = VNDetectFaceRectanglesRequest { request, error in
            DispatchQueue.main.async {
                guard let results = request.results as? [VNFaceObservation], let face = results.first, error == nil else {
                    completion(nil)
                    return
                }
                
                let imageSize = image.mySize
                let faceBoundingBox = CGRect(
                    x: face.boundingBox.origin.x * imageSize.width,
                    y: (1 - face.boundingBox.origin.y - face.boundingBox.height) * imageSize.height,
                    width: face.boundingBox.width * imageSize.width,
                    height: face.boundingBox.height * imageSize.height
                )
                
                completion(faceBoundingBox)
            }
        }
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
    
    // Detect the multiple faces and pass the multiple faces rect.
    func detectFaces(image: UIImage, completion: @escaping ([CGRect]?) -> Void) {
        printLog("FDP: -> Actual Face Detection Stated ... ")

        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            DispatchQueue.main.async {
                guard let results = request.results as? [VNFaceObservation], error == nil else {
                    completion(nil)
                    return
                }
                
                let imageSize = image.mySize
                let faceBoundingBoxes = results.map { face in
                    CGRect(
                        x: face.boundingBox.origin.x * imageSize.width,
                        y: (1 - face.boundingBox.origin.y - face.boundingBox.height) * imageSize.height,
                        width: face.boundingBox.width * imageSize.width,
                        height: face.boundingBox.height * imageSize.height
                    )
                }
                printLog("FDP: -> Actual Face Detection Ended ... faceCount\(faceBoundingBoxes.count)")

                completion(faceBoundingBoxes.isEmpty ? nil : faceBoundingBoxes)
            }
        }
        
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
    
    
    // Get the proptional rect from Previous Image to New Image.
//    func getUserImageCropRect(previousFaceRect: CGRect, previousImageWidth: CGFloat, previousImageHeight: CGFloat,
//                              userFaceRect: CGRect, userImageWidth: CGFloat, userImageHeight: CGFloat) -> CGRect? {
//
//        printLog("FDP: -> Doing Actual Calcualtions For CropRect FD ")
//
//        var iterationCount = 0
//        let maxIterations = 1000
//
//        // Step 1: Determine the minimum dimension (width or height) of the face rectangles for scaling
//        let previousFaceMin = min(previousFaceRect.width, previousFaceRect.height)
//        let userFaceMin = min(userFaceRect.width, userFaceRect.height)
//
//        // Step 2: Calculate the scaling ratio between the user's face and the previous face
//        let ratio = userFaceMin / previousFaceMin
//
//        // Step 3: Compute the expected crop dimensions based on the scaling ratio
//        let expectedCropWidth = ratio * previousImageWidth
//        let expectedCropHeight = ratio * previousImageHeight
//
//        // Step 4: Calculate the initial crop rectangle coordinates
//        var expectedLeft = userFaceRect.midX - (previousFaceRect.midX * ratio)
//        var expectedTop = userFaceRect.midY - (previousFaceRect.midY * ratio)
//        let expectedRight = expectedLeft + expectedCropWidth
//        let expectedBottom = expectedTop + expectedCropHeight
//
//        let userImageRect = CGRect(x: 0, y: 0, width: userImageWidth, height: userImageHeight)
//        var userImageExpectedCropRect = CGRect(x: expectedLeft, y: expectedTop, width: expectedCropWidth, height: expectedCropHeight)
//
//        // Step 5: Check if the crop rectangle fits entirely within the user's image bounds
//        if userImageRect.contains(userImageExpectedCropRect) {
//            return userImageExpectedCropRect
//        }
//
//        // Step 6: Calculate the amount of overflow outside the image bounds
//        var leftSpace = userFaceRect.minX - userImageExpectedCropRect.minX
//        var topSpace = userFaceRect.minY - userImageExpectedCropRect.minY
//        let horizontalSpace = userImageExpectedCropRect.width - userFaceRect.width
//        let verticalSpace = userImageExpectedCropRect.height - userFaceRect.height
//
//        let leftSpacePercent = leftSpace / horizontalSpace
//        let topSpacePercent = topSpace / verticalSpace
//
//        var width: CGFloat
//        var height: CGFloat
//        var rightSpace: CGFloat
//        var bottomSpace: CGFloat
//
//        while iterationCount < maxIterations {
//            iterationCount += 1
//            print("Repeat in while loop.")
//            // Step 7: Adjust crop dimensions iteratively based on the orientation of the previous image
//            if previousImageWidth < previousImageHeight {
//                // Portrait orientation: Adjust width and derive height proportionally
//                width = expectedRight - expectedLeft - 2
//                height = (width * previousImageHeight) / previousImageWidth
//            } else {
//                // Landscape orientation: Adjust height and derive width proportionally
//                height = expectedBottom - expectedTop - 2
//                width = (height * previousImageWidth) / previousImageHeight
//            }
//
//            // Calculate new spaces based on the adjusted dimensions
//            leftSpace = round(leftSpacePercent * (width - userFaceRect.width))
//            topSpace = round(topSpacePercent * (height - userFaceRect.height))
//            rightSpace = width - userFaceRect.width - leftSpace
//            bottomSpace = height - userFaceRect.height - topSpace
//
//            if leftSpace > 0, topSpace > 0, rightSpace > 0, bottomSpace > 0 {
//                // Update the crop rectangle based on the adjusted spaces
//                expectedLeft = userFaceRect.minX - leftSpace
//                expectedTop = userFaceRect.minY - topSpace
//
//                let adjustedCropRect = CGRect(x: expectedLeft, y: expectedTop, width: width, height: height)
//
//                // Step 8: Check if the adjusted crop rectangle fits within the bounds of the user's image
//                if userImageRect.contains(adjustedCropRect) {
//                    return adjustedCropRect
//                }
//            } else {
//                // Step 9: No space left to adjust further; attempt to calculate a best-fit crop rectangle
//                let fallbackLeft = max(userImageRect.minX, expectedLeft)
//                let fallbackTop = max(userImageRect.minY, expectedTop)
//                let fallbackRight = min(userImageRect.maxX, expectedLeft + width)
//                let fallbackBottom = min(userImageRect.maxY, expectedTop + height)
//
//                let fallbackWidth = fallbackRight - fallbackLeft
//                let fallbackHeight = fallbackBottom - fallbackTop
//
//                // Resize dimensions proportionally while maintaining aspect ratio
//                let (resizedWidth, resizedHeight) = getResizeDimensions(originalWidth: previousImageWidth,
//                                                                        originalHeight: previousImageHeight,
//                                                                        maxWidth: fallbackWidth,
//                                                                        maxHeight: fallbackHeight)
//
//                expectedLeft = fallbackLeft + (fallbackWidth - resizedWidth) / 2
//                expectedTop = fallbackTop + (fallbackHeight - resizedHeight) / 2
//
//                let adjustedRect = CGRect(x: expectedLeft, y: expectedTop, width: resizedWidth, height: resizedHeight)
//
//                if userImageRect.contains(adjustedRect), adjustedRect.contains(CGPoint(x: userFaceRect.midX, y: userFaceRect.midY)) {
//                    return adjustedRect
//                }
//
//                return nil
//            }
//        }
//        return nil
//    }
    
    func getUserImageCropRect(previousFaceRect: CGRect, previousImageWidth: CGFloat, previousImageHeight: CGFloat,
                              userFaceRect: CGRect, userImageWidth: CGFloat, userImageHeight: CGFloat) -> CGRect? {
        
        printLog("FDP: -> Doing Actual Calcualtions For CropRect FD ")

        // Step 1: Calculate scale ratio
        let previousFaceMin = min(previousFaceRect.width, previousFaceRect.height)
        let userFaceMin = min(userFaceRect.width, userFaceRect.height)
        let ratio = userFaceMin / previousFaceMin
        
        // Step 2: Expected crop size
        var expectedCropWidth = ratio * previousImageWidth
        var expectedCropHeight = ratio * previousImageHeight
        
        // Step 3: Initial crop rect based on face center alignment
        var expectedLeft = userFaceRect.midX - (previousFaceRect.midX * ratio)
        var expectedTop = userFaceRect.midY - (previousFaceRect.midY * ratio)
        var expectedRight = expectedLeft + expectedCropWidth
        var expectedBottom = expectedTop + expectedCropHeight
        
        let userImageRect = CGRect(x: 0, y: 0, width: userImageWidth, height: userImageHeight)
        let proposedCrop = CGRect(x: expectedLeft, y: expectedTop, width: expectedCropWidth, height: expectedCropHeight)
        
        if userImageRect.contains(proposedCrop) {
            logAspectRatioCheck(oldRect: CGRect(x: 0, y: 0, width: previousImageWidth, height: previousImageHeight),
                                finalRect: proposedCrop)

            return proposedCrop
        }
        
        // Step 4: Calculate space ratios
        var leftSpace = userFaceRect.minX - proposedCrop.minX
        var topSpace = userFaceRect.minY - proposedCrop.minY
        let horizontalSpace = proposedCrop.width - userFaceRect.width
        let verticalSpace = proposedCrop.height - userFaceRect.height
        
        let leftPercent = horizontalSpace > 0 ? leftSpace / horizontalSpace : 0.5
        let topPercent = verticalSpace > 0 ? topSpace / verticalSpace : 0.5
        
        var width: CGFloat
        var height: CGFloat
        
        // Infinite loop equivalent to Android’s while(true)
        while true {
            if previousImageWidth < previousImageHeight {
                // Portrait: Fix width, calculate height
                width = max(1, expectedCropWidth - 2)
                height = width * previousImageHeight / previousImageWidth
            } else {
                // Landscape: Fix height, calculate width
                height = max(1, expectedCropHeight - 2)
                width = height * previousImageWidth / previousImageHeight
            }
            
            leftSpace = round(leftPercent * (width - userFaceRect.width))
            topSpace = round(topPercent * (height - userFaceRect.height))
            let rightSpace = width - userFaceRect.width - leftSpace
            let bottomSpace = height - userFaceRect.height - topSpace
            
            if leftSpace > 0, topSpace > 0, rightSpace > 0, bottomSpace > 0 {
                expectedLeft = userFaceRect.minX - leftSpace
                expectedTop = userFaceRect.minY - topSpace
                expectedRight = expectedLeft + width
                expectedBottom = expectedTop + height
                
                let adjusted = CGRect(x: expectedLeft, y: expectedTop, width: width, height: height)
                if userImageRect.contains(adjusted) {
                    logAspectRatioCheck(oldRect: CGRect(x: 0, y: 0, width: previousImageWidth, height: previousImageHeight),
                                        finalRect: adjusted)

                    return adjusted
                }
            } else {
                // Fallback logic
                let fallbackLeft = max(userImageRect.minX, expectedLeft)
                let fallbackTop = max(userImageRect.minY, expectedTop)
                let fallbackRight = min(userImageRect.maxX, expectedRight)
                let fallbackBottom = min(userImageRect.maxY, expectedBottom)
                
                let fallbackWidth = fallbackRight - fallbackLeft
                let fallbackHeight = fallbackBottom - fallbackTop
                
                let (resizedWidth, resizedHeight) = getResizeDimensions(
                    originalWidth: previousImageWidth,
                    originalHeight: previousImageHeight,
                    maxWidth: fallbackWidth,
                    maxHeight: fallbackHeight
                )
                
                expectedLeft = fallbackLeft + (fallbackWidth - resizedWidth) / 2
                expectedTop = fallbackTop + (fallbackHeight - resizedHeight) / 2
                
                let adjustedFallback = CGRect(x: expectedLeft, y: expectedTop, width: resizedWidth, height: resizedHeight)
                if userImageRect.contains(adjustedFallback),
                   adjustedFallback.contains(CGPoint(x: userFaceRect.midX, y: userFaceRect.midY)) {
                    logAspectRatioCheck(oldRect: CGRect(x: 0, y: 0, width: previousImageWidth, height: previousImageHeight),
                                        finalRect: adjustedFallback)
                    return adjustedFallback
                }
                return nil
            }
            
            expectedCropWidth = width
            expectedCropHeight = height
        }
        
        return nil
    }
    func cropRectWithFacePadding(
        faceRect: CGRect,
        imageSize: CGSize,
        aspectRatio: CGFloat
    ) -> CGRect {
        printLog("FaceDetector -> Detecting Center Padded Face")
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        // Step 1: Center of the face
        let faceCenter = CGPoint(x: faceRect.midX, y: faceRect.midY)
        
        // Step 2: Start with maximum crop that fits in image, centered on face
        // Calculate maximum possible width and height from center
        let maxLeft = faceCenter.x
        let maxRight = imageWidth - faceCenter.x
        let maxTop = faceCenter.y
        let maxBottom = imageHeight - faceCenter.y
        
        // Depending on aspect ratio, calculate maximum width and height
        var cropWidth: CGFloat = 0
        var cropHeight: CGFloat = 0
        
        if aspectRatio > 1 {
            // Wider than tall → width is the limiting factor
            cropWidth = 2 * min(maxLeft, maxRight)
            cropHeight = cropWidth / aspectRatio
            if cropHeight > 2 * min(maxTop, maxBottom) {
                cropHeight = 2 * min(maxTop, maxBottom)
                cropWidth = cropHeight * aspectRatio
            }
        } else {
            // Taller than wide or square
            cropHeight = 2 * min(maxTop, maxBottom)
            cropWidth = cropHeight * aspectRatio
            if cropWidth > 2 * min(maxLeft, maxRight) {
                cropWidth = 2 * min(maxLeft, maxRight)
                cropHeight = cropWidth / aspectRatio
            }
        }
        
        // Step 3: Build centered crop rect
        let originX = faceCenter.x - cropWidth / 2
        let originY = faceCenter.y - cropHeight / 2
        let cropRect = CGRect(x: originX, y: originY, width: cropWidth, height: cropHeight)
        
        return cropRect
    }
//    /// Calculates a crop rect around a detected face with padding, ensuring aspect ratio and clamping to image bounds.
//    /// - Parameters:
//    ///   - faceRect: The detected face rectangle in pixel coordinates.
//    ///   - imageSize: The full image size (in pixels).
//    ///   - aspectRatio: Desired aspect ratio (width / height).
//    ///   - paddingFactor: Optional padding around face (default 0.2 = 20%)
//    /// - Returns: A CGRect (in absolute pixels) representing the final crop rect.
//    func cropRectWithFacePadding(
//        faceRect: CGRect,
//        imageSize: CGSize,
//        aspectRatio: CGFloat,
//        paddingFactor: CGFloat = 0.2
//    ) -> CGRect {
//
//        let imageWidth = imageSize.width
//        let imageHeight = imageSize.height
//
//        // Step 1: Add padding
//        let paddingX = faceRect.width * paddingFactor
//        let paddingY = faceRect.height * paddingFactor
//
//        var padded = faceRect.insetBy(dx: -paddingX, dy: -paddingY)
//
//        // Step 2: Adjust to match aspect ratio
//        let currentAspect = padded.width / padded.height
//        var adjusted = padded
//
//        if currentAspect > aspectRatio {
//            // Too wide → increase height
//            let newHeight = padded.width / aspectRatio
//            let delta = (newHeight - padded.height) / 2
//            adjusted.origin.y -= delta
//            adjusted.size.height = newHeight
//        } else {
//            // Too tall → increase width
//            let newWidth = padded.height * aspectRatio
//            let delta = (newWidth - padded.width) / 2
//            adjusted.origin.x -= delta
//            adjusted.size.width = newWidth
//        }
//
//        // Step 3: Clamp to image bounds
//        if adjusted.origin.x < 0 {
//            adjusted.origin.x = 0
//        }
//        if adjusted.origin.y < 0 {
//            adjusted.origin.y = 0
//        }
//        if adjusted.maxX > imageWidth {
//            adjusted.size.width = imageWidth - adjusted.origin.x
//            adjusted.size.height = adjusted.width / aspectRatio
//        }
//        if adjusted.maxY > imageHeight {
//            adjusted.size.height = imageHeight - adjusted.origin.y
//            adjusted.size.width = adjusted.height * aspectRatio
//        }
//
//        return adjusted
//    }
    
    // Helper function to maintain aspect ratio while resizing
   private func getResizeDimensions(originalWidth: CGFloat, originalHeight: CGFloat, maxWidth: CGFloat, maxHeight: CGFloat) -> (CGFloat, CGFloat) {
        let widthRatio = maxWidth / originalWidth
        let heightRatio = maxHeight / originalHeight
        let scaleFactor = min(widthRatio, heightRatio)
        
        let newWidth = originalWidth * scaleFactor
        let newHeight = originalHeight * scaleFactor
        
        return (newWidth, newHeight)
    }
    
}
func logAspectRatioCheck(oldRect: CGRect, finalRect: CGRect, tag: String = "FDP") {
    let oldAspect = oldRect.width / oldRect.height
    let newAspect = finalRect.width / finalRect.height

    let ratioDifference = abs(oldAspect - newAspect)
    let matches = ratioDifference < 0.01 // Allow 1% tolerance

    print("🔍 [\(tag)] Aspect Ratio Check:")
    print("📐 Old Crop Rect: \(oldRect) → Aspect: \(String(format: "%.4f", oldAspect))")
    print("📐 Final Crop Rect: \(finalRect) → Aspect: \(String(format: "%.4f", newAspect))")
    print("✅ Match Status: \(matches ? "MATCHED ✅" : "MISMATCH ❌") — Difference: \(String(format: "%.4f", ratioDifference))")
}


class FaceDetector2 : FaceDetecting {
    func detectFace(image: UIImage, _ completion: @escaping (CGRect?) -> Void) {
        guard let ciImage = CIImage(image: image) else { return }
        let request = VNDetectFaceRectanglesRequest { request, error in
            DispatchQueue.main.async {
                guard let results = request.results as? [VNFaceObservation], let face = results.first, error == nil else {
                    completion(nil)
                    return
                }
                
                let imageSize = image.mySize
                let faceBoundingBox = CGRect(
                    x: face.boundingBox.origin.x * imageSize.width,
                    y: (1 - face.boundingBox.origin.y - face.boundingBox.height) * imageSize.height,
                    width: face.boundingBox.width * imageSize.width,
                    height: face.boundingBox.height * imageSize.height
                )
                
                completion(faceBoundingBox)
            }
        }
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
    // Detect the single face and pass the single face rect.
    func detectFace(image: UIImage, completion: @escaping (CGRect?) -> Void) {
        guard let ciImage = CIImage(image: image) else { return }
        let request = VNDetectFaceRectanglesRequest { request, error in
            DispatchQueue.main.async {
                guard let results = request.results as? [VNFaceObservation], let face = results.first, error == nil else {
                    completion(nil)
                    return
                }
                
                let imageSize = image.mySize
                let faceBoundingBox = CGRect(
                    x: face.boundingBox.origin.x * imageSize.width,
                    y: (1 - face.boundingBox.origin.y - face.boundingBox.height) * imageSize.height,
                    width: face.boundingBox.width * imageSize.width,
                    height: face.boundingBox.height * imageSize.height
                )
                
                completion(faceBoundingBox)
            }
        }
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
    
    // Detect the multiple faces and pass the multiple faces rect.
    func detectFaces(image: UIImage, completion: @escaping ([CGRect]?) -> Void) {
        printLog("FDP: -> Actual Face Detection Stated ... ")

        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            DispatchQueue.main.async {
                guard let results = request.results as? [VNFaceObservation], error == nil else {
                    completion(nil)
                    return
                }
                
                let imageSize = image.mySize
                let faceBoundingBoxes = results.map { face in
                    CGRect(
                        x: face.boundingBox.origin.x * imageSize.width,
                        y: (1 - face.boundingBox.origin.y - face.boundingBox.height) * imageSize.height,
                        width: face.boundingBox.width * imageSize.width,
                        height: face.boundingBox.height * imageSize.height
                    )
                }
                printLog("FDP: -> Actual Face Detection Ended ... faceCount\(faceBoundingBoxes.count)")

                completion(faceBoundingBoxes.isEmpty ? nil : faceBoundingBoxes)
            }
        }
        
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
    
    
    // Get the proptional rect from Previous Image to New Image.
//    func getUserImageCropRect(previousFaceRect: CGRect, previousImageWidth: CGFloat, previousImageHeight: CGFloat,
//                              userFaceRect: CGRect, userImageWidth: CGFloat, userImageHeight: CGFloat) -> CGRect? {
//
//        printLog("FDP: -> Doing Actual Calcualtions For CropRect FD ")
//
//        var iterationCount = 0
//        let maxIterations = 1000
//
//        // Step 1: Determine the minimum dimension (width or height) of the face rectangles for scaling
//        let previousFaceMin = min(previousFaceRect.width, previousFaceRect.height)
//        let userFaceMin = min(userFaceRect.width, userFaceRect.height)
//
//        // Step 2: Calculate the scaling ratio between the user's face and the previous face
//        let ratio = userFaceMin / previousFaceMin
//
//        // Step 3: Compute the expected crop dimensions based on the scaling ratio
//        let expectedCropWidth = ratio * previousImageWidth
//        let expectedCropHeight = ratio * previousImageHeight
//
//        // Step 4: Calculate the initial crop rectangle coordinates
//        var expectedLeft = userFaceRect.midX - (previousFaceRect.midX * ratio)
//        var expectedTop = userFaceRect.midY - (previousFaceRect.midY * ratio)
//        let expectedRight = expectedLeft + expectedCropWidth
//        let expectedBottom = expectedTop + expectedCropHeight
//
//        let userImageRect = CGRect(x: 0, y: 0, width: userImageWidth, height: userImageHeight)
//        var userImageExpectedCropRect = CGRect(x: expectedLeft, y: expectedTop, width: expectedCropWidth, height: expectedCropHeight)
//
//        // Step 5: Check if the crop rectangle fits entirely within the user's image bounds
//        if userImageRect.contains(userImageExpectedCropRect) {
//            return userImageExpectedCropRect
//        }
//
//        // Step 6: Calculate the amount of overflow outside the image bounds
//        var leftSpace = userFaceRect.minX - userImageExpectedCropRect.minX
//        var topSpace = userFaceRect.minY - userImageExpectedCropRect.minY
//        let horizontalSpace = userImageExpectedCropRect.width - userFaceRect.width
//        let verticalSpace = userImageExpectedCropRect.height - userFaceRect.height
//
//        let leftSpacePercent = leftSpace / horizontalSpace
//        let topSpacePercent = topSpace / verticalSpace
//
//        var width: CGFloat
//        var height: CGFloat
//        var rightSpace: CGFloat
//        var bottomSpace: CGFloat
//
//        while iterationCount < maxIterations {
//            iterationCount += 1
//            print("Repeat in while loop.")
//            // Step 7: Adjust crop dimensions iteratively based on the orientation of the previous image
//            if previousImageWidth < previousImageHeight {
//                // Portrait orientation: Adjust width and derive height proportionally
//                width = expectedRight - expectedLeft - 2
//                height = (width * previousImageHeight) / previousImageWidth
//            } else {
//                // Landscape orientation: Adjust height and derive width proportionally
//                height = expectedBottom - expectedTop - 2
//                width = (height * previousImageWidth) / previousImageHeight
//            }
//
//            // Calculate new spaces based on the adjusted dimensions
//            leftSpace = round(leftSpacePercent * (width - userFaceRect.width))
//            topSpace = round(topSpacePercent * (height - userFaceRect.height))
//            rightSpace = width - userFaceRect.width - leftSpace
//            bottomSpace = height - userFaceRect.height - topSpace
//
//            if leftSpace > 0, topSpace > 0, rightSpace > 0, bottomSpace > 0 {
//                // Update the crop rectangle based on the adjusted spaces
//                expectedLeft = userFaceRect.minX - leftSpace
//                expectedTop = userFaceRect.minY - topSpace
//
//                let adjustedCropRect = CGRect(x: expectedLeft, y: expectedTop, width: width, height: height)
//
//                // Step 8: Check if the adjusted crop rectangle fits within the bounds of the user's image
//                if userImageRect.contains(adjustedCropRect) {
//                    return adjustedCropRect
//                }
//            } else {
//                // Step 9: No space left to adjust further; attempt to calculate a best-fit crop rectangle
//                let fallbackLeft = max(userImageRect.minX, expectedLeft)
//                let fallbackTop = max(userImageRect.minY, expectedTop)
//                let fallbackRight = min(userImageRect.maxX, expectedLeft + width)
//                let fallbackBottom = min(userImageRect.maxY, expectedTop + height)
//
//                let fallbackWidth = fallbackRight - fallbackLeft
//                let fallbackHeight = fallbackBottom - fallbackTop
//
//                // Resize dimensions proportionally while maintaining aspect ratio
//                let (resizedWidth, resizedHeight) = getResizeDimensions(originalWidth: previousImageWidth,
//                                                                        originalHeight: previousImageHeight,
//                                                                        maxWidth: fallbackWidth,
//                                                                        maxHeight: fallbackHeight)
//
//                expectedLeft = fallbackLeft + (fallbackWidth - resizedWidth) / 2
//                expectedTop = fallbackTop + (fallbackHeight - resizedHeight) / 2
//
//                let adjustedRect = CGRect(x: expectedLeft, y: expectedTop, width: resizedWidth, height: resizedHeight)
//
//                if userImageRect.contains(adjustedRect), adjustedRect.contains(CGPoint(x: userFaceRect.midX, y: userFaceRect.midY)) {
//                    return adjustedRect
//                }
//
//                return nil
//            }
//        }
//        return nil
//    }
    
    func getUserImageCropRect(previousFaceRect: CGRect, previousImageWidth: CGFloat, previousImageHeight: CGFloat,
                              userFaceRect: CGRect, userImageWidth: CGFloat, userImageHeight: CGFloat) -> CGRect? {
        
        printLog("FDP: -> Doing Actual Calcualtions For CropRect FD ")

        // Step 1: Calculate scale ratio
        let previousFaceMin = min(previousFaceRect.width, previousFaceRect.height)
        let userFaceMin = min(userFaceRect.width, userFaceRect.height)
        let ratio = userFaceMin / previousFaceMin
        
        // Step 2: Expected crop size
        var expectedCropWidth = ratio * previousImageWidth
        var expectedCropHeight = ratio * previousImageHeight
        
        // Step 3: Initial crop rect based on face center alignment
        var expectedLeft = userFaceRect.midX - (previousFaceRect.midX * ratio)
        var expectedTop = userFaceRect.midY - (previousFaceRect.midY * ratio)
        var expectedRight = expectedLeft + expectedCropWidth
        var expectedBottom = expectedTop + expectedCropHeight
        
        let userImageRect = CGRect(x: 0, y: 0, width: userImageWidth, height: userImageHeight)
        let proposedCrop = CGRect(x: expectedLeft, y: expectedTop, width: expectedCropWidth, height: expectedCropHeight)
        
        if userImageRect.contains(proposedCrop) {
            logAspectRatioCheck(oldRect: CGRect(x: 0, y: 0, width: previousImageWidth, height: previousImageHeight),
                                finalRect: proposedCrop)

            return proposedCrop
        }
        
        // Step 4: Calculate space ratios
        var leftSpace = userFaceRect.minX - proposedCrop.minX
        var topSpace = userFaceRect.minY - proposedCrop.minY
        let horizontalSpace = proposedCrop.width - userFaceRect.width
        let verticalSpace = proposedCrop.height - userFaceRect.height
        
        let leftPercent = horizontalSpace > 0 ? leftSpace / horizontalSpace : 0.5
        let topPercent = verticalSpace > 0 ? topSpace / verticalSpace : 0.5
        
        var width: CGFloat
        var height: CGFloat
        
        // Infinite loop equivalent to Android’s while(true)
        while true {
            if previousImageWidth < previousImageHeight {
                // Portrait: Fix width, calculate height
                width = max(1, expectedCropWidth - 2)
                height = width * previousImageHeight / previousImageWidth
            } else {
                // Landscape: Fix height, calculate width
                height = max(1, expectedCropHeight - 2)
                width = height * previousImageWidth / previousImageHeight
            }
            
            leftSpace = round(leftPercent * (width - userFaceRect.width))
            topSpace = round(topPercent * (height - userFaceRect.height))
            let rightSpace = width - userFaceRect.width - leftSpace
            let bottomSpace = height - userFaceRect.height - topSpace
            
            if leftSpace > 0, topSpace > 0, rightSpace > 0, bottomSpace > 0 {
                expectedLeft = userFaceRect.minX - leftSpace
                expectedTop = userFaceRect.minY - topSpace
                expectedRight = expectedLeft + width
                expectedBottom = expectedTop + height
                
                let adjusted = CGRect(x: expectedLeft, y: expectedTop, width: width, height: height)
                if userImageRect.contains(adjusted) {
                    logAspectRatioCheck(oldRect: CGRect(x: 0, y: 0, width: previousImageWidth, height: previousImageHeight),
                                        finalRect: adjusted)

                    return adjusted
                }
            } else {
                // Fallback logic
                let fallbackLeft = max(userImageRect.minX, expectedLeft)
                let fallbackTop = max(userImageRect.minY, expectedTop)
                let fallbackRight = min(userImageRect.maxX, expectedRight)
                let fallbackBottom = min(userImageRect.maxY, expectedBottom)
                
                let fallbackWidth = fallbackRight - fallbackLeft
                let fallbackHeight = fallbackBottom - fallbackTop
                
                let (resizedWidth, resizedHeight) = getResizeDimensions(
                    originalWidth: previousImageWidth,
                    originalHeight: previousImageHeight,
                    maxWidth: fallbackWidth,
                    maxHeight: fallbackHeight
                )
                
                expectedLeft = fallbackLeft + (fallbackWidth - resizedWidth) / 2
                expectedTop = fallbackTop + (fallbackHeight - resizedHeight) / 2
                
                let adjustedFallback = CGRect(x: expectedLeft, y: expectedTop, width: resizedWidth, height: resizedHeight)
                if userImageRect.contains(adjustedFallback),
                   adjustedFallback.contains(CGPoint(x: userFaceRect.midX, y: userFaceRect.midY)) {
                    logAspectRatioCheck(oldRect: CGRect(x: 0, y: 0, width: previousImageWidth, height: previousImageHeight),
                                        finalRect: adjustedFallback)
                    return adjustedFallback
                }
                return nil
            }
            
            expectedCropWidth = width
            expectedCropHeight = height
        }
        
        return nil
    }
    func cropRectWithFacePadding(
        faceRect: CGRect,
        imageSize: CGSize,
        aspectRatio: CGFloat
    ) -> CGRect {
        printLog("FaceDetector -> Detecting Center Padded Face")
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        // Step 1: Center of the face
        let faceCenter = CGPoint(x: faceRect.midX, y: faceRect.midY)
        
        // Step 2: Start with maximum crop that fits in image, centered on face
        // Calculate maximum possible width and height from center
        let maxLeft = faceCenter.x
        let maxRight = imageWidth - faceCenter.x
        let maxTop = faceCenter.y
        let maxBottom = imageHeight - faceCenter.y
        
        // Depending on aspect ratio, calculate maximum width and height
        var cropWidth: CGFloat = 0
        var cropHeight: CGFloat = 0
        
        if aspectRatio > 1 {
            // Wider than tall → width is the limiting factor
            cropWidth = 2 * min(maxLeft, maxRight)
            cropHeight = cropWidth / aspectRatio
            if cropHeight > 2 * min(maxTop, maxBottom) {
                cropHeight = 2 * min(maxTop, maxBottom)
                cropWidth = cropHeight * aspectRatio
            }
        } else {
            // Taller than wide or square
            cropHeight = 2 * min(maxTop, maxBottom)
            cropWidth = cropHeight * aspectRatio
            if cropWidth > 2 * min(maxLeft, maxRight) {
                cropWidth = 2 * min(maxLeft, maxRight)
                cropHeight = cropWidth / aspectRatio
            }
        }
        
        // Step 3: Build centered crop rect
        let originX = faceCenter.x - cropWidth / 2
        let originY = faceCenter.y - cropHeight / 2
        let cropRect = CGRect(x: originX, y: originY, width: cropWidth, height: cropHeight)
        
        return cropRect
    }
//    /// Calculates a crop rect around a detected face with padding, ensuring aspect ratio and clamping to image bounds.
//    /// - Parameters:
//    ///   - faceRect: The detected face rectangle in pixel coordinates.
//    ///   - imageSize: The full image size (in pixels).
//    ///   - aspectRatio: Desired aspect ratio (width / height).
//    ///   - paddingFactor: Optional padding around face (default 0.2 = 20%)
//    /// - Returns: A CGRect (in absolute pixels) representing the final crop rect.
//    func cropRectWithFacePadding(
//        faceRect: CGRect,
//        imageSize: CGSize,
//        aspectRatio: CGFloat,
//        paddingFactor: CGFloat = 0.2
//    ) -> CGRect {
//
//        let imageWidth = imageSize.width
//        let imageHeight = imageSize.height
//
//        // Step 1: Add padding
//        let paddingX = faceRect.width * paddingFactor
//        let paddingY = faceRect.height * paddingFactor
//
//        var padded = faceRect.insetBy(dx: -paddingX, dy: -paddingY)
//
//        // Step 2: Adjust to match aspect ratio
//        let currentAspect = padded.width / padded.height
//        var adjusted = padded
//
//        if currentAspect > aspectRatio {
//            // Too wide → increase height
//            let newHeight = padded.width / aspectRatio
//            let delta = (newHeight - padded.height) / 2
//            adjusted.origin.y -= delta
//            adjusted.size.height = newHeight
//        } else {
//            // Too tall → increase width
//            let newWidth = padded.height * aspectRatio
//            let delta = (newWidth - padded.width) / 2
//            adjusted.origin.x -= delta
//            adjusted.size.width = newWidth
//        }
//
//        // Step 3: Clamp to image bounds
//        if adjusted.origin.x < 0 {
//            adjusted.origin.x = 0
//        }
//        if adjusted.origin.y < 0 {
//            adjusted.origin.y = 0
//        }
//        if adjusted.maxX > imageWidth {
//            adjusted.size.width = imageWidth - adjusted.origin.x
//            adjusted.size.height = adjusted.width / aspectRatio
//        }
//        if adjusted.maxY > imageHeight {
//            adjusted.size.height = imageHeight - adjusted.origin.y
//            adjusted.size.width = adjusted.height * aspectRatio
//        }
//
//        return adjusted
//    }
    
    // Helper function to maintain aspect ratio while resizing
   private func getResizeDimensions(originalWidth: CGFloat, originalHeight: CGFloat, maxWidth: CGFloat, maxHeight: CGFloat) -> (CGFloat, CGFloat) {
        let widthRatio = maxWidth / originalWidth
        let heightRatio = maxHeight / originalHeight
        let scaleFactor = min(widthRatio, heightRatio)
        
        let newWidth = originalWidth * scaleFactor
        let newHeight = originalHeight * scaleFactor
        
        return (newWidth, newHeight)
    }
    
    
    
}


import UIKit

public struct SingleFaceStrategy: FaceDetectionStrategy {
    public var oldImageHasFace : Bool? = nil
    public var newImageHasFace : Bool? = nil
    
    
    let detector: FaceDetector
    let aspectSize: CGSize

    public init(detector: FaceDetector, aspectSize: CGSize) {
        self.detector = detector
        self.aspectSize = aspectSize
    }

    public func computeRect(
        image: UIImage,
        aspectRatio: CGFloat
    ) async -> CGRect {
        await withCheckedContinuation { continuation in
            detector.detectFaces(image: image) { faces in
                guard let face = faces?.first, faces?.count == 1 else {
                    continuation.resume(returning: .zero) // fallback
                    return
                }

                // Adjust with padding + aspect ratio
                let adjusted = detector.cropRectWithFacePadding(
                    faceRect: face,
                    imageSize: image.mySize,
                    aspectRatio: aspectSize.width / aspectSize.height
                )

                continuation.resume(returning: adjusted.normalized(in: image.mySize))
            }
        }
    }
}

import UIKit

public struct AlignWithPreviousStrategy: FaceDetectionStrategy {
    public var oldImageHasFace : Bool? = nil
    public var newImageHasFace : Bool? = nil
    
    
    var previousImage : UIImage?
    var previousCrop : CGRect?
    
    let detector: FaceDetector
    let aspectSize: CGSize

    public init(detector: FaceDetector, aspectSize: CGSize ,previousImage : UIImage? ,previousCrop : CGRect?  ) {
        self.detector = detector
        self.aspectSize = aspectSize
        self.previousImage = previousImage
        self.previousCrop = previousCrop

    }

    public mutating func computeRect(
        image: UIImage,
        aspectRatio: CGFloat
    ) async -> CGRect {
        oldImageHasFace = false
        
        guard let prevImg = previousImage, let prevCrop = previousCrop else {
            return .zero
        }

        // Convert previous normalized rect to pixel rect
        let prevRect = CGRect(
            x: prevCrop.origin.x * prevImg.mySize.width,
            y: prevCrop.origin.y * prevImg.mySize.height,
            width: prevCrop.size.width * prevImg.mySize.width,
            height: prevCrop.size.height * prevImg.mySize.height
        )

        // Crop old face for detection
        guard let croppedPrev = cropImage(image: prevImg, faceBoundingBox: prevRect) else {
            return .zero
        }

        // Detect in previous crop
        let oldFace = await withCheckedContinuation { continuation in
            detector.detectFaces(image: croppedPrev) { faces in
                continuation.resume(returning: faces?.first)
            }
        }

        // Detect in new image
        let newFace = await withCheckedContinuation { continuation in
            detector.detectFaces(image: image) { faces in
                continuation.resume(returning: faces?.first)
            }
        }

        guard let userFaceRect = newFace else {
            return .zero
        }
        
        if oldFace == nil {
            oldImageHasFace = false
        }else {
            oldImageHasFace = true
        }

        // Compute aligned rect (fallback: userFaceRect)
        let aligned = detector.getUserImageCropRect(
            previousFaceRect: oldFace ?? prevRect,
            previousImageWidth: croppedPrev.mySize.width,
            previousImageHeight: croppedPrev.mySize.height,
            userFaceRect: userFaceRect,
            userImageWidth: image.mySize.width,
            userImageHeight: image.mySize.height
        ) ?? userFaceRect

        return aligned.normalized(in: image.mySize)
    }

    private func cropImage(image: UIImage, faceBoundingBox: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: faceBoundingBox) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

//// Simple face detection
//let singleStrategy = SingleFaceStrategy(
//    detector: FaceDetector(),
//    aspectSize: CGSize(width: 1, height: 1)
//)

//// Align with previous
//let alignStrategy = AlignWithPreviousStrategy(
//    detector: FaceDetector(),
//    aspectSize: CGSize(width: 3, height: 4)
//)

class MyLogger :  ImagePickerLogging {
    func logError(_ error: any Error, code: String?, context: [String : Any]?) {
        logError(error,code: code!,context: context as Any as! [String : Any])
    }
    
    func logEvent(_ name: String, attributes: [String : Any]?) {
        logInfo(name,attributes as Any)
    }
    
    
}

class MyLoaderForPicker : ImagePickerLoading {
    public func show(text: String?) {
        
        Loader.showLoader(in: UIApplication.shared.keyWindowPresentedController!.view!, text: text!.translate())
    }
    public func hide() {
        Loader.stopLoader()
    }
    
}

func userDid( _ items: Any..., separator: String = " ", terminator: String = "\n",file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    print("Log - File: \(file), Function: \(function), Line: \(line) :->>UserDid:->>>",items,separator,terminator)
#endif
//    addLog(message: "->> UserDid ->>>: \(items), \(separator) , \(terminator)")
    
}

func logErrorJD(tag:ErrorTags, _ items: Any..., separator: String = " ", terminator: String = "\n" , file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    print("Log - File: \(file), Function: \(function), Line: \(line) :->>NeedsAttention:->>>",tag.rawValue,items,separator,terminator)
#endif
//    addLog(errorMsj: "->> NeedsAttention ->>>: \(items), \(separator) , \(terminator)")

}

func logVerbose( _ items: Any..., separator: String = " ", terminator: String = "\n",file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    print("Log - File: \(file), Function: \(function), Line: \(line) :->>Verb:->>>",items,separator,terminator)
#endif
//    addLog(errorMsj: "->> Verbose ->>>: \(items), \(separator) , \(terminator)")


}

func logError( _ items: Any..., separator: String = " ", terminator: String = "\n" , file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
#if DEBUG
    print("Log - File: \(file), Function: \(function), Line: \(line) :->>NeedsAttention:->>>",items,separator,terminator)
#endif
    addLog(errorMsj: "->> NeedsAttention ->>>: \(items), \(separator) , \(terminator)", file: file , function: function,line: line)
}

func logInfo( _ items: Any..., separator: String = " ", terminator: String = "\n",file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
#if DEBUG
    print("Log - File: \(file), Function: \(function), Line: \(line) :->>Info:->>>",items,separator,terminator)
#endif
    addLog(message : "->> Info ->>>: \(items), \(separator) , \(terminator)", file: file , function: function,line: line)

//    addLog(errorMsj: "->> Info ->>>: \(items), \(separator) , \(terminator)")


}

func logWarning( _ items: Any..., separator: String = " ", terminator: String = "\n",file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    print("Log - File: \(file), Function: \(function), Line: \(line) :->>Warning:->>>",items,separator,terminator)
#endif
//    addLog(errorMsj: "->> Warning ->>>: \(items), \(separator) , \(terminator)")


}


func printLog(_ items: Any..., separator: String = " ", terminator: String = "\n"){
    #if DEBUG
        print(items)
//    addLog(errorMsj: "->> Warning ->>>: \(items), \(separator) , \(terminator)")

    #endif
}
