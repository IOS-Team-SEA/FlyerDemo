//
//  ColorPanel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 21/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct ColorPanel: View {
    
    @State var selectedColor: UIColor = .clear
    @State var shadesArray: [UIColor] = []
    @State var showShades = false
    @State var colors: [UIColor] = ColorDataSource.colorsArray
    var templateID: Int
    @State var templateColorArray: [UIColor] = []
//    @Binding var stickerColor: UIColor
    @Binding var startColor: AnyColorFilter?
    @Binding var endColor: AnyColorFilter?
    @State var isColorPickerSelected = false
    @Binding var colorFilter: AnyColorFilter?
    @State var showPopover: Bool = false
    @State private var selectedColorFrame: CGRect = .zero
    @Binding var updateThumb : Bool
    @Binding var lastSelectedColor: AnyColorFilter?
    @State var isDropperViewPresented = false
    @Binding var thumbImage: UIImage?
    @Binding var showResetText: Bool
    
    var body: some View {
        let colorBinding = bindingForColorValue(bg: $colorFilter)
        let startColorBinding = bindingForColorValue(bg: $startColor)
        let endColorBinding = bindingForColorValue(bg: $endColor)
        let noneBinding = bindingForNoneValue(bg: $colorFilter)
        let lastSelectedColor = bindingForColorValue(bg: $lastSelectedColor)
        
//        ScrollView(.vertical){
            VStack{
                // HStack for reset and picker
                HStack{
                    
                    Button{
                        endColorBinding.wrappedValue = .clear
                        colorBinding.wrappedValue = .clear
                        noneBinding.wrappedValue = true
                    } label: {
                        SwiftUI.Image("reset")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(AppStyle.accentColor_SwiftUI)
                            .frame(width: 20, height: 20)
                        if showResetText{
                            Text("Reset_")
                                .foregroundColor(AppStyle.accentColor_SwiftUI)
                        }
                    }
                    .padding(.leading, 20)
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
                                updateThumb = true
                                isDropperViewPresented = false
                            }
                        }
                    }.padding(.trailing, 20)
                    
                }.frame(maxWidth: .infinity, idealHeight: 25)
                
                ScrollView(.horizontal, showsIndicators: false){
                    ScrollViewReader{ proxy in
                        HStack(spacing: 10){
                            if templateColorArray.isEmpty{
                                ColorPanelView(templateColorArray: $templateColorArray, colors: $colors, shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, startColor: startColorBinding, endColor: endColorBinding, colorFilter: colorBinding, showColorPicker: false, colorType: "All_Colors".translate(), showPopover: $showPopover, selectedColorFrame: $selectedColorFrame, coordinateSpace: .named("colorPanel"),updateThumb: $updateThumb)
                            }else{
                                ColorPanelView(templateColorArray: $templateColorArray, colors: $colors, shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, startColor: startColorBinding, endColor: endColorBinding, colorFilter: colorBinding, showColorPicker: false, colorType: "Template Colors", showPopover: $showPopover, selectedColorFrame: $selectedColorFrame, coordinateSpace: .named("colorPanel"),updateThumb: $updateThumb)
                                
                                Divider()
                                ColorPanelView(templateColorArray: $templateColorArray, colors: $colors, shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, startColor: startColorBinding, endColor: endColorBinding, colorFilter: colorBinding, showColorPicker: false, colorType: "All_Colors".translate(), showPopover: $showPopover, selectedColorFrame: $selectedColorFrame, coordinateSpace: .named("colorPanel"),updateThumb: $updateThumb)
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
                            scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: lastSelectedColor.wrappedValue)
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
                lastSelectedColor.wrappedValue = newValue
            }
            .onAppear(){
                templateColorArray = DataSourceRepository.shared.getTemplateColorArray(templateID: templateID)
//                colorBinding.wrappedValue = lastSelectedColor.wrappedValue
//                selectedColor = lastSelectedColor.wrappedValue
                
                if let initialColorFilter = colorFilter {
                    startColor = initialColorFilter
                }
            }
//        }
    }
    
    func bindingForColorValue(bg: Binding<AnyColorFilter?>) -> Binding<UIColor> {
        return Binding<UIColor>(
            get: {
                if let colorModel = bg.wrappedValue as? ColorFilter {
                    return colorModel.filter
                }
                return .white
            },
            set: { newValue in
                if var colorModel = bg.wrappedValue as? ColorFilter {
                    colorModel.filter = newValue
                    bg.wrappedValue = colorModel
                } else {
                    bg.wrappedValue = ColorFilter(filter: newValue)
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
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: UIColor) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        }
            
    }
    
   // return  ColorPanel(templateID: 1, startColor: colorBinding, endColor: colorBinding, colorFilter: colorBinding, updateThumb: .constant(false),lastSelectedColor :$lastSelectedColor)
}

//#Preview {
//    var colorBinding = Binding<AnyColorFilter?>(get: {
//        return ColorFilter(filter: .blue)
//    }, set: { _ in })
//    
//    return ColorPanel(templateID: 1, startColor: colorBinding, endColor: colorBinding, colorFilter: colorBinding)
//}

struct ColorShadesView: View {
    @Binding var selectedColor: UIColor
    @Binding var shadesArray: [UIColor]
//    @Binding var stickerColor: UIColor
    @Binding var showShades: Bool
    @Binding var colorFilter: UIColor
    @Binding var showPopover: Bool
    @Binding var startColor: UIColor
    @Binding var endColor: UIColor
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(shadesArray, id: \.self) { color in
                
                VStack{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(uiColor: color))
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            selectedColor = color
                            endColor = color
                            startColor = color
                            colorFilter = color
                            
                            showShades = false
                            showPopover = false
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(selectedColor == color ? AppStyle.accentColor_SwiftUI : .label, lineWidth: 1) // Highlight when selected
                                .frame(width: 25, height: 25)
                        )
                    
                }
                
            }
        }
        .frame(height: 30)
        .padding()
        
    }
    
}

struct ColorPanelView: View {
    
    @Binding var templateColorArray: [UIColor]
    @Binding var colors: [UIColor]
    @Binding var shadesArray: [UIColor]
    @Binding var showShades: Bool
//    @Binding var stickerColor: UIColor
    @Binding var selectedColor: UIColor
    @Binding var startColor: UIColor
    @Binding var endColor: UIColor
    @Binding var colorFilter: UIColor
    var showColorPicker: Bool
    var colorType: String
    @Binding var showPopover: Bool
    @Binding var selectedColorFrame: CGRect
    var coordinateSpace: CoordinateSpace
    @Binding var updateThumb: Bool
    
    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
            
        VStack{
            HStack{
                
                Text(colorType)
                    .foregroundColor(Color.secondaryLabel)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(height: 20)
                
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.bottom,0)
            
            HStack(spacing: -10) {
                
                if colorType == "Template Colors"{
                    HStack(spacing: 16){
                        ForEach($templateColorArray, id: \.self) { color in
                            
                            ColorPanelViewCellTemplate(shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, color: color, showPopover: $showPopover, colorFilter: $colorFilter, selectedColorFrame: $selectedColorFrame, startColor: $startColor, endColor: $endColor, coordinateSpace: coordinateSpace, updateThumb: $updateThumb)
                                
                        }
                    }
                }else{
                    
                    HStack(spacing: 16){
                        ForEach($colors, id: \.self) { color in
                            
                            ColorPanelViewCellTemplate(shadesArray: $shadesArray, showShades: $showShades, selectedColor: $selectedColor, color: color, showPopover: $showPopover, colorFilter: $colorFilter, selectedColorFrame: $selectedColorFrame, startColor: $startColor, endColor: $endColor, coordinateSpace: coordinateSpace, updateThumb: $updateThumb)
                            
                        }
                    }
                }
                
                Spacer()
            }
            .frame(height: 65)
            .padding(.horizontal, 5)
            
        }
        
    }
    
    
}

struct ColorDataSource{
    static let colorsArray: [UIColor] = [UIColor(hexString: "000000")!, UIColor(hexString: "FFFFFF")!,UIColor(hexString: "8A2BE2")!,
                                    UIColor(hexString: "87CEEB")!,
                                    UIColor(hexString: "00FF00")!,
                                    UIColor(hexString: "808000")!,
                                    UIColor(hexString: "FFD700")!,
                                    UIColor(hexString: "DC143C")!,
                                    UIColor(hexString: "800000")!,
                                    UIColor(hexString: "FF00FF")!,
                                    UIColor(hexString: "D2691E")!,
                                    UIColor(hexString: "708090")!,
                                    UIColor(hexString: "8B4513")!,
                                    UIColor(hexString: "F5DEB3")!,
                                    UIColor(hexString: "00008B")!,
                                    UIColor(hexString: "4682B4")!,
                                    UIColor(hexString: "7FFFD4")!,
                                    UIColor(hexString: "00FFFF")!,
                                    UIColor(hexString: "228B22")!,
                                    UIColor(hexString: "FFA500")!,
                                    UIColor(hexString: "9ACD32")!,
                                    UIColor(hexString: "FF0000")!
                                ]
    
}




struct ColorPanelViewCellTemplate: View {
    
    @Binding var shadesArray: [UIColor]
    @Binding var showShades: Bool
//    @Binding var stickerColor: UIColor
    @Binding var selectedColor: UIColor
    @Binding var color: UIColor
    @Binding var showPopover: Bool
    @Binding var colorFilter: UIColor
    @Binding var selectedColorFrame: CGRect
    @Binding var startColor: UIColor
    @Binding var endColor: UIColor
    var coordinateSpace: CoordinateSpace
    @Binding var updateThumb : Bool
    
    var body: some View {
        VStack{
            GeometryReader { geo in
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(uiColor: color))
                        .frame(width: 30, height: 60)
                        .overlay(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedColor == color ? AppStyle.accentColor_SwiftUI : .label, lineWidth: 1) // Highlight when selected
                                .frame(width: 35, height: 65)
                        )
                        
                    if colorFilter == color{
                        
                        SwiftUI.Image("colorControl")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(color.isExtendedSRGBWhite ? .black : .white)
                            .frame(width: 25, height: 25)
                    }
                }
                .onTapGesture {
                    if colorFilter == color {
                        // If this color is already selected, show shades
                        showShades = true
                        showPopover = true
                    } else {
                        // If a different color is selected, update the selected color
                        selectedColor = color
                        endColor = color
                        startColor = color
                        colorFilter = color
                        showShades = false
                        showPopover = false
                        updateThumb = true
                    }
                    selectedColorFrame = geo.frame(in: coordinateSpace)
                    shadesArray = Shades(color: color, numShades: 3)
                }
            }
            .frame(width: 30, height: 65)
                
        }
        
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






extension UIColor {
    var isExtendedSRGBWhite: Bool {
        if let colorSpace = self.cgColor.colorSpace, colorSpace.model == .rgb {
            let components = self.cgColor.components
            return components?[0] == 1.0 && components?[1] == 1.0 && components?[2] == 1.0 && components?[3] == 1.0
        }
        return false
    }
}

extension View {
    public func alwaysPopover<Content>(isPresented: Binding<Bool>, frame: Binding<CGRect>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.modifier(AlwaysPopoverModifier(isPresented: isPresented, frame: frame, contentBlock: content))
    }
}
struct AlwaysPopoverModifier<PopoverContent>: ViewModifier where PopoverContent: View {
    
    let isPresented: Binding<Bool>
    let frame: Binding<CGRect>
    let contentBlock: () -> PopoverContent
    
    // Workaround for missing @StateObject in iOS 13.
    private struct Store {
        var anchorView = UIView()
    }
    @State private var store = Store()
    
    func body(content: Content) -> some View {
        if isPresented.wrappedValue {
            presentPopover()
        }
        
        return content
            .background(InternalAnchorView(uiView: store.anchorView))
    }
    
    private func presentPopover() {
        let contentController = ContentViewController(rootView: contentBlock(), isPresented: isPresented)
        contentController.modalPresentationStyle = .popover
        
        let view = store.anchorView
        guard let popover = contentController.popoverPresentationController else { return }
        popover.sourceView = view
        popover.sourceRect = /*view.bounds*/ frame.wrappedValue
        popover.delegate = contentController
        
        guard let sourceVC = view.closestVC() else { return }
        if let presentedVC = sourceVC.presentedViewController {
            presentedVC.dismiss(animated: true) {
                sourceVC.present(contentController, animated: true)
            }
        } else {
            sourceVC.present(contentController, animated: true)
        }
    }
    
    private struct InternalAnchorView: UIViewRepresentable {
        typealias UIViewType = UIView
        let uiView: UIView
        
        func makeUIView(context: Self.Context) -> Self.UIViewType {
            uiView
        }
        
        func updateUIView(_ uiView: Self.UIViewType, context: Self.Context) { }
    }
}

extension UIView {
    func closestVC() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}

class ContentViewController<V>: UIHostingController<V>, UIPopoverPresentationControllerDelegate where V:View {
    var isPresented: Binding<Bool>
    
    init(rootView: V, isPresented: Binding<Bool>) {
        self.isPresented = isPresented
        super.init(rootView: rootView)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = sizeThatFits(in: UIView.layoutFittingExpandedSize)
        preferredContentSize = size
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.isPresented.wrappedValue = false
    }
}
