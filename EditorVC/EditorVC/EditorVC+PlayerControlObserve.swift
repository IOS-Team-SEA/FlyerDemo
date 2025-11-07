//
//  EditorVC+PlayerControlObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

extension EditorVC {
    func observePlayerControls() {
        
        guard let engine = engine, let templateHandler = engine.templateHandler else {
            printLog("template handler nil")
            return }
        
        playerControlsCancellables.removeAll()
        logVerbose("EditorVC + PlayerControls listeners ON \(playerControlsCancellables.count)")
        
        templateHandler.playerControls?.$renderState.dropFirst().sink {[weak self] state in
            if state == .Playing{
                self?.muteHostingerController.view.isHidden = false
            }else{
                if let view = self?.muteHostingerController?.view{
                    view.isHidden = true
                }
            }
        }.store(in: &playerControlsCancellables)
        
        
    }
}
