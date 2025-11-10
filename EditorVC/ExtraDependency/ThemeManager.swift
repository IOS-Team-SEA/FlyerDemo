//
//  ThemeManager.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 13/02/24.
//

import UIKit
import Combine
import SwiftUI


enum AppTheme : String, CaseIterable {
    case adaptiveMode = "default_"
    case lightMode = "light_"
    case darkMode = " dark_"
    
//    func color(_ scheme: ColorScheme) -> Color{
//        switch self{
//        case .adaptiveMode:
//            return scheme == .dark ? .moon : .sun
//        case .lightMode:
//            return .sun
//        case .darkMode:
//            return .moon
//        
//        }
//    }
}

struct ColorArrayDict: Codable, Hashable{
    var key: String
    var value: String
}


class ThemeManager: ObservableObject {
    
    @Published var accentColor : UIColor = .systemPink//UIColor(named: "AccentColor")!
    static let shared = ThemeManager()
    
    private init() {
        applyTheme()
        syncDesignSystem(with: accentColor, theme: currentTheme)
    }
    
    static var lightModeColorArray: [ColorArrayDict] =
    [ColorArrayDict(key: "pink", value: "E94B7C"), ColorArrayDict(key: "blue", value: "24c6df"), ColorArrayDict(key: "orange", value: "E97B4B"), ColorArrayDict(key: "purple", value: "7C4BE9")]
                                                    
    
    static var darkModeColorArray: [ColorArrayDict] =
    [ColorArrayDict(key: "pink", value: "E95586"), ColorArrayDict(key: "blue", value: "1A237E"), ColorArrayDict(key: "orange", value: "E98555"), ColorArrayDict(key: "purple", value: "8250F5")]
    
     var _DarkModeAccentColor : ColorArrayDict?{
        set {
//            if let newValue = newValue {
                UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "_DarkModeAccentColor")
                applyTheme()
                syncDesignSystem(with: accentColor, theme: currentTheme)
//            }
        }
        get {
            if let data = UserDefaults.standard.value(forKey: "_DarkModeAccentColor") as? Data,
               let color = try? PropertyListDecoder().decode(ColorArrayDict.self, from: data) {
                return color
            }
            return ColorArrayDict(key: "blue", value: "24c6df")
        }
    }//  = UIColor.systemPink
    
     var _LightModeAccentColor: ColorArrayDict?{
        set {
//            if let newValue = newValue {
                UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "_LightModeAccentColor")
                applyTheme()
                syncDesignSystem(with: accentColor, theme: currentTheme)
//            }
        }
        get {
            if let data = UserDefaults.standard.value(forKey: "_LightModeAccentColor") as? Data,
               let color = try? PropertyListDecoder().decode(ColorArrayDict.self, from: data) {
                return color
            }
            return ColorArrayDict(key: "blue", value: "24c6df")
        }
    } // = UIColor.systemPink
    

    var currentTheme: AppTheme {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "AppTheme")
            applyTheme()
        }
        get {
//            if let key = UserDefaults.standard.value(forKey: "AppTheme") as? String , let theme = AppTheme(rawValue: key ) {
//                return theme
//            }
            return  .darkMode //.lightMode
        }
    }
    
    private static func switchTo(mode : UIUserInterfaceStyle) {
        UIApplication.shared.connectedScenes
           .first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows.forEach { window in
            window.overrideUserInterfaceStyle = mode
        }
    }
    
     func applyTheme() {
          switch currentTheme {
          case .lightMode:
              // Apply light theme styles
              accentColor = UIColor(hexString: _LightModeAccentColor!.value)!
              syncDesignSystem(with: accentColor, theme: currentTheme)
              ThemeManager.switchTo(mode: .light)
              // Update other styles as needed
          case .darkMode:
              // Apply dark theme styles
              accentColor = UIColor(hexString: _DarkModeAccentColor!.value)!//_LightModeAccentColor
              syncDesignSystem(with: accentColor, theme: currentTheme)
              ThemeManager.switchTo(mode: .dark)
              // Update other styles as needed
          case .adaptiveMode:
            
              if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                  accentColor = UIColor(hexString: _LightModeAccentColor!.value)!//_LightModeAccentColor
                  syncDesignSystem(with: accentColor, theme: currentTheme)
                  ThemeManager.switchTo(mode: .dark)
                     } else {
                         accentColor = UIColor(hexString: _DarkModeAccentColor!.value)!
                         syncDesignSystem(with: accentColor, theme: currentTheme)
                         ThemeManager.switchTo(mode: .light)
            }
              
              
            
          
          }
      }
    
    private func syncDesignSystem(with color: UIColor?, theme: AppTheme) {
        DS.ThemeManager.shared.style = theme.dsThemeStyle
        guard let color else {
            DS.ThemeManager.shared.resetAccentGradient()
            return
        }

        let accentGradient = DSGradient(accent: color)
        DS.ThemeManager.shared.setAccentGradient(start: accentGradient.start,
                                                 end: accentGradient.end,
                                                 startPoint: accentGradient.startPoint,
                                                 endPoint: accentGradient.endPoint)
    }
   
}

private extension AppTheme {
    var dsThemeStyle: DS.ThemeStyle {
        switch self {
        case .adaptiveMode:
            return .system
        case .lightMode:
            return .light
        case .darkMode:
            return .dark
        }
    }
}

private extension DSGradient {
    init(accent uiColor: UIColor) {
        let start = Color(uiColor: uiColor)
        let endUIColor = uiColor.lightened(by: 0.15)
        let end = Color(uiColor: endUIColor)
        self.init(start: start, end: end)
    }
}

private extension UIColor {
    func lightened(by amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            let newSaturation = max(min(saturation - amount, 1), 0)
            let newBrightness = max(min(brightness + amount, 1), 0)
            return UIColor(hue: hue, saturation: newSaturation, brightness: newBrightness, alpha: alpha)
        }
        return self
    }
}
