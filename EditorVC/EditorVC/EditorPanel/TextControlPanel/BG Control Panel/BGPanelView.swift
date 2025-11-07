//
//  BGPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 29/03/24.
//

import SwiftUI
import IOS_CommonEditor
//import SwiftUIIntrospect

struct BGPanelView: View {
    let bgTypes: [BGPanelType] = [.color, .opacity]
//    @Binding var bgColor: UIColor
    @State var colorArray: [UIColor] = ColorDataSource.colorsArray
    @State var selectedColor: Color = .blue
    @Binding var bgAplha : Float
    @Binding var endbgAlpha: Float
    @Binding var beginBgAlpha: Float
    @State var showPanel: Bool = false
    @Binding var startColor: AnyBGContent?
    @Binding var endColor: AnyBGContent?
    @Binding var colorFilter: AnyBGContent?
//    @Binding var templateColorArray: [UIColor]
    var templateID: Int
    @Binding var updatePageAndParentThumb : Bool
//    @State private var selectedSegment: Int = 0
    @State var selectedbgType: BGPanelType = .color
    @Binding var lastSelectedBGButton: BGPanelType
    @Binding var lastSelectedBGColor: AnyBGContent?
    @Binding var thumbImage: UIImage?
    @Binding var textBGType : Int
    
    var body: some View {
  
        VStack(spacing: -10){

            ZStack{
                HStack{
                    ForEach(bgTypes, id: \.self){ bgType in
                        Button(action: {
                            selectedbgType = bgType
                            lastSelectedBGButton = bgType
                        }) {
                            // Button label based on shadow type
                            Text(backgroundTypeLabel(for: bgType))
                                .font(.subheadline)
                                .foregroundColor(lastSelectedBGButton == bgType ? AppStyle.accentColor_SwiftUI : .gray)
                                .frame(width: 80, height: 30)
                                .padding()
                        }
                        .frame(width: 80, height: 30)
                        .buttonStyle(ShadowBorderButtonStyle(borderColor: lastSelectedBGButton == bgType ? AppStyle.accentColor_SwiftUI : .gray, borderWidth: 1))
                    }
                }.frame(height: 30)
            }
            
//            Spacer()
            VStack{
                switch selectedbgType {
                case .color:
                    VStack{
                        TextColorPanel(templateID: templateID, startColor: $startColor, endColor: $endColor, colorFilter: $colorFilter, showReset: true, updateThumb: $updatePageAndParentThumb,lastSelectedBGColor: $lastSelectedBGColor, thumbImage: $thumbImage, textBGType: $textBGType)
                    }.frame(height: 95)
                case .opacity:
                    VStack{
                        HStack{
                            Text("Opacity_")
                                .font(.subheadline)
                            Slider(
                                value: $bgAplha,
                                in: 0...1,
                                onEditingChanged: { value in
                                    if value{
                                        beginBgAlpha = bgAplha
                                    }else{
                                        endbgAlpha = bgAplha
                                    }
                                }
                            )
//                            .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                                slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                            }
                            .tint(AppStyle.accentColor_SwiftUI)
                            Text("\(String(format: "%.0f", bgAplha*100))%")
                                .font(.subheadline)
                        }
                        .frame(width: 350, height: 50)
                    }.frame(height: 95)
                }
                
            }.frame(height: 95)
            

        }
        .frame(height: 125)
        .onAppear(){
            selectedbgType = lastSelectedBGButton
        }
    }
    
    func backgroundTypeLabel(for bgType: BGPanelType) -> String {
            switch bgType {
            case .color:
                return "Color_".translate()
            case .opacity:
                return "Opacity_".translate()
           
            }
        }
}

struct CircleView: View {
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 30, height: 30)
        }
    }
}

//#Preview {
//    var colorBinding = Binding<AnyBGContent?>(get: {
//        return BGColor(bgColor: .black)
//    }, set: { _ in })
//    
//    return BGPanelView(bgAplha: .constant(1), endbgAlpha: .constant(1), beginBgAlpha: .constant(1), startColor: colorBinding, endColor: colorBinding, colorFilter: colorBinding, templateColorArray: .constant([.blue, .yellow]), lastSelectedBGButton: .constant(.color))
//    
//    
//}

