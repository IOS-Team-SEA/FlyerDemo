//
//  AppStyle.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 13/02/24.
//

import UIKit
import SwiftUI

struct AppStyle /*: AccentColorable*/{
    
//    static var accentColor : UIColor = .systemPink
    //corner radius
    
    

    enum Typography {
        
        case regular(_ textStyle : UIFont.TextStyle )
        case bold(_ textStyle : UIFont.TextStyle )
        case custom(_ textStyle : UIFont.TextStyle , weight : UIFont.Weight)
        case customSize(_ fontSize: CGFloat , weight : UIFont.Weight)

        func apply() -> UIFont {
            switch self {
                
            case .bold(let textStyle):
                return UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: textStyle).pointSize)
            case .regular(let textStyle):
                return UIFont.preferredFont(forTextStyle: textStyle)
            case .custom(let textStyle, weight: let weight) :
                return UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: textStyle).pointSize, weight: weight)
            case .customSize(let fontSize, weight: let weight) :
                return  UIFont.systemFont(ofSize: fontSize, weight: weight)
      
            }
        }
        
        
    }
    
    
   
        
   
        
    
}

protocol AccentColorable {
   static var accentColor : UIColor { get }
}
extension AppStyle {
    static var accentColorUIKit : UIColor {
        ThemeManager.shared.accentColor
    }
    static var accentColor_SwiftUI : SwiftUI.Color {
        DS.DSColor.accentColor()
    }

    static func accentGradient(for scheme: ColorScheme? = nil) -> LinearGradient {
        DS.DSColor.accentGradient()
    }

    static func textPrimary(for scheme: ColorScheme? = nil) -> Color {
        DS.DSColor.textPrimary()
    }

    static func textSecondary(for scheme: ColorScheme? = nil) -> Color {
        DS.DSColor.textSecondary()
    }

    static var defaultImage = UIImage(named: "loading")
    
    static var TWO_NANO_SEC : UInt64 = 1_500_000_000
}


//struct EditorSettings {
//    var showTimeline : Bool = true
//    var snappingMode : SnappingMode = .basic
//}

class AppViewStyle{
    
    
    
    
    
    static var invitationCardWidth : CGFloat {
          return 130
      }
    
    static var spacing : CGFloat {
        DS.Spacing.x8
    }
    
    // padding
    static var smallPadding:CGFloat{
        DS.Spacing.x8
    }
    static var normalPadding:CGFloat{
        DS.Spacing.x12
    }
    static var largePadding:CGFloat{
        DS.Spacing.x16
    }
    
    
    //corner Radius
    
    static var smallCornerRadius:CGFloat{
        DS.CornerRadius.x8
    }
    static var normalCornerRadius:CGFloat{
        DS.CornerRadius.x12
    }
    static var largeCornerRadius:CGFloat{
        DS.CornerRadius.x16
    }
    
    static var XlargeCornerRadius:CGFloat{
        DS.CornerRadius.x16
    }
    
    
    
    // shimmer Effect
    

    
    
    
    static var smallestComponent:CGFloat{
        return 30
    }
    static var smallComponentHeight:CGFloat{
        return 60
    }
    static var normalComponentHeight:CGFloat{
        return 100
    }
    
    
}
