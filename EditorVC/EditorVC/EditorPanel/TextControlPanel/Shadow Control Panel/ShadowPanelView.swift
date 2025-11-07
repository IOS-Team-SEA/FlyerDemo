//
//  ShadowPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 29/03/24.
//

import SwiftUI
import IOS_CommonEditor
//import SwiftUIIntrospect

struct ShadowPanelView: View {
    let shadowTypes: [ShadowType] = [.direction, .opacity, .color]
    @State private var selectedShadowType: ShadowType = .direction
    @Binding var dx: Float
    @Binding var dy: Float
    @Binding var beginDx: Float
    @Binding var beginDy: Float
    @Binding var endDx: Float
    @Binding var endDy: Float
    
    @Binding var shadowOpacity: Float
    @Binding var beginShadowOpacity: Float
    @Binding var endShadowOpacity: Float
    
//    @Binding var bgColor: UIColor
    @State var colorArray: [UIColor] = ColorDataSource.colorsArray
    @State var selectedColor: Color = .black
    @Binding var startColor: AnyColorFilter?
    @Binding var endColor: AnyColorFilter?
    @Binding var lastShadowSelectedButton: ShadowType
    
//    @Binding var templateColorArray: [UIColor]
    var templateID: Int
    @Binding var colorFilter: AnyColorFilter?
    @Binding var updateThumb:Bool 
    @Binding var lastSelectedColor: AnyColorFilter?
    @Binding var thumbImage: UIImage?
    
    var body: some View {
        VStack(spacing: -10){
            ZStack{
                HStack {
                    ForEach(shadowTypes, id: \.self) { shadowType in
                        Button(action: {
                            selectedShadowType = shadowType
                            lastShadowSelectedButton = shadowType
                            
                        }) {
                            // Button label based on shadow type
                            Text(shadowTypeLabel(for: shadowType))
                                .font(.subheadline)
                                .foregroundColor(lastShadowSelectedButton == shadowType ? AppStyle.accentColor_SwiftUI : .gray)
                                .frame(width: 80, height: 30)
                            //                            .padding()
                        }
                        .frame(width: 80, height: 30)
                        .buttonStyle(ShadowBorderButtonStyle(borderColor: lastShadowSelectedButton == shadowType ? AppStyle.accentColor_SwiftUI : .gray, borderWidth: 1))
                    }
                }.frame(height: 40)
            }
            
            VStack{
                switch selectedShadowType {
                case .direction:
                    VStack{
                        HStack{
                            Text("X-axis")
                                .font(.subheadline)
//                                .frame(width: 80)
                            Slider(
                                value: $dx,
                                in: -10...10,
                                onEditingChanged: { value in
                                    //                      dbOpacity = opacity
                                    //                      currentModel.modelOpacity = opacity
                                    
                                    //                      print("DB Opacity \(opacity)")
                                    if value{
                                        
                                        beginDx = dx
        //                                isOpacityEnded = editing
                                    }else{
                                        
                                        endDx = dx
                                    }
                                }
                            )
//                            .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                                slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                            }
                            .tint(AppStyle.accentColor_SwiftUI)
                            Text("\(String(format: "%.0f", ((dx + 10) / 20) * 100))%")
                                .font(.subheadline)
        //                        .padding()
                        }.frame(width: 350, height: 40)
                        
                        HStack{
                            Text("Y-axis")
                                .font(.subheadline)
//                                .frame(width: 80)
                            Slider(
                                value: $dy,
                                in: -10...10,
                                onEditingChanged: { value in
                                    if value{
                                        
                                        beginDy = dy
        //                                isOpacityEnded = editing
                                    }else{
                                        
                                        endDy = dy
                                    }
                                }
                            )
//                            .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                                slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                            }
                            .tint(AppStyle.accentColor_SwiftUI)
                            Text("\(String(format: "%.0f", ((dy + 10) / 20) * 100))%")
                                .font(.subheadline)
        //                        .padding()
                        }.frame(width: 350, height: 40)
                    }
                    .padding(.top, 30)
                    .frame(height: 80)

                case .opacity:
                    VStack{
                        HStack{
                            Text("Opacity_")
//                                .frame(width: 80)
                                .font(.subheadline)
                            Slider(
                                value: $shadowOpacity,
                                in: 0...25,
                                onEditingChanged: { value in
                                    if value{
                                        
                                        beginShadowOpacity = shadowOpacity
        //                                isOpacityEnded = editing
                                    }else{
                                        
                                        endShadowOpacity = shadowOpacity
                                    }
                                }
                            )
//                            .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                                slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                            }
                            .tint(AppStyle.accentColor_SwiftUI)
                            Text("\(String(format: "%.0f", (shadowOpacity / 25) * 100))%")
                                .font(.subheadline)
        //                        .padding()
                        }.frame(width: 350, height: 80)
                    }
                    .frame(height: 80)
                    .padding(.top, 30)
                case .color:
                    VStack{
                        ColorPanel(templateID: templateID, startColor: $startColor, endColor: $endColor, colorFilter: $colorFilter, updateThumb: $updateThumb,lastSelectedColor: $lastSelectedColor, thumbImage: $thumbImage, showResetText: .constant(false))
                    }.frame(height: 80)
                }
            }.frame(height: 80)
//                .padding()
        }
        .frame(height: 125)
        .onAppear(){
            selectedShadowType = lastShadowSelectedButton
        }
    }
    
    func shadowTypeLabel(for shadowType: ShadowType) -> String {
            switch shadowType {
            case .direction:
                return "Direction_".translate()
            case .opacity:
                return "Opacity_".translate()
            case .color:
                return "Color_".translate()
            }
        }
}

//#Preview {
//    var colorBinding = Binding<AnyColorFilter?>(get: {
//        return ColorFilter(filter: .black)
//    }, set: { _ in })
//    
//    return ShadowPanelView(dx: .constant(1), dy: .constant(1), beginDx: .constant(1), beginDy: .constant(1), endDx: .constant(1), endDy: .constant(1), shadowOpacity: .constant(1), beginShadowOpacity: .constant(1), endShadowOpacity: .constant(1), startColor: colorBinding, endColor: colorBinding, lastShadowSelectedButton: .constant(.direction), templateColorArray: .constant([.blue, .yellow]), colorFilter: colorBinding)
//}

struct ShadowBorderButtonStyle: ButtonStyle {
    let borderColor: Color
    let borderWidth: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(width: 80, height: 30)
            )
    }
}
