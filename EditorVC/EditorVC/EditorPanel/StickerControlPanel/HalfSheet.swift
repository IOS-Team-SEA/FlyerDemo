//
//  CustomSheet.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 13/03/24.
//

import SwiftUI

//Custom Half Sheet Modifier
//extension View{
//    func halfSheet<SheetView: View>(showSheet : Binding<Bool>, @ViewBuilder sheetView : @escaping () -> SheetView, onEnd : @escaping ()->())-> some View{
//        
//        return self
//            .background(
//                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
//            )
//    }
//}
//
////UIKit Integration
//struct HalfSheetHelper<SheetView : View> : UIViewControllerRepresentable{
//    var sheetView : SheetView
//    @Binding var showSheet: Bool
//    var onEnd: ()->()
//    let controller = UIViewController()
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        controller.view.backgroundColor = .clear
//        
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        if showSheet{
//            let sheetController = CustomHostingerController(rootView: sheetView)
//            sheetController.presentationController?.delegate = context.coordinator
//            uiViewController.present(sheetController, animated: true)
//        }
////        else{
//////            DispatchQueue.main.async {
////                uiViewController.dismiss(animated: true)
//////            }
////            
////        }
//    }
//    
//    class Coordinator : NSObject , UISheetPresentationControllerDelegate{
//        var parent : HalfSheetHelper
//        
//        init(parent: HalfSheetHelper) {
//            self.parent = parent
//        }
//        
//        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//            parent.onEnd()
//        }
//    }
//    
//}
//
////Custom UIHostingerController for Half Sheet...
//class CustomHostingerController<Content : View> : UIHostingController<Content>{
//    override func viewDidLoad() {
//        if let presentationController = presentationController as? UISheetPresentationController{
//            presentationController.detents = [
//                .medium(),
//                .large()
//            ]
//            presentationController.prefersGrabberVisible = true
//        }
//    }
//}
