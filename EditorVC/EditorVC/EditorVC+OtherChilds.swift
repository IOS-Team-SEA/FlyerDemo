//
//  EditorVC+OtherChilds.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//
import UIKit
import SwiftUI
import IOS_CommonEditor

extension EditorVC {
    
    ///  timeline view setup 
    func addTimelineView() {
        
        if timelineView == nil {
            self.timelineView = TimelineView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), logger: AppPackageLogger(), timelineConfig: AppTimelineConfigure())
//            self.timelineView?.setPackageLogger(logger: AppPackageLogger(), timelineConfig: AppTimelineConfigure())
            if let timelineView = timelineView{
                
                    
                    timelineView.translatesAutoresizingMaskIntoConstraints = false // Enable autoresizing masks
                    
                    // Set dummy view properties
                    timelineView.backgroundColor = .orange // Set background color
                    
                    // Add dummy view to the main view
               
                    self.view.addSubview(timelineView)
                    
                    // Apply constraints to the dummy view
//                    NSLayoutConstraint.activate([
//                        // Leading constraint: 0 points from the leading edge of the main view
//                        timelineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                        
//                        // Trailing constraint: 0 points from the trailing edge of the main view
//                        timelineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                        
//                        // Height constraint: fixed height of 44 points
//                        //                    timelineView.heightAnchor.constraint(equalToConstant: 400 - tabbarHeight),
//                        timelineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
//                        
//                        
//                        // Top constraint: top of dummy view is anchored to the bottom of the editor view
//                        timelineView.topAnchor.constraint(equalTo: viewDummy.bottomAnchor , constant: 0)
//                    ])
                
                NSLayoutConstraint.activate([
                           timelineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           timelineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           timelineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                           timelineView.topAnchor.constraint(equalTo: viewDummy.bottomAnchor, constant: 0)
                       ])
                
            }
        }
    }
    
    
    
    func addPlayerControlView() {
        guard  let engine = engine, let editorView = engine.editorView else { return }
        viewDummy.translatesAutoresizingMaskIntoConstraints = false // Enable autoresizing masks
        
        
        // Set dummy view properties
        viewDummy.backgroundColor = .orange // Set background color
        
        // Add dummy view to the main view
        view.addSubview(viewDummy)
        
        // Apply constraints to the dummy view
        NSLayoutConstraint.activate([
            // Leading constraint: 0 points from the leading edge of the main view
            viewDummy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),/*equalTo: view.leadingAnchor*/
            
            // Trailing constraint: 0 points from the trailing edge of the main view
            viewDummy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            // Height constraint: fixed height of 44 points
            viewDummy.heightAnchor.constraint(equalToConstant: 44),
            
            // Top constraint: top of dummy view is anchored to the bottom of the editor view
            viewDummy.topAnchor.constraint(equalTo: editorView.bottomAnchor, constant: 5 + editorMargin)
        ])
            
            viewDummy.roundCorners(corners: .allCorners, radius: 8)
    
    }
    
//    func useMeButtonAdd() {
//        // Create UIButton
//        let addButton = UIButton()
//        addButton.backgroundColor = .lightGray
//        addButton.setTitle("Use Me", for: .normal)
//        addButton.setTitleColor(.green, for: .normal)
////        addButton.addTarget(self, action: #selector(relayoutViewForEdit), for: .touchUpInside)
//        
//        // Add UIButton as subview
//        hostingerController!.view.addSubview(addButton)
//  
//    }
}
