//
//  HuePanel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 06/04/24.
//

import SwiftUI
import IOS_CommonEditor
//import SwiftUIIntrospect

struct HuePanel: View {
    
//    @State var hue: Float = 0
    @Binding var beginHue: AnyColorFilter?
    @Binding var endHue: AnyColorFilter?
    @Binding var stickerFilter: AnyColorFilter?
    @Binding var updateThumb : Bool
    
    var body: some View {
        let hueBinding = bindingForHueValue(bg: $stickerFilter)
        let noneBinding = bindingForNoneValue(bg: $stickerFilter)
        
        VStack{
            
            HStack{
                
                Button{
                    noneBinding.wrappedValue = true
                    endHue = HueFilter(filter: 0.0)
                } label: {
                    SwiftUI.Image("reset")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(AppStyle.accentColor_SwiftUI)
                        .frame(width: 20, height: 20)
                    
                    Text("Reset_")
                        .foregroundColor(AppStyle.accentColor_SwiftUI)
                }
                .padding(.leading, 20)
                Spacer()
                
            }
            .frame(height: 40)
            HStack{
                Text("Hue_")
                    .font(.subheadline)
//                if let hue = stickerFilter as? HueFilter, let beginHue = beginHue as? HueFilter, let endHue = endHue as? HueFilter{
                    Slider(
                        
                        value: hueBinding,
                        in: 0...360,
                        onEditingChanged: { value in
                            
                            if value{
//                                var updatedBeginHue = beginHue
//                                updatedBeginHue.filter = hue.filter
                                if let hueFilter = stickerFilter as? HueFilter {
                                    beginHue = HueFilter(filter: hueFilter.filter)
                                }
                            }else{
//                                var updatedEndHue = endHue
//                                updatedEndHue.filter = hue.filter
//                                endHueBinding = hueBinding
                                if let hueFilter = stickerFilter as? HueFilter {
                                    endHue = HueFilter(filter: hueFilter.filter)
                                }
                                updateThumb = true
                            }
                        }
                    )
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
                    
                Text("\(String(format: "%.0f", (hueBinding.wrappedValue / 360) * 100))%")
                    .font(.subheadline)
//                }
            }.frame(width: 350, height: 120)
        }.frame(height: 180)
            .onAppear{
                if let initialColorFilter = stickerFilter {
                    beginHue = initialColorFilter
                }
            }
    }
    
    func bindingForHueValue(bg: Binding<AnyColorFilter?>) -> Binding<Float> {
        return Binding<Float>(
            get: {
                if let hueModel = bg.wrappedValue as? HueFilter {
                    return hueModel.filter
                } else {
                    return 0.0
                }
            },
            set: { newValue in
                if var hueModel = bg.wrappedValue as? HueFilter {
                    hueModel.filter = newValue
                    bg.wrappedValue = hueModel
                } else {
                    bg.wrappedValue = HueFilter(filter: newValue)
                }
            }
        )
    }
    
    func bindingForNoneValue(bg: Binding<AnyColorFilter?>) -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                if let noneModel = bg.wrappedValue as? NoneFilter {
                    return noneModel.filter
                } else {
                    return false
                }
            },
            set: { newValue in
                if var noneModel = bg.wrappedValue as? NoneFilter {
                    noneModel.filter = newValue
                    bg.wrappedValue = noneModel
                } else {
                    bg.wrappedValue = NoneFilter(filter: newValue)
                }
            }
        )
    }
}

//#Preview {
//    HuePanel()
//}
