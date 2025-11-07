//
//  EditorVC+UndoRedo.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//
import UIKit
import SwiftUI
import IOS_CommonEditor

extension EditorVC {
    /// undoredo
    
    @objc func undoAction() {
        
        //engine?.undoRedoManager.undoState = true
        if let engine = engine{
            if engine.timeLoopHandler?.renderState == .Playing{
                engine.timeLoopHandler?.renderState = . Paused
            }
            engine.undoRedoManager?.undoState = true
            engine.undoRedoExecutor?.PerformUndoAction(engine: engine)
            engine.undoRedoManager?.undoState = false
        }
       // UndoRedoManager.undoState = false
    }
    
    @objc func exportAction() {
        if let engine = engine{
            engine.templateHandler.currentActionState.exportPageTapped = true
            
          
        }
        
    }
    
    @objc func redoAction() {
        
        //UndoRedoManager.undoState = true
        if let engine = engine{
            if engine.timeLoopHandler?.renderState == .Playing{
                engine.timeLoopHandler?.renderState = . Paused
            }
            engine.undoRedoManager?.undoState = true
            engine.undoRedoExecutor?.PerformRedoAction(engine: engine)
            engine.undoRedoManager?.undoState = false
        }
       // UndoRedoManager.undoState = false
    }
    
    func observeUndoRedoCount () {
        
        undoRedoCancellables.removeAll()
        
        guard let engine = engine , let undoRedoManager = engine.undoRedoManager else {
            logWarning("UndoRedo Not Enable")
            return
        }
        
        undoRedoManager.$redoNumberCount.dropFirst().sink { [weak self] newValue in
            if newValue{
                // Update the button text to indicate the next action
                if let redoButton = self?.redoButton{
                    self?.updateBarButtonItem(redoButton, newText: "\(self?.engine?.undoRedoManager?.redoCount() ?? 0)")
                    redoButton.isEnabled = true
                    redoButton.title = "(\(self?.engine?.undoRedoManager!.redoCount() ?? 0)"
                }
                
            }else{
                if let redoButton = self?.redoButton{
                    self?.updateBarButtonItem(redoButton, newText: "\(self?.engine?.undoRedoManager?.redoCount() ?? 0)")
                    redoButton.isEnabled = false
                    redoButton.title = "(\(self?.engine?.undoRedoManager!.redoCount() ?? 0))"
                }
                
            }
        }.store(in: &undoRedoCancellables)
        undoRedoManager.$undoNumberCount.dropFirst().sink { [weak self] newValue in
            if newValue{
                if let undoButton = self?.undoButton{
                    self?.updateBarButtonItem(undoButton, newText: "\(self?.engine?.undoRedoManager?.undoCount() ?? 0)")
                    undoButton.isEnabled = true
                    undoButton.title = "(\(self?.engine?.undoRedoManager!.undoCount() ?? 0))"
                }
                
            }else{
                if let undoButton = self?.undoButton{
                    self?.updateBarButtonItem(undoButton, newText: "\(self?.engine?.undoRedoManager?.undoCount() ?? 0)")
                    undoButton.isEnabled = false
                    undoButton.title = "(\(self?.engine?.undoRedoManager!.undoCount() ?? 0))"
                }
            }
        }.store(in: &undoRedoCancellables)
    }
    
}
