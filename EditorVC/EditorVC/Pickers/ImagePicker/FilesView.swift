//
//  FilesView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 18/03/24.
//

import SwiftUI
import UniformTypeIdentifiers
import PhotosUI

struct FilesView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIDocumentPickerViewController
    
//    @Binding var selectedImageURL: URL?
    @Binding var selectedImage: UIImage?
    @Binding var isCropperiewPresented: Bool
    
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentTypes = [UTType.image]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilesView
        
        init(parent: FilesView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            if let selectedURL = urls.first {
//                parent.selectedImageURL = selectedURL
//                print(parent.selectedImageURL!)
//            }
            if let selectedURL = urls.first {
                if let imageData = try? Data(contentsOf: selectedURL), let image = UIImage(data: imageData) {
                    parent.selectedImage = image
//                    parent.selection = .gallery
                    parent.isCropperiewPresented = true
                }
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle cancellation if needed
        }
    }
}

//#Preview {
//    FilesView()
//}


