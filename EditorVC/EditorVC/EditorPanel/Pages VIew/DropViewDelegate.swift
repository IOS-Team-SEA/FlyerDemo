//
//  DropViewDelegate.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/07/24.
//

import Foundation
import SwiftUI
import IOS_CommonEditor

struct DropViewDelegate: DropDelegate {
    
    let destinationItem: MultiSelectedArrayObject
    @Binding var pages: [MultiSelectedArrayObject]
    @Binding var draggedItem: MultiSelectedArrayObject?
    @Binding var orderInParent : Int
    @Binding var hasOnce : Bool
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        print("Dragged Item will now\(destinationItem.orderID)")
        hasOnce = true
        orderInParent = pages.firstIndex(of: destinationItem)!
        draggedItem = nil
        return true
    }
    
    func dropExited(info: DropInfo) {
        print("Drop Exited")
    }
    
    
    
    func dropEntered(info: DropInfo) {
        if let draggedItem {
            let fromIndex = pages.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = pages.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.pages.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
    
    func dropEnded(info: DropInfo) {
        // This method is called when the drag and drop interaction ends
        print("Drag and drop interaction ended")
    }
}

