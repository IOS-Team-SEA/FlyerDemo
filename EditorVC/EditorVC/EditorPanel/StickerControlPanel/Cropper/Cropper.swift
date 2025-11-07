//
//  Cropper.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 05/04/25.
//

import SwiftUI
import Mantis
import IOS_CommonEditor

struct Cropper : UIViewControllerRepresentable {
    typealias Coordinator = CropperCoordinator
    
//    var enableCustomRatio : Bool = false //No need of this variable because it is used for custom case only that come inside the cropStyle.
    var fixedAspectRatio : Bool = false
    @Binding var cropRect: CGRect
    var image: UIImage
    @Binding var isGalleryPickerPresented : Bool
    @Binding var isCropperiewPresented: Bool
    @Binding var didInformCropperView : Bool
    var aspectSize : CGSize
    var cropStyle : ImageCropperType
    var faceDetectedRect : CGRect?
    var needFaceDetection : Bool? = true
    
    
    
    func makeCoordinator() -> Coordinator {
        return CropperCoordinator(isGalleryPickerPresented: $isGalleryPickerPresented, isCropperiewPresented: $isCropperiewPresented, cropRect: $cropRect, didInformCropperView: $didInformCropperView, cropStyle: cropStyle, imageData: image)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Cropper>) -> Mantis.CropViewController {
        var config = Mantis.Config()
        var cropViewConfig = Mantis.CropViewConfig()
        config.cropToolbarConfig.toolbarButtonOptions = .myOption
        // Disable rotation by default for all cases
        cropViewConfig.showAttachedRotationControlView = false
        // If cropStyle is Circle then configuration.
        if cropStyle == .circle{
            cropViewConfig.showAttachedRotationControlView = false
            cropViewConfig.cropShapeType = .ellipse(maskOnly: false)
        }
        // If cropStyle is Ratio then configuration.
        else if cropStyle == .ratios{
            cropViewConfig.showAttachedRotationControlView = false
        }
        // If cropStyle is Custom then configuration.
        else if cropStyle == .custom{
            cropViewConfig.showAttachedRotationControlView = false
            cropViewConfig.rotateCropBoxFor90DegreeRotation = false
            config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: aspectSize.width / aspectSize.height)
        }
        
        if fixedAspectRatio {
            config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: aspectSize.width / aspectSize.height)
        }
        
        // If face detection needed then show cropper with detected image.
        if let needFaceDetection = needFaceDetection, needFaceDetection{
            if let faceBoundingBox = faceDetectedRect, faceBoundingBox != CGRect.zero {
                cropViewConfig.presetTransformationType = .presetNormalizedInfo(normalizedInfo: faceBoundingBox)
                config.cropViewConfig = cropViewConfig
            }
        }
        
        // Otherwise show with previousCropRect.
        else {
            if cropRect != CGRect.zero {
                cropViewConfig.presetTransformationType = .presetNormalizedInfo(normalizedInfo: cropRect)
                config.cropViewConfig = cropViewConfig
            }
        }
        
        // Create the controller with the config already set
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = context.coordinator
        
        return cropViewController
    }
}


class CropperCoordinator: NSObject, CropViewControllerDelegate{
    
    @Binding var isGalleryPickerPresented : Bool
    @Binding var isCropperiewPresented: Bool
    @Binding var cropRect: CGRect
    @Binding var didInformCropperView : Bool
    var cropStyle : ImageCropperType
    var image: UIImage
    

    
    init(isGalleryPickerPresented: Binding<Bool>, isCropperiewPresented: Binding<Bool>, cropRect: Binding<CGRect>, didInformCropperView : Binding<Bool>, cropStyle: ImageCropperType, imageData: UIImage){
        _isGalleryPickerPresented = isGalleryPickerPresented
        _isCropperiewPresented = isCropperiewPresented
        _cropRect = cropRect
        _didInformCropperView = didInformCropperView
        self.cropStyle = cropStyle
        image = imageData

    }
    
    
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        
        isCropperiewPresented = false
        
        // Extracting crop region points
        let topLeft = cropInfo.cropRegion.topLeft
        let topRight = cropInfo.cropRegion.topRight
        let bottomLeft = cropInfo.cropRegion.bottomLeft
        let bottomRight = cropInfo.cropRegion.bottomRight
        
        // Calculate min and max x and y coordinates
        let minX = min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
        let maxX = max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x)
        let minY = min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
        let maxY = max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y)
        
        // Calculate width and height
        let width = maxX - minX
        let height = maxY - minY

        cropRect = CGRect(x: minX, y: minY, width: width, height: height)
        didInformCropperView = true
        
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        isCropperiewPresented = false
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
        
    }
}


extension ToolbarButtonOptions{
    static public let myOption: ToolbarButtonOptions = [reset, ratio]
}
