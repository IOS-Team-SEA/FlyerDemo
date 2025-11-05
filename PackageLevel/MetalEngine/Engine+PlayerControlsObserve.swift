//
//  Engine+PlayerControlsObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

extension MetalEngine {
    
    func observePlayerControls() {
        guard let templateHandler = self.templateHandler else {
            printLog("template handler nil")
            return }
        
        playerControlsCancellables.removeAll()
        logVerbose("AudioPlayer + PlayerControls listeners ON \(playerControlsCancellables.count)")
        
        templateHandler.playerControls?.$renderState.dropFirst().sink { [weak self] playState in
            guard let self = self else { return }
            
            switch playState {
                
            case .Prepared:
                start()
            case .Playing:
                // JDChange
                logInfo("selectCurrentPage -> Playing..")
                templateHandler.selectCurrentPage()
                resume()
            case .Paused:
                pause()
            case .Stopped:
                stop()
            case .Completed:
                print("Completed")
                //stop()

            }
           
            
        }.store(in: &playerControlsCancellables)
        
        
    }
}
