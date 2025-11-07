////
////  CropperView.swift
////  VideoInvitation
////
////  Created by SEA PRO2 on 21/03/24.
////

import SwiftUI
import Mantis
import UnifiedPickerKit
import IOS_CommonEditor

struct CropperView: View {
    var previousImage : ImageModel?
    @Binding var replaceImage: ImageModel?
    var image: UIImage
    @State var isShowing = false
    @State var isCropperiewPresented: Bool = false
    @State var cropRect: CGRect
    @State var ratioInfo: RatioInfo?
    @State var faceDetectedRect : CGRect? = nil
    @State var cropStyle : ImageCropperType = .circle
    @State var didInformCropperView : Bool = false
    
    
    let loader: ImagePickerLoading = MyLoaderForPicker()
    // your IOS_LoaderSPM wrapper
    let logger: ImagePickerLogging = MyLogger()        // inject here
    let faceDetector: FaceDetecting = FaceDetector2() // your Vision wrapper
    
    
    var body: some View {
        VStack{
            Spacer()
            HStack(spacing: 20){
                VStack{
                    SwiftUI.Image("crop")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                    Text("Circle_")
                        .font(.subheadline)
                    
                }
                .onTapGesture {
                    cropStyle = .circle
                    isCropperiewPresented = true
                }
                .frame(width: 80, height: 80)
                .background(Color.secondarySystemBackground)
                .cornerRadius(5)
                VStack{
                    SwiftUI.Image("ratio")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                    
                    Text("Ratio_")
                        .font(.subheadline)
                }
                .onTapGesture {
                    cropStyle = .ratios
                    isCropperiewPresented = true
                }
                .frame(width: 80, height: 80)
                .background(Color.secondarySystemBackground)
                .cornerRadius(5)
                
                .sheet(isPresented: $isCropperiewPresented) {
//                    Cropper(cropRect: $cropRect, image: image, isGalleryPickerPresented: $isShowing, isCropperiewPresented: $isCropperiewPresented, didInformCropperView: $didInformCropperView, aspectSize: image.mySize, cropStyle: cropStyle, faceDetectedRect : previousImage!.cropRect).interactiveDismissDisabled()
//                    //         cropViewConfig.showAttachedRotationControlView = false

                   let config =  CropConfig(style: cropStyle == .circle ? .circle : .quad, form: .freestyle(aspect: image.mySize), initialNormalizedRect: previousImage!.cropRect)
                    StandaloneCropper(image: image, cropConfig: config, isPresented: $isCropperiewPresented, logger: logger) { result in
                        switch result {
                        case .success(let payload):
                            let cropped = payload.image
                            let normalized = payload
                            if var imageModel = previousImage , let cropRect = payload.normalisedCropRect {
                                if  imageModel.cropRect != payload.normalisedCropRect || imageModel.cropType != cropStyle{
                                    imageModel.cropRect = cropRect
                                    imageModel.cropType = cropStyle
                                    replaceImage = imageModel
                                }
                            }
                            
                            // use results
                        case .failure(let error):
                            // show toast/log
                            print(error.localizedDescription)
                        }
                    }
                    
//                    StandaloneCropper(
//                        fixedAspectRatio: false,
//                        normalizedCropRect: $cropRect,
//                        image: image,
//                        isPresented: $isCropperiewPresented,
//                        didInformCropperView: $didInformCropperView,
//                        aspectSize: CGSize(width: 1, height: 1),
//                        cropStyle: cropStyle == .circle ? .circle : .ratios, // or .circle / .ratios / .free / .fixed(...)
//                        faceDetectedRect: previousImage!.cropRect,             // optional
//                        needFaceDetection: true,
//                        logger: logger
//                    ) { result in
//                        switch result {
//                        case .success(let payload):
//                            let cropped = payload.image
//                            let normalized = payload
//                            // use results
//                        case .failure(let error):
//                            // show toast/log
//                            print(error.localizedDescription)
//                        }
//                    }
                }
                
            }.frame(height: 125)

        }.frame(height: 125)
//            .onChange(of: didInformCropperView, perform: { value in
//                if value != false{
//                    var imageModel = previousImage
//                    if  imageModel?.cropRect != cropRect || imageModel?.cropType != cropStyle{
//                        imageModel?.cropRect = cropRect
//                        imageModel?.cropType = cropStyle
//                        replaceImage = imageModel
//                    }
//                    didInformCropperView = false
//                }
//            })
    }
}

