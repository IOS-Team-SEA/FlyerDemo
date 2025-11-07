
//
//  ShareDirectManager.swift
//  IOSShareDirect
//
//  Created by JD on 8/4/20.
//
import UIKit
//import  IOS_CommonUtil
import IOS_CommonUtilSPM

public enum ViewLayout {
    case ListView
    case GridView
    case Automatic
}

public enum FileTypes {
    case Image
    case Video
    case zip
//    case Text
//    case Files
//    case Audio
    
}



public class ShareDirectConfig {
    
    public var viewLayout : ViewLayout = .Automatic
    var appColors : AppColors = AppColors(darkColor: .red, lightColor: .green, highLightColor: .clear, textColor: .white)
    var appName : String = "appName"
   
    public init(appColors : AppColors , appName : String) {
        self.appColors = appColors
        self.appName = appName
    }
}
