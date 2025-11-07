//
//  EditorVC+Util.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 22/01/25.
//
import UIKit
import IOS_CommonEditor


extension EditorVC {
    
    func calculateSizeForEditorView() -> (CGRect,CGPoint) {
        
        if loadingState == .Preview {
            let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            
            let HeightMargin = safeAreaInsetsTop  +  safeAreaInsetsBottom + navBarHeight
            let bottomPanelHeightConstant = ((UIScreen.main.bounds.height * 22) / 100) + 22 //250
            
            let tabbarHeight =  bottomPanelHeightConstant - 49 // self.tabBarController?.view.frame.height
            let size = CGSize(width:  UIScreen.main.bounds.width , height:  UIScreen.main.bounds.height - HeightMargin - CGFloat(tabbarHeight)).plus(-editorMargin)
            let origin = CGPoint(x: 0, y: (UIApplication.shared.cWindow?.safeAreaInsets.top ?? 0)  + navBarHeight )
            
            let center = CGPoint(x: editorMargin/2 + size.width/2, y: origin.y + ( editorMargin/2 + size.height/2))
            
            let frect =  CGRect(origin: origin, size: size)
            
            BASE_SIZE = size
            printLog("BaseSize \(size) Navbarheight \(navBarHeight) HeightMargin \(HeightMargin) bottomPanelHeightConstant \(bottomPanelHeightConstant) tabbarHeight \(tabbarHeight) ")
            PANEL_SIZE = 50
            
            return (frect,center)
        }else if loadingState == .Edit {
            let bottomPanelHeightConstant = 250
            
            let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            
            let HeightMargin = safeAreaInsetsTop  +  safeAreaInsetsBottom + navBarHeight
            
            let tabbarHeight = 49 + bottomPanelHeightConstant// self.tabBarController?.view.frame.height
            let size = CGSize(width:  UIScreen.main.bounds.width , height:  UIScreen.main.bounds.height - HeightMargin - CGFloat(tabbarHeight)).plus(-editorMargin)
            let origin = CGPoint(x: 0, y: (UIApplication.shared.cWindow?.safeAreaInsets.top ?? 0)  + navBarHeight )
            
            let center = CGPoint(x: editorMargin/2 + size.width/2, y: origin.y + ( editorMargin/2 + size.height/2))
            
            let frect =  CGRect(origin: origin, size: size)
            BASE_SIZE = size.plus(-editorMargin)
            PANEL_SIZE = 250
            
            return (frect,center)
        
        
        
            
            
       }
        logError("This Should'nt Have Happened")
        return (.zero,.zero)
    }
    
    func updateNecessaryValues() async{
        engine?.thumbManagar?.textureCache.fetchIdealSize = CGSize(width: 3000, height: 3000)
        engine?.thumbManagar?.textureCache.checkInCache = false
        await engine?.thumbManagar?.updatePageThumb(pageModel: engine!.templateHandler.currentPageModel!, currentTime: engine!.templateHandler.currentTemplateInfo!.thumbTime, size: CGSize(width: 1000, height: 1000))
        
        let image = engine?.templateHandler.currentPageModel?.thumbImage
        let templateId = engine?.templateHandler.currentTemplateInfo?.templateId
        let newThumbTime = engine?.templateHandler.currentTemplateInfo?.thumbTime
        
        _ = DBManager.shared.updateTemplateThumbTime(templateId: templateId!, newValue: newThumbTime!)
       
        let localFileName = "thumbnail_template_\(templateId!).png"
        do{
            if let imageData = image?.pngData() {
                try AppFileManager.shared.myDesigns?.replaceDataInFile(fileName: localFileName, imageData: imageData)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
//                    self.thumbStore.designs.removeValue(forKey: localFileName)
                    
                }
//                try ImageDownloadManager.saveOrUpdateImageToDocumentsDirectory(imageData: imageData, filename: localFileName)
            }
        }catch{
            logError("Failed to save the image.")
        }
    }
}


 
