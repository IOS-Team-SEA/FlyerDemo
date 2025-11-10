//
//  EditorVC+SaveExport.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//
import UIKit
import SwiftUI
import Combine
import IOS_CommonEditor

extension EditorVC {
    
    func onSave() {
        
        
        // loader will show with SupportInterfaceProtocol
        // onTask saving started
        //
        
        
        
        // var settings = ExportSettings()
        // settings.exportType = .Video
        // settings.resolution = .SD

        guard let engine = engine else { return }

        engine.templateHandler.exportSettings.audioFileURL = engine.templateHandler.currentActionState.currentMusic?.musicPath ?? ""
        engine.templateHandler.exportSettings.videoLength = engine.templateHandler.currentTemplateInfo?.totalDuration ?? 5.0
        engine.templateHandler.exportSettings.thumbTime = engine.templateHandler.currentTemplateInfo?.thumbTime ?? 0.0
        // Show custom loader if not already shown
        if loaderHostingController == nil {
            if let thumbImage = engine.templateHandler.currentPageModel?.thumbImage {
                showCustomLoader(with: thumbImage)
            }
        }

        // Update template category
        _ = DBManager.shared.updateTemplateCategory(templateId: currentTemplateID, newValue: "SAVED")
        
        let newImage = engine.templateHandler.currentPageModel?.thumbImage

        do {
            let fileName = "thumbnail_template_\(engine.templateHandler.currentTemplateInfo!.templateId).png"
            
            guard let documentsDirectory = AppFileManager.shared.myDesigns?.url/*FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first*/ else {
                throw SaveImageError.documentsDirectoryNotFound
            }
            
            if let image = newImage {
                if let imageData = image.pngData() {
                    try imageData.write(to: documentsDirectory.appendingPathComponent(fileName), options: .atomic)
                    print("Image replaced successfully.")
                } else {
                    print("Failed to convert image to data.")
                }
            }
        } catch {
            print("Error replacing image: \(error.localizedDescription)")
        }
        
        let isUserFree = !(UIStateManager.shared.isPremium || engine.templateHandler.currentTemplateInfo?.isPremium == 1)
        
        // Global instance to start cancel/restart saving offline
        let renderer : OfflineSceneRenderer? = OfflineSceneRenderer(settings: engine.templateHandler.exportSettings, fileHandler: AppFileManager.shared, isUserSubscribed: !isUserFree, logger: AppPackageLogger(), resourceProvider: AppResourceProvider(), sceneConfig: AppSceneConfigure())
       
        self.loaderState.$didCancelTapped.dropFirst().sink { value in
            if value == true {
                renderer?.cancelSaving()
            }
        }
        .store(in: &self.cancellablesForEditor)
        
        // To listen for callbacks
        renderer?.offlineRenderState = { [weak self] state in
            guard let self = self else { return }

            // Use the async/await approach to update the UI on the main thread
            Task { @MainActor in
                // self.navTitle.text = state.message

                if state == .InProgress(state.progress) {
                    printLog("progress loader \(state.progress)")
                   
                    
                    self.updateLoaderProgress(to: CGFloat(state.progress))
                }
                
                if state == .Cancelled {
                   // self.navTitle.text = ""
                    self.hideCustomLoader()
                    self.cancellablesForEditor.removeAll()
                }
                
                if state == .Complete {
                    self.cancellablesForEditor.removeAll()
                    
                        if engine.templateHandler.exportSettings.exportType == .Video {
                            self.hideCustomLoader(){
                                if let url = AppFileManager.shared.exportVideoFile?.url {
                                    
                                    let exportPage = ExportPage(
                                        url: url,
                                        exportType: .Video,
                                        onCloseTapped: { [weak self] in self?.dismiss(animated: true) },
                                        onHomeTapped: { [weak self] in
                                            self?.dismiss(animated: true)
                                            self?.navigationController?.popToRootViewController(animated: true)
                                        }
                                    )
                                    
                                    
                                    self.exportHostingerController = UIHostingController(rootView: exportPage)
                                    self.exportHostingerController?.isModalInPresentation = true
                                    
                                    if let hostingVC = self.exportHostingerController {
                                        self.present(hostingVC, animated: true)
                                    } else {
                                        print("export page hostinger is nil")
                                    }
                                    let currentTemplate = engine.templateHandler.currentTemplateInfo!
                                    
//                                    self.anayticsLogger.logTemplateInteraction(action: .savedAsSaved, templateTitle: currentTemplate.templateName, categoryName: currentTemplate.categoryTemp)
                                    
//                                    self.anayticsLogger.logExport(exportAction: .videoSaved, format: "mp4", resolution: engine.templateHandler.exportSettings.resolution.displayTitle)
//                                    print("watch ads pressed")
                                }
                            }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.hideCustomLoader(){
                                print("Loader Dismiss Successfully.")
                                if let url = AppFileManager.shared.exportImageFile?.url {
//#if DEBUG
                                    
                                    var isJPeg = engine.templateHandler.exportSettings.exportImageFormat == .JPEG ? true : false
                                     //saveToCameraRoll(url) // Ideally move this URL to Export Page ( URL )
//#endif
                                    let exportPage = ExportPage(
                                        url: url,
                                        isJpeg: isJPeg,
                                        exportType: .Photo,
                                        onCloseTapped: { [weak self] in self?.dismiss(animated: true) },
                                        onHomeTapped: { [weak self] in
                                            self?.dismiss(animated: true)
                                            self?.navigationController?.popToRootViewController(animated: true)
                                        }
                                    )
                                    
                                    self.exportHostingerController = UIHostingController(rootView: exportPage)
                                    self.exportHostingerController?.isModalInPresentation = true
                                    
                                    if let hostingVC = self.exportHostingerController {
                                        
                                        self.present(hostingVC, animated: true) {
                                            print("Export view presented successfully")
                                        }
                                    } else {
                                        print("export page hostinger is nil")
                                    }
                                    let currentTemplate = engine.templateHandler.currentTemplateInfo!
                                    
                                    
//                                    self.anayticsLogger.logTemplateInteraction(action: .savedAsSaved, templateTitle: currentTemplate.templateName, categoryName: currentTemplate.categoryTemp)
                                    
//                                    self.anayticsLogger.logExport(exportAction: .imageCreated, format: engine.templateHandler.exportSettings.exportImageFormat.displayTitle, resolution: "2048x2048")
                                }
                            }
                        }
                    }
                    
                }
            }
        }

        // To save offline (video/image both)
        renderer?.saveOffline(tempId: engine.templateHandler.currentTemplateInfo!.templateId)
      
    }
    
    func onSaveAndContinue() {
        guard let engine = engine else { return }

//         engine.thumbManagar?.updatePageThumb(pageModel: engine.templateHandler.currentPageModel!, currentTime: engine.templateHandler.currentTemplateInfo!.thumbTime, size: CGSize(width: 1000, height: 1000))
//        
//        let newImage = engine.templateHandler.currentPageModel?.thumbImage
//
//        do {
//            let fileName = "thumbnail_template_\(engine.templateHandler.currentTemplateInfo!.templateId).jpg"
//            
//            guard let documentsDirectory = AppFileManager.shared.myDesigns?.url/*FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first*/ else {
//                throw SaveImageError.documentsDirectoryNotFound
//            }
//            
//            if let image = newImage {
//                if let imageData = image.jpegData(compressionQuality: 1.0) {
//                    try imageData.write(to: documentsDirectory.appendingPathComponent(fileName), options: .atomic)
//                    print("Image replaced successfully.")
//                } else {
//                    print("Failed to convert image to data.")
//                }
//            }
//        } catch {
//            print("Error replacing image: \(error.localizedDescription)")
//        }
        
        
        _ = DBManager.shared.updateTemplateCategory(templateId: currentTemplateID, newValue: "SAVED")
        let tempModel = DBManager.shared.getTemplate(templateId: currentTemplateID)
//        if let model = tempModel{
//            _ = DBManager.shared.deleteTemplateRow(templateId: model.originalTemplate, ratioId: 0)
//        }
        
        if let model = tempModel{
//            let newTempModel = DBManager.shared.getTemplate(templateId: model.originalTemplate)
//            if let newTempModel = newTempModel{
//                _ = DBManager.shared.updateTemplateSoftDelete(templateId: newTempModel.templateId, newValue: 0)
//            }else{
//                _ = DBManager.shared.deleteTemplateRow(templateId: model.originalTemplate, ratioId: 0)
//            }
            if model.originalTemplate != 0{
                _ = DBManager.shared.deleteTemplateRow(templateId: model.originalTemplate, ratioId: 0)
            }
//            if let newTempModel = newTempModel{
//                if newTempModel.templateEventStatus == "PUBLISHED"{
//                    _ = DBManager.shared.updateTemplateSoftDelete(templateId: newTempModel.templateId, newValue: 0)
//                }else{
//                    _ = DBManager.shared.deleteTemplateRow(templateId: model.originalTemplate, ratioId: 0)
//                }
//            }
        }
        onExitEditorVC()
        onDismiss?(.saved(templateId: currentTemplateID))
    }
    
    
}





