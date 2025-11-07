//
//  GradientPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/04/24.
//

import SwiftUI
import IOS_CommonEditor
//import SwiftUIIntrospect

struct GradientPanelView: View {
    
    @State private var isColorPicker1Active = false
    @State private var isColorPicker2Active = false
    @Binding var beginBgContent: AnyBGContent?
    @Binding var endBgContent: AnyBGContent?
    @State var selectedGradientType: String = "Linear"
    @Binding var gradient: AnyBGContent?
//    @Binding var endGradient: AnyBGContent?
    @State var isDropperViewPresented = false
    @State var isDropperViewPresented2 = false
    @Binding var thumbImage: UIImage?
    @Binding var updateThumb : Bool
    
    var body: some View {
        let gradientBinding = bindingForGradientValue(bg: $gradient)
        let beginGradientBinding = bindingForGradientValue(bg: $beginBgContent)
        let endGradientBinding = bindingForGradientValue(bg: $endBgContent)
    
        VStack(spacing: 0) {
//            Spacer()
            
//            HStack(spacing: 20){
//                Button(action: {
//                    gradientBinding.wrappedValue.GradientType
//                    = 0
//                    endGradientBinding.wrappedValue = gradientBinding.wrappedValue
//                    beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
//                    selectedGradientType = "Linear"
//                }) {
//                    // Button label based on shadow type
//                    Text("Linear")
//                        .foregroundColor(selectedGradientType == "Linear" ? AppStyle.accentColor_SwiftUI : .gray)
//                        .frame(width: 80, height: 30)
//                        .padding()
//                }
//                .frame(width: 80, height: 30)
//                .buttonStyle(ShadowBorderButtonStyle(borderColor: selectedGradientType == "Linear" ? AppStyle.accentColor_SwiftUI : .gray, borderWidth: 1))
//                Button(action: {
//                    gradientBinding.wrappedValue.GradientType = 1
//                    endGradientBinding.wrappedValue = gradientBinding.wrappedValue
//                    beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
//                    selectedGradientType = "Radial"
//                }) {
//                    // Button label based on shadow type
//                    Text("Radial")
//                        .foregroundColor(selectedGradientType == "Radial" ? AppStyle.accentColor_SwiftUI : .gray)
//                        .frame(width: 80, height: 30)
//                        .padding()
//                }
//                .frame(width: 80, height: 30)
//                .buttonStyle(ShadowBorderButtonStyle(borderColor: selectedGradientType == "Radial" ? AppStyle.accentColor_SwiftUI : .gray, borderWidth: 1))
//                
//            }.frame(height: 30)
            
            Picker(selection: gradientBinding.GradientType, label: Text("")) {
                Text("Linear_").tag(0)
                Text("Radial_").tag(1)
            }
            .onChange(of: gradientBinding.GradientType.wrappedValue) { newValue in
                // Reset newGradientInfo based on the selected gradient type
                if newValue != endGradientBinding.wrappedValue.GradientType{
                    switch newValue {
                    case 0:
                        
                        endGradientBinding.wrappedValue = gradientBinding.wrappedValue
                        beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
                        updateThumb = true
                    case 1:
                       
                        endGradientBinding.wrappedValue = gradientBinding.wrappedValue
                        beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
                        updateThumb = true
                    default:
                        print("No Type selected")
                    }
                }
            }
            .frame(width: 200, height: 40)
            .pickerStyle(SegmentedPickerStyle())
            
            VStack(spacing: 0){
                HStack{
                    VStack{
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 40, height: 40)
                        //                        .cornerRadius(3)
                            .foregroundColor(Color(uiColor: gradientBinding.wrappedValue.StartColor.convertIOSColorIntToUIColor()))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.label, lineWidth: 1) // Border color and width
                                    .frame(width: 45, height: 45)
                            )
                            .onTapGesture {
                                isColorPicker1Active = true
                            }
                        
                        Text(gradientBinding.wrappedValue.StartColor.convertIOSColorIntToUIColor().toHex()!)
                            .font(.caption)
                        
                    }
                    .frame(width: 120 ,height: 90)
                    .fullScreenCover(isPresented: $isColorPicker1Active){
                        CustomColorPicker(selectedColor: bindingForGradientColor(gradientBinding, isStartColor: true), isPresented: $isColorPicker1Active, endColor: bindingForGradientColor(endGradientBinding, isStartColor: true), isDropperViewPresented: $isDropperViewPresented, updatethumb: $updateThumb)
                            .onChange(of: gradientBinding.wrappedValue.StartColor) { newValue in
//                                endGradientBinding.wrappedValue = gradientBinding.wrappedValue
                                beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
                            }
                        
                    }
                    .sheet(isPresented: $isDropperViewPresented){
                        CustomColorDropperView(image: $thumbImage, currentColor: bindingForGradientColor(endGradientBinding, isStartColor: true)) { color in
                            bindingForGradientColor(endGradientBinding, isStartColor: true).wrappedValue = color
                            bindingForGradientColor(gradientBinding, isStartColor: true).wrappedValue = color
                            updateThumb = true
                            isDropperViewPresented = false
                        }
                    }
                    
                    .padding(.leading, UIDevice.current.userInterfaceIdiom == .pad ? 250 : 80)
                    
                    Spacer()
                    
//                    VStack{
//                        switch gradientBinding.wrappedValue.GradientType {
//                            
//                        case 0:
//                            Rectangle()
//                                .fill(LinearGradient(gradient: Gradient(colors: [Color(uiColor: gradientBinding.wrappedValue.StartColor.convertIOSColorIntToUIColor()) , Color(uiColor: gradientBinding.wrappedValue.EndColor.convertIOSColorIntToUIColor())]), startPoint: UnitPoint(x: 0.5 - cos(CGFloat(gradientBinding.wrappedValue.AngleInDegrees) * 6.23), y: 0.5 - sin(CGFloat(gradientBinding.wrappedValue.AngleInDegrees) * 6.23)), endPoint: UnitPoint(x: 0.5 + cos(CGFloat(gradientBinding.wrappedValue.AngleInDegrees) * 6.23), y: 0.5 + sin(CGFloat(gradientBinding.wrappedValue.AngleInDegrees) * 6.23))))
//                                .frame(width: 50, height: 50)
//                                .cornerRadius(8)
//                            
//                        case 1:
//                            Rectangle()
//                                .fill(RadialGradient(gradient: Gradient(colors: [Color(uiColor: gradientBinding.wrappedValue.StartColor.convertIOSColorIntToUIColor()) , Color(uiColor: gradientBinding.wrappedValue.EndColor.convertIOSColorIntToUIColor())]), center: .center, startRadius: 0, endRadius: CGFloat(gradientBinding.wrappedValue.Radius) * 50))
//                                .frame(width: 50, height: 50)
//                                .cornerRadius(8)
//                            
//                        default:
//                            Text("hey")
//                        }
//                        
//                        
//                    }
                    
                    // Swappable Color Pickers
                    HStack {

                        Button(action: {
                            withAnimation {
                                beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
        //                        swapColors()
                                let tempColor = gradientBinding.wrappedValue.StartColor
                                gradientBinding.wrappedValue.StartColor = gradientBinding.wrappedValue.EndColor
                                gradientBinding.wrappedValue.EndColor = tempColor
                                
                                endGradientBinding.wrappedValue = gradientBinding.wrappedValue
                                updateThumb = true
                            }
                        }) {
                            SwiftUI.Image("swap")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(AppStyle.accentColor_SwiftUI)
                                .frame(width: 30, height: 30)
                                
                        }
                        .frame(width: 30, height: 30)
                        .padding(.horizontal, 20)

                    }.frame(width: 90, height: 90)
                    
                    Spacer()
                    VStack{
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .fill()
                            .frame(width: 40, height: 40)
                        //                        .cornerRadius(3)
                            .foregroundColor(Color(uiColor: gradientBinding.wrappedValue.EndColor.convertIOSColorIntToUIColor()))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.label, lineWidth: 1) // Border color and width
                                    .frame(width: 45, height: 45)
                            )
                            .onTapGesture {
                                isColorPicker2Active = true
                            }
                        
                        Text(gradientBinding.wrappedValue.EndColor.convertIOSColorIntToUIColor().toHex()!)
                            .font(.caption)
                    }
                    .frame(width: 120 ,height: 90)
                    .fullScreenCover(isPresented: $isColorPicker2Active){
                        CustomColorPicker(selectedColor: bindingForGradientColor(gradientBinding, isStartColor: false), isPresented: $isColorPicker2Active, endColor: bindingForGradientColor(endGradientBinding, isStartColor: false), isDropperViewPresented: $isDropperViewPresented, updatethumb: $updateThumb)
                            .onChange(of: gradientBinding.wrappedValue.EndColor) { newValue in
//                                endGradientBinding.wrappedValue = gradientBinding.wrappedValue
                                beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
                            }
                        
                    }
                    .sheet(isPresented: $isDropperViewPresented2){
                        CustomColorDropperView(image: $thumbImage, currentColor: bindingForGradientColor(endGradientBinding, isStartColor: false)) { color in
                            bindingForGradientColor(endGradientBinding, isStartColor: false).wrappedValue = color
                            bindingForGradientColor(gradientBinding, isStartColor: false).wrappedValue = color
                            updateThumb = true
                            isDropperViewPresented2 = false
                        }
                    }
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? 250 : 80)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 90)
                
                
               
            }
            .frame(height: 90)

            HStack {
                
//                Text("End Radius:")
                if gradientBinding.wrappedValue.GradientType == 0{
                    Slider(value: gradientBinding.AngleInDegrees, in: 0...1, onEditingChanged: { value in
                        if value{
                            //                        gradientInfo.endRadius = endRadius
                            beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
                        }else{
                            
                            endGradientBinding.wrappedValue = gradientBinding.wrappedValue
                            updateThumb = true
                        }
                    })
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
                }else{
                    Slider(value: gradientBinding.Radius, in: 0...1, onEditingChanged: { value in
                        if value{
                            //                        gradientInfo.endRadius = endRadius
                            beginGradientBinding.wrappedValue = gradientBinding.wrappedValue
                        }else{
                            
                            endGradientBinding.wrappedValue = gradientBinding.wrappedValue
                            updateThumb = true
                        }
                    })
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
                }
                
            }.frame(width: 350, height: 30)
        }.frame(height: 180)
    }
    

    func bindingForGradientValue(bg: Binding<AnyBGContent?>) -> Binding<GradientInfo> {
        return Binding<GradientInfo>(
            get: {
                if let bgModel = bg.wrappedValue as? GradientInfo {
                    return bgModel
                } else {
                    if let bgModel = bg.wrappedValue as? GradientInfo {
                        return GradientInfo(GradientType: 0, StartColor: bgModel.StartColor, EndColor: bgModel.EndColor, Radius: 0.5, AngleInDegrees: 0)
                    }
                    return GradientInfo(GradientType: 0, StartColor: UIColor.black.toInt(), EndColor: UIColor.white.toInt(), Radius: 0.5, AngleInDegrees: 0)
                }
            },
            set: { newValue in
                if var bgModel = bg.wrappedValue as? GradientInfo {
                    bgModel = newValue
                    bg.wrappedValue = bgModel
                } else {
                    bg.wrappedValue = GradientInfo(GradientType: newValue.GradientType, StartColor: newValue.StartColor, EndColor: newValue.EndColor, Radius: newValue.Radius, AngleInDegrees: newValue.AngleInDegrees)
                }
            }
        )
    }
    
    func bindingForGradientColor(_ gradientBinding: Binding<GradientInfo>, isStartColor: Bool) -> Binding<UIColor> {
        return Binding<UIColor>(
            get: {
                if isStartColor {
                    return gradientBinding.wrappedValue.StartColor.convertIOSColorIntToUIColor()
                } else {
                    return gradientBinding.wrappedValue.EndColor.convertIOSColorIntToUIColor()
                }
            },
            set: { newValue in
                if isStartColor {
                    gradientBinding.wrappedValue.StartColor = newValue.toInt()
                } else {
                    gradientBinding.wrappedValue.EndColor = newValue.toInt()
                }
            }
        )
    }
    
}

//#Preview {
//    var gradientBinding = Binding<AnyBGContent?>(get: {
//        return GradientInfo(GradientType: 0, StartColor: UIColor.black.toInt(), EndColor: UIColor.white.toInt(), Radius: 1, AngleInDegrees: 1)
//    }, set: { _ in })
//    
//    var beginGradientBinding = Binding<AnyBGContent?>(get: {
//        return GradientInfo(GradientType: 0, StartColor: UIColor.black.toInt(), EndColor: UIColor.black.toInt(), Radius: 1, AngleInDegrees: 1)
//    }, set: { _ in })
//    
//    var endGradientBinding = Binding<AnyBGContent?>(get: {
//        return GradientInfo(GradientType: 0, StartColor: UIColor.black.toInt(), EndColor: UIColor.black.toInt(), Radius: 1, AngleInDegrees: 1)
//    }, set: { _ in })
//    
//    GradientPanelView(oldGradientInfo: beginGradientBinding, newGradientInfo: endGradientBinding, gradient: gradientBinding, endGradient: endGradientBinding)
//}

struct ColorPickerView1: View {
    @Binding var color: Color
    
//    private var colorBinding: Binding<Color> {
//        Binding<Color>(
//            get: {
//                Color(self.color)
//            },
//            set: { newColor in
//                self.color = UIColor(newColor)
//            }
//        )
//    }
//    @State var selectedColor: Color
    
    var body: some View {
        
        ColorPicker("", selection: $color, supportsOpacity: false)
            .onChange(of: color) { newValue in
                    
            }
//            .onChange(of: color) { newValue in
//                print("new Color")
//            }
            .frame(width: 50, height: 50)
            .cornerRadius(25)
//            .onChange(of: selectedColor) { newValue in
//                color = UIColor(newValue)
//            }

    }
}

struct ColorPickerView2: View {
    @Binding var color: UIColor
    
    private var colorBinding: Binding<Color> {
        Binding<Color>(
            get: {
                Color(self.color)
            },
            set: { newColor in
                self.color = UIColor(newColor)
            }
        )
    }
//    @State var selectedColor: Color
    
    var body: some View {
        
        
        ColorPicker("", selection: colorBinding, supportsOpacity: false)
            .frame(width: 50, height: 50)
            .cornerRadius(25)
//            .onChange(of: selectedColor) { newValue in
//                color = UIColor(newValue)
//            }

    }
}
