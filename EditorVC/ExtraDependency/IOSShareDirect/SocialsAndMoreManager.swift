//
//  WhatsAppManager.swift
//  IOSShareDirect
//
//  Created by JD on 8/11/20.
//

import Foundation
import Photos
//import IOS_CommonUtil
import IOS_CommonUtilSPM
import UIKit

public protocol SocialsAndMoreDelegate : AnyObject {
    func present(socialsVC : UIActivityViewController , error : SwiftError?)
    func present(moreSystemVC : UIActivityViewController , error : SwiftError?)
}

public class SocialsAndMoreManager : NSObject ,UIDocumentInteractionControllerDelegate {
    
    private var allowSocialsOnly : Bool = true
    
    public weak var delegate : SocialsAndMoreDelegate?
    
    var systemActivities = [
        UIActivity.ActivityType.assignToContact,
        UIActivity.ActivityType.airDrop,
        UIActivity.ActivityType.copyToPasteboard,
        UIActivity.ActivityType.mail,
        UIActivity.ActivityType.message,
        UIActivity.ActivityType.print,
        UIActivity.ActivityType.addToReadingList,
        UIActivity.ActivityType.saveToCameraRoll,
        UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension"),
        UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
        UIActivity.ActivityType.openInIBooks
    ]
    
    public  init(allowSocialsOnly : Bool) {
        super.init()
        self.allowSocialsOnly = allowSocialsOnly
    }
    
    public func share(image:UIImage , imageName : String = "Image" ) {
        
        
        if let imageData = getData(image: image){
            if let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/\(imageName).png") {
            do {
                try imageData.write(to: tempFile)

            
      
                let activityController = UIActivityViewController(activityItems: [tempFile], applicationActivities: nil)
                activityController.setValue(imageName, forKey: "subject")
                if allowSocialsOnly {
                    activityController.excludedActivityTypes = systemActivities
                    self.delegate?.present(socialsVC: activityController, error: nil)
                }else{
                    self.delegate?.present(moreSystemVC: activityController, error: nil)

                }
                

            } catch {
                print(error)
                self.delegate?.present(moreSystemVC: UIActivityViewController(activityItems: [], applicationActivities: nil), error: SwiftError.generalMessage(.savingFailed))

            }
        }
    
        }
}
    public func share(video:URL , videoName : String = "Video") {
           if let imageData = getData(videoOrAudio: video) {
                                    if let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/\(videoName).mov") {
                                    do {
                                        try imageData.write(to: tempFile)
                       
                             
                                        let activityController = UIActivityViewController(activityItems: [tempFile], applicationActivities: nil)
                                            activityController.setValue(videoName, forKey: "subject")

                                        if allowSocialsOnly {
                                            activityController.excludedActivityTypes = systemActivities
                                            self.delegate?.present(socialsVC: activityController, error: nil)
                                        }else{
                                            self.delegate?.present(moreSystemVC: activityController, error: nil)
                                        }
                                        
                                    } catch {
                                        print(error)
                                        self.delegate?.present(moreSystemVC: UIActivityViewController(activityItems: [], applicationActivities: nil), error: SwiftError.generalMessage(.savingFailed))

                                    }
                                    }
                                }
    }

}


