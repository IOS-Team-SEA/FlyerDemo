//
//  TextColorPanel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 28/05/24.
//

import SwiftUI
import IOS_CommonEditor

struct TextColorPanel: View {
    
    @State var selectedColor: UIColor = .clear
    @State var shadesArray: [UIColor] = []
    @State var showShades = false
    @State var colors: [UIColor] = ColorDataSource.colorsArray
    @State var templateColorArray: [UIColor] = []
    var templateID: Int
//    @Binding var stickerColor: UIColor
    @Binding var startColor: AnyBGContent?
    @Binding var endColor: AnyBGContent?
    @State var isColorPickerSelected = false
    @Binding var colorFilter: AnyBGContent?
    var showReset: Bool
    @State var showPopover: Bool = false
    @State private var selectedColorFrame: CGRect = .zero
    @Binding var updateThumb : Bool 
    @Binding var lastSelectedBGColor: AnyBGContent?
    @State var isDropperViewPresented = false
    @Binding var thumbImage: UIImage?
    @Binding var textBGType : Int
    
    var body: some View {
        let colorBinding = bindingForColorValue(bg: $colorFilter)
        let startColorBinding = bindingForColorValue(bg: $startColor)
        let endColorBinding = bindingForColorValue(bg: $endColor)
        let lastSelectedBGColor = bindingForColorValue(bg: $lastSelectedBGColor)
//        ScrollView(.vertical){
            VStack{
                // HStack for reset and picker
                HStack{
                    if showReset{
                        Button{
                            textBGType = 0
                            endColorBinding.wrappedValue = .clear
                            startColorBinding.wrappedValue = .clear
                            colorBinding.wrappedValue = .clear
                            lastSelectedBGColor.wrappedValue = .clear
                        } label: {
                            SwiftUI.Image("reset")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(AppStyle.accentColor_SwiftUI)
                                .frame(width: 20, height: 20)
                        }
                        .padding(.leading, 20)
                    }
                    Spacer()
                    
                    VStack{
                        Button {
                            isColorPickerSelected = true
                        } label: {
                            SwiftUI.Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(AppStyle.accentColor_SwiftUI)
                        }
                        .frame(width: 22, height: 22)
                        .cornerRadius(5)
                        .fullScreenCover(isPresented: $isColorPickerSelected) {
                            CustomColorPicker(selectedColor: colorBinding, isPresented: $isColorPickerSelected, endColor: endColorBinding, isDropperViewPresented: $isDropperViewPresented, updatethumb: $updateThumb).environment(\.sizeCategory, .medium)
                            
                        }
                        .sheet(isPresented: $isDropperViewPresented){
                            CustomColorDropperView(image: $thumbImage, currentColor: endColorBinding) { color in
                                endColorBinding.wrappedValue = color
                                colorBinding.wrappedValue = color
                                isDropperViewPresented = false
                            }
                        }
                    }.padding(.trailing, 20)
                    
                }.frame(maxWidth: .infinity, idealHeight: 25)
                
                ScrollView(.horizontal, showsIndicators: false){
                    ScrollViewReader{ proxy in
                        HStack(spacing: 10){
                            if templateColorArray.isEmpty{
                                ColorPanelView(templateColorArray: $templateColorArray, colors: $colors, shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, startColor: startColorBinding, endColor: endColorBinding, colorFilter: colorBinding, showColorPicker: false, colorType: "All_Colors".translate(), showPopover: $showPopover, selectedColorFrame: $selectedColorFrame, coordinateSpace: .named("colorPanel"), updateThumb: $updateThumb)
                            }else{
                                ColorPanelView(templateColorArray: $templateColorArray, colors: $colors, shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, startColor: startColorBinding, endColor: endColorBinding, colorFilter: colorBinding, showColorPicker: false, colorType: "Template Colors", showPopover: $showPopover, selectedColorFrame: $selectedColorFrame, coordinateSpace: .named("colorPanel"), updateThumb: $updateThumb)
                                    
                                
                                Divider()
                                ColorPanelView(templateColorArray: $templateColorArray, colors: $colors, shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, startColor: startColorBinding, endColor: endColorBinding, colorFilter: colorBinding, showColorPicker: false, colorType: "All_Colors".translate(), showPopover: $showPopover, selectedColorFrame: $selectedColorFrame, coordinateSpace: .named("colorPanel"), updateThumb: $updateThumb)
                            }
                        }
                        .alwaysPopover(isPresented: $showPopover, frame: $selectedColorFrame) {
                            if showShades{
                                ColorShadesView(selectedColor: $selectedColor, shadesArray: $shadesArray, showShades: $showShades, colorFilter: colorBinding, showPopover: $showPopover, startColor: startColorBinding, endColor: endColorBinding)
                                    .frame(width: 300)
                            }
                        }
                        .coordinateSpace(name: "colorPanel")
                        .onAppear(){
                            scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: lastSelectedBGColor.wrappedValue)
                        }
                    }
                    .coordinateSpace(name: "colorPanel")
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
            .frame(height: 125)
            .onChange(of: endColorBinding.wrappedValue) { newValue in
                templateColorArray = DataSourceRepository.shared.getTemplateColorArray(templateID: templateID)
                lastSelectedBGColor.wrappedValue = newValue
                if showReset{
                    textBGType = 2
                }
            }
            .onAppear(){
                templateColorArray = DataSourceRepository.shared.getTemplateColorArray(templateID: templateID)
//                colorBinding.wrappedValue = lastSelectedBGColor.wrappedValue
            }
        
//        }
    }
    
    func bindingForColorValue(bg: Binding<AnyBGContent?>) -> Binding<UIColor> {
        return Binding<UIColor>(
            get: {
                if let colorModel = bg.wrappedValue as? BGColor {
                    return colorModel.bgColor
                } 
//                else {
//                    return colorrMode
//                }
                return .clear
            },
            set: { newValue in
                if var colorModel = bg.wrappedValue as? BGColor {
                    colorModel.bgColor = newValue
                    bg.wrappedValue = colorModel
                } else {
                    bg.wrappedValue = BGColor(bgColor: newValue)
                }
            }
        )
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: UIColor) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        }
            
    }
}

//#Preview {
//    var colorBinding = Binding<AnyBGContent?>(get: {
//        return BGColor(bgColor: "-1")
//    }, set: { _ in })
//    
//    return TextColorPanel(templateColorArray: .constant([.bluebg, .greenbg, .pinkbg, .purple, .systemPink]), startColor: colorBinding, endColor: colorBinding, colorFilter: colorBinding, showReset: false)
//}


//struct TextColorShadesView: View {
//    @Binding var selectedColor: Color
//    @Binding var shadesArray: [UIColor]
////    @Binding var stickerColor: UIColor
//    @Binding var showShades: Bool
//    @Binding var colorFilter: UIColor
//    @Binding var showPopover: Bool
//    
//    var body: some View {
//        //        ScrollView(.horizontal, showsIndicators: false) {
//        HStack(spacing: 16) {
//            ForEach(shadesArray, id: \.self) { color in
//                //                            ZStack {
//                //                                    Circle()
//                //                                        .fill(Color(uiColor: color))
//                //                                        .frame(width: 20, height: 20)
//                //                                        .onTapGesture {
//                //                                            selectedColor = Color(uiColor: color)
//                ////                                            stickerColor = color
//                //                                            colorFilter = color
//                //                                            showShades = false
//                ////                                            print("sticker color: \(stickerColor)")
//                //                                        }
//                //
//                //                                    Circle()
//                //                                    .stroke(Color.label, lineWidth: 1) // Border color and width
//                //                                        .frame(width: 22, height: 22) // Larger frame to accommodate the border
//                //                                }
//                VStack{
//                    RoundedRectangle(cornerRadius: 5)
//                        .fill(Color(uiColor: color))
//                        .frame(width: 20, height: 20)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(selectedColor == Color(uiColor: color) ? AppStyle.accentColor_SwiftUI : .label, lineWidth: 1) // Highlight when selected
//                        )
//                        .onTapGesture {
//                            selectedColor = Color(uiColor: color)
//                            
//                            colorFilter = color
//                            showShades = false
//                            showPopover = false
//                        }
//                    
//                }
//            }
//        }
//        .frame(height: 30)
//        .padding()
//        .onDisappear(){
//            showShades = false
//        }
//        //                }
//    }
//    
//}

//struct TextColorPanelView: View {
//    
//    @Binding var templateColorArray: [UIColor]
//    @Binding var colors: [UIColor]
//    @Binding var shadesArray: [UIColor]
//    @Binding var showShades: Bool
////    @Binding var stickerColor: UIColor
//    @Binding var selectedColor: Color
//    @Binding var startColor: UIColor
//    @Binding var endColor: UIColor
//    @Binding var colorFilter: UIColor
//    var showColorPicker: Bool
//    var colorType: String
//    @Binding var showPopover: Bool
//    @Binding var selectedColorFrame: CGRect
//    var coordinateSpace: CoordinateSpace
//    
//    var body: some View {
////        ScrollView(.horizontal, showsIndicators: false) {
//            
//        VStack{
//            HStack{
//                
//                Text(colorType)
//                    .foregroundColor(.black)
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                    .frame(height: 20)
//                
//                Spacer()
//            }
//            .padding(.leading, 10)
//            
//            HStack(spacing: 16) {
//                
//                if colorType == "Template Colors"{
//                    ForEach($templateColorArray, id: \.self) { color in
//                        
//                        TextColorPanelViewCellTemplate(shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, color: color, colorFilter: $colorFilter, selectedColorFrame: $selectedColorFrame, coordinateSpace: coordinateSpace)
//                    }
//                }else{
//                    
//                    
//                    ForEach($colors, id: \.self) { color in
//                        TextColorPanelViewCellTemplate(shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, color: color, colorFilter: $colorFilter, selectedColorFrame: $selectedColorFrame, coordinateSpace: coordinateSpace)
//   
//                    }
//                }
//                Spacer()
//            }
//            .frame(height: 40)
//            .padding(.horizontal, 5)
//            
//        }
//        
//    }
//    
//    func Shades(color: UIColor, numShades: Int) -> [UIColor] {
//        // Extract RGB components from the color
//        guard let components = color.cgColor.components else {
//            return []
//        }
//        
//        let red = components[0]
//        let green = components[1]
//        let blue = components[2]
//        let alpha = components[3]
//
//        var shades = [UIColor]()
//
//        // Calculate the step size for each shade
//        let step: CGFloat = 1 / CGFloat(numShades + 1) // Adding 1 to numShades for excluding pure black and white
//
//        // Generate light shades
//        for i in stride(from: numShades, through: 1, by: -1) {
//            let newRed = min(red + (step * CGFloat(i)), 1.0)
//            let newGreen = min(green + (step * CGFloat(i)), 1.0)
//            let newBlue = min(blue + (step * CGFloat(i)), 1.0)
//            let shadeColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
//            shades.append(shadeColor)
//        }
//        
//        // Add the original color
//        shades.append(color)
//
//        // Generate dark shades
//        for i in 1...numShades {
//            let newRed = max(red - (step * CGFloat(i)), 0)
//            let newGreen = max(green - (step * CGFloat(i)), 0)
//            let newBlue = max(blue - (step * CGFloat(i)), 0)
//            let shadeColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
//            shades.append(shadeColor)
//        }
//
//        return shades
//    }
//}



struct TextColorPanelViewCell: View {
    
    @Binding var shadesArray: [UIColor]
    @Binding var showShades: Bool
//    @Binding var stickerColor: UIColor
    @Binding var selectedColor: Color
    @Binding var color: Color
    @State var showPopover: Bool = false
    @Binding var colorFilter: UIColor
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedColor == color ? AppStyle.accentColor_SwiftUI : .label, lineWidth: 1) // Highlight when selected
                )
                .onTapGesture {
                    selectedColor = color
                    showShades = true
//                    showPopover = true
                    if showShades{
                        showPopover = true
                    }else{
                        showPopover = false
                    }
                    shadesArray = Shades(color: UIColor(color), numShades: 3)
                }
                
        }
//        .alwaysPopover(isPresented: $showPopover) {
//            TextColorShadesView(selectedColor: $selectedColor, shadesArray: $shadesArray, showShades: $showShades, colorFilter: $colorFilter)
//                .frame(width: 300)
//        }
        
    }
    
    func Shades(color: UIColor, numShades: Int) -> [UIColor] {
        // Extract RGB components from the color
        guard let components = color.cgColor.components else {
            return []
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]

        var shades = [UIColor]()

        // Calculate the step size for each shade
        let step: CGFloat = 1 / CGFloat(numShades + 1) // Adding 1 to numShades for excluding pure black and white

        // Generate light shades
        for i in stride(from: numShades, through: 1, by: -1) {
            let newRed = min(red + (step * CGFloat(i)), 1.0)
            let newGreen = min(green + (step * CGFloat(i)), 1.0)
            let newBlue = min(blue + (step * CGFloat(i)), 1.0)
            let shadeColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
            shades.append(shadeColor)
        }
        
        // Add the original color
        shades.append(color)

        // Generate dark shades
        for i in 1...numShades {
            let newRed = max(red - (step * CGFloat(i)), 0)
            let newGreen = max(green - (step * CGFloat(i)), 0)
            let newBlue = max(blue - (step * CGFloat(i)), 0)
            let shadeColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
            shades.append(shadeColor)
        }

        return shades
    }
}

//struct TextColorPanelViewCellTemplate: View {
//    
//    @Binding var shadesArray: [UIColor]
//    @Binding var showShades: Bool
//    @Binding var selectedColor: Color
//    @Binding var color: UIColor
//    @State var showPopover: Bool = false
//    @Binding var colorFilter: UIColor
//    @Binding var selectedColorFrame: CGRect
//    var coordinateSpace: CoordinateSpace
//    
//    var body: some View {
//        VStack{
//            GeometryReader { geo in
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color(uiColor: color))
//                    .frame(width: 30, height: 30)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(selectedColor == Color(uiColor: color) ? AppStyle.accentColor_SwiftUI : .label, lineWidth: 1) // Highlight when selected
//                    )
//                    aapGesture {
//                        selectedColor = Color(uiColor: color)
//                        colorFilter = color
//                        showShades = true
//                        showPopover = true
//                        selectedColorFrame = geo.frame(in: coordinateSpace)
//                        shadesArray = Shades(color: color, numShades: 3)
//                    }
//            }
//            .frame(width: 30, height: 30)
//        }
//    }
//    
//    func Shades(color: UIColor, numShades: Int) -> [UIColor] {
//        // Extract RGB components from the color
//        guard let components = color.cgColor.components else {
//            return []
//        }
//        
//        let red = components[0]
//        let green = components[1]
//        let blue = components[2]
//        let alpha = components[3]
//
//        var shades = [UIColor]()
//
//        // Calculate the step size for each shade
//        let step: CGFloat = 1 / CGFloat(numShades + 1) // Adding 1 to numShades for excluding pure black and white
//
//        // Generate light shades
//        for i in stride(from: numShades, through: 1, by: -1) {
//            let newRed = min(red + (step * CGFloat(i)), 1.0)
//            let newGreen = min(green + (step * CGFloat(i)), 1.0)
//            let newBlue = min(blue + (step * CGFloat(i)), 1.0)
//            let shadeColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
//            shades.append(shadeColor)
//        }
//        
//        // Add the original color
//        shades.append(color)
//
//        // Generate dark shades
//        for i in 1...numShades {
//            let newRed = max(red - (step * CGFloat(i)), 0)
//            let newGreen = max(green - (step * CGFloat(i)), 0)
//            let newBlue = max(blue - (step * CGFloat(i)), 0)
//            let shadeColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
//            shades.append(shadeColor)
//        }
//
//        return shades
//    }
//}






