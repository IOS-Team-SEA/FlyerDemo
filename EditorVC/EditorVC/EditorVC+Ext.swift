//
//  EditorVC+Ext.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 12/03/24.
//

import Foundation
import UIKit
import SwiftUI
import IOS_CommonEditor

var glob_constant: CGFloat = 75 // 64
var tabbarWidth: CGFloat{
    return .infinity
} //= 377
var tabbarHeight : CGFloat {
    return glob_constant
}

var bottomMargin : CGFloat {
    return (UIApplication.shared.cWindow?.safeAreaInsets.bottom ?? 0.0) 
}

var containerHeight: CGFloat{
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 250
    }else{
        return 250
    }
}// = 200
var containerDefaultHeight: CGFloat = 64

var bottomPadding: CGFloat{
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 0
    }else{
        return 0
    }
}

var panelHeight: CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 186
    }else{
        return 186
    }
}// = 125

extension EditorVC : ContainerHeightProtocol{
    func didContainerHeightChanged(height: CGFloat) {
        containerPanelHeightConstraint?.constant = height + safeAreaInsetsBottom
    }
    
    //    func createContainerView() {
    //        if let containerView = containerView{
    //            containerView.backgroundColor = UIColor.clear
    //            containerView.translatesAutoresizingMaskIntoConstraints = false
    //            self.view.addSubview(containerView)
    //
    //            // Set the height constraint
    //            containerPanelHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: CGFloat(glob_constant))
    //            containerPanelHeightConstraint?.priority = UILayoutPriority(800)
    //            containerPanelHeightConstraint?.isActive = true
    //
    //            let bottomConstarint = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    //            bottomConstarint.priority =  UILayoutPriority(500)
    //            bottomConstarint.isActive = true
    //
    //            // Add other constraints as needed
    //            NSLayoutConstraint.activate([
    //                containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
    //                containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    //                containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
    //            ])
    //        }
    
    func createUIKitBottomContainer() {
        
        if self.containerView == nil {
            containerView = UIView()
            containerView!.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(containerView!)
            
            containerView?.backgroundColor = .systemBackground

            
            // Set up the constraints to the leading, trailing, and bottom safe area
            NSLayoutConstraint.activate([
                containerView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                containerView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                containerView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor) // 20 points above safe area
            ])
        }
        guard let containerView = containerView else { return }

            // Set the height constraint
        if let containerPanelHeightConstraint = containerPanelHeightConstraint {
            containerView.removeConstraint(containerPanelHeightConstraint)
        }
      
        let bottomPadding = UIApplication.shared.cWindow?.safeAreaInsets.bottom
        containerPanelHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: CGFloat(glob_constant) + (bottomPadding ?? (UIDevice.current.userInterfaceIdiom == .pad ? 0 : 34)))
            containerPanelHeightConstraint?.priority = UILayoutPriority(800)
            containerPanelHeightConstraint?.isActive = true
    }
    
//    func addSwiftUIOpacityView() {
//        if let engine = self.engine{
//            if let containerView = containerView{
//                
//                let thumbImage = engine.templateHandler.currentPageModel?.thumbImage
//                self.thumbnailImage = thumbImage
//                        
//                        // Use @StateObject to create a state wrapper around the image
//                let thumbnailImageState = State(initialValue: thumbImage)
//                hostingerController?.view.removeFromSuperview()
//                hostingerController?.removeFromParent()
//                hostingerController = UIHostingController(
//                    rootView: AnyView(
//                        BaseContainer(
//                            baseContentType: engine.editorUIState,
//                            thumbImage: Binding(
//                                get: {
//                                    thumbnailImageState.wrappedValue
//                                },
//                                set: { [weak self] newValue in
//                                    guard let self = self else { return }
//                                    
//                                    thumbnailImageState.wrappedValue = newValue
//                                }
//                            ),
//                            actionStates: engine.templateHandler.currentActionState,
//                            exportSettings: engine.templateHandler.exportSettings,
//                            delegate: self // Ensure delegate is weak in BaseContainer
//                        ).environment(\.sizeCategory, .medium)
//                    )
//                )
//                
//                
//                observeCurrentActions()
//                observeEditorAction()
//                controlPanelManager?.observeControlManager()
//                //        self.engine.currentModel = TextInfo()
//                //        hostingerController = UIHostingController(rootView: TextContainer(currentModel: self.engine.currentModel as! TextInfo, currentActionModel: self.engine.actionStates, delegate: self))
//                
//                   self.addChild(hostingerController!)
//                        containerView.addSubview(hostingerController!.view)
//                        hostingerController!.didMove(toParent: self)
//                        
//                hostingerController!.view.frame = CGRect(x: 0, y: 0, width: Int(containerView.frame.size.width), height: Int(containerView.frame.size.height) )
//                hostingerController?.view.backgroundColor = UIColor.systemBackground//UIColor(named: "editorBG")
//              
//                //        }
//                //        }
//                
//            }
//        }
//    }
}

