import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage) -> Void
    var imagePickerDismiss: (Bool) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onImagePicked: onImagePicked, imagePickerDismiss: imagePickerDismiss)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onImagePicked: (UIImage) -> Void
        let imagePickerDismiss: (Bool) -> Void
        
        init(onImagePicked: @escaping (UIImage) -> Void, imagePickerDismiss: @escaping (Bool) -> Void) {
            self.onImagePicked = onImagePicked
            self.imagePickerDismiss = imagePickerDismiss
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                onImagePicked(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            imagePickerDismiss(true)
        }
    }
}

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct PHImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    var filter: PHPickerFilter = .images
    var selectionLimit: Int = 1
    var onImagePicked: (UIImage) -> Void
    var pickerDismissed: (Bool) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = selectionLimit
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Convert RAW (ARW, CR3, NEF, etc.) to UIImage using Core Image
    func convertRAWToUIImage(from url: URL) -> UIImage? {
        let context = CIContext()

        if let rawImage = CIImage(contentsOf: url),
           let cgImage = context.createCGImage(rawImage, from: rawImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        // Fallback: Try using ImageIO if Core Image fails
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            print("Failed to create CGImageSource")
            return nil
        }

        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 4000
        ]

        if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHImagePicker
        
        init(parent: PHImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                // Handle the no selection case
                if results.isEmpty {
                    self.parent.pickerDismissed(true)
                    return
                }
                
                // Handle the results
            if let result = results.first {
                let provider = result.itemProvider
                
                // Try loading as a RAW image first
                if provider.hasItemConformingToTypeIdentifier(UTType.rawImage.identifier) {
                    provider.loadFileRepresentation(forTypeIdentifier: UTType.rawImage.identifier) { [weak self] url, error in
                        guard let self = self, let url = url, error == nil else {
                            print("Error loading RAW file:", error?.localizedDescription ?? "Unknown error")
                            return
                        }
                        
                        if let rawImage = self.parent.convertRAWToUIImage(from: url) {
                            DispatchQueue.main.async {
                                self.parent.onImagePicked(rawImage)
                            }
                        } else {
                            print("Failed to process RAW image")
                        }
                    }
                }
                // Try loading as a normal image
                else if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        guard let self = self, let image = image as? UIImage, error == nil else {
                            print("Failed to load normal image:", error?.localizedDescription ?? "Unknown error")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.parent.onImagePicked(image)
                        }
                    }
                }
            }
        }
    }
}
