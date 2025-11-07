//
//  CustomColorPicker.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 09/04/24.
//

import Foundation
import SwiftUI
import Combine


struct CustomColorPicker: UIViewControllerRepresentable {
    
    @Binding var selectedColor: UIColor
    @Binding var isPresented: Bool
    @Binding var endColor: UIColor
    @Binding var isDropperViewPresented: Bool
    @Binding var updatethumb: Bool
//    @Binding var startColor: UIColor
    
    func makeUIViewController(context: Context) -> ColorPickerViewController {
        let vc = ColorPickerViewController()
        vc.supportsAlpha = false
        let configuration = ColorPickerConfiguration.default
        // Configure your color picker as needed
        vc.selectedColor = selectedColor
        vc.configuration = configuration
        vc.setDelegate(context.coordinator)
        vc.actionDelegate = context.coordinator
        return vc
        
    }
    
    func updateUIViewController(_ uiViewController: ColorPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, ColorPickerViewControllerDelegate, ColorPickerViewControllerActionDelegate {
        func colorPickerViewControllerDidFinish(_ viewController: ColorPickerViewController) {
            parent.endColor = viewController.selectedColor
            parent.selectedColor = viewController.selectedColor
            parent.updatethumb = true
//            parent.startColor = viewController.selectedColor
            viewController.dismiss(animated: true, completion: nil)
        }
        
        func colorPickerViewControllerDidSelectScreenColorPicker(_ viewController: ColorPickerViewController) {
            viewController.dismiss(animated: true)
            parent.isDropperViewPresented = true
//            let scenes = UIApplication.shared.connectedScenes
//            let windowScenes = scenes.compactMap({ $0 as? UIWindowScene })
//            if let windowScene = windowScenes.first(where: { $0.activationState == .foregroundActive }) {
//                let picker = ScopeColorPicker(windowScene: windowScene)
//                Task {
//                    let color = await picker.pickColor()
//                    parent.selectedColor = color
//                    isPresented = true
//                }
//            }
//            viewController.present(UIHostingController(rootView: CustomColorDropperView(image: UIImage(named: "b0")!, currentColor: parent.$endColor, onDone: { [self] color in
//                viewController.dismiss(animated: true)
//                parent.selectedColor = color
//                
//            })), animated: true)
        }
        
        func colorPickerViewController(_ viewController: ColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            print("Selected Color: \(color), Continuously: \(continuously)")
            parent.selectedColor = color
        }
        
        let parent: CustomColorPicker
        @Binding var isPresented: Bool
        
        init(parent: CustomColorPicker, isPresented: Binding<Bool>) {
            self.parent = parent
            self._isPresented = isPresented
        }
        
    }
}

