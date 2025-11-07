//
//  ShareDirectManager.swift
//  IOSShareDirect
//
//  Created by JD on 8/11/20.
//

import Foundation
//import IOS_CommonUtil
import IOS_CommonUtilSPM

public protocol  ShareDirectDelegate : AnyObject {
    func failedToLaunch(app AppName : String)
    func failedToReadFile(file FileName : String , appName : String)
}



public struct ShareDirect   {
    
    public static let instaManager = InstaManager()
    public static let fbManager = FBManager()
    public static let mailManager = MailManager()
    public static let photoAlbumManager = PhotoLibraryManager.shared
    public static let socialsManager =  SocialsAndMoreManager(allowSocialsOnly: true)
    public static let more = SocialsAndMoreManager(allowSocialsOnly: false)

}










