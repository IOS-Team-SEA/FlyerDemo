import SwiftUI
//import SwiftUIIntrospect

struct ColorAdjustMentView: View {
    @Binding var brightness: Float
    @Binding var beginBrightness: Float
    @Binding var endBrightness: Float
    @Binding var contrast: Float
    @Binding var beginContrast: Float
    @Binding var endContrast: Float
    @Binding var highlight: Float
    @Binding var beginHighlight: Float
    @Binding var endHighlight: Float
    @Binding var shadows: Float
    @Binding var beginShadows: Float
    @Binding var endShadows: Float
    @Binding var saturation: Float
    @Binding var beginSaturation: Float
    @Binding var endSaturation: Float
    @Binding var vibrance: Float
    @Binding var beginVibrance: Float
    @Binding var endVibrance: Float
    @Binding var sharpness: Float
    @Binding var beginSharpness: Float
    @Binding var endSharpness: Float
    @Binding var warmth: Float
    @Binding var beginWarmth: Float
    @Binding var endWarmth: Float
    @Binding var tint: Float
    @Binding var beginTint: Float
    @Binding var endTint: Float
    @Binding var selectedColorAdjustment: String
    
    var range: ClosedRange<Double> = -1...1
    var brightnessRange: ClosedRange<Double> = 0...1
    @State var minRange: Float = -1
    @State var maxRange: Float = 1
    @State var HSMinRange: Float = 0
    @Binding var updateThumb: Bool
    
    let adjustments = [
        ("brightness", \ColorAdjustMentView.$brightness, \ColorAdjustMentView.$beginBrightness, \ColorAdjustMentView.$endBrightness, \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange),
        ("Contrast", \ColorAdjustMentView.$contrast, \ColorAdjustMentView.$beginContrast, \ColorAdjustMentView.$endContrast, \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange),
            ("Highlight", \ColorAdjustMentView.$highlight, \ColorAdjustMentView.$beginHighlight, \ColorAdjustMentView.$endHighlight, \ColorAdjustMentView.HSMinRange, \ColorAdjustMentView.maxRange),
            ("Shadows", \ColorAdjustMentView.$shadows, \ColorAdjustMentView.$beginShadows, \ColorAdjustMentView.$endShadows, \ColorAdjustMentView.HSMinRange, \ColorAdjustMentView.maxRange),
            ("Saturation", \ColorAdjustMentView.$saturation, \ColorAdjustMentView.$beginSaturation, \ColorAdjustMentView.$endSaturation, \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange),
            ("vibrance", \ColorAdjustMentView.$vibrance, \ColorAdjustMentView.$beginVibrance, \ColorAdjustMentView.$endVibrance, \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange),
        ("Sharpness", \ColorAdjustMentView.$sharpness, \ColorAdjustMentView.$beginSharpness, \ColorAdjustMentView.$endSharpness,  \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange),
            ("warmth", \ColorAdjustMentView.$warmth, \ColorAdjustMentView.$beginWarmth, \ColorAdjustMentView.$endWarmth, \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange),
            ("Tint", \ColorAdjustMentView.$tint, \ColorAdjustMentView.$beginTint, \ColorAdjustMentView.$endTint, \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange)
        ]
    @State var selectedAdjustment = ("Brightness", \ColorAdjustMentView.$brightness, \ColorAdjustMentView.$beginBrightness, \ColorAdjustMentView.$endBrightness,  \ColorAdjustMentView.minRange, \ColorAdjustMentView.maxRange)
    
    let rows = [
        GridItem(.fixed(80))
    ]

    var body: some View {
        VStack{
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader{ proxy in
                    LazyHGrid(rows: rows) {
                        ForEach(adjustments, id: \.0) { adjustment in
                            let binding = self[keyPath: adjustment.1]
                            let value = binding.wrappedValue
                            VStack(spacing: 5){
                                
                                VStack{
                                    SwiftUI.Image(adjustment.0)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(selectedColorAdjustment == adjustment.0 ? AppStyle.accentColor_SwiftUI : .primary)
                                        .frame(width: 30, height: 30)
                                }
                                .frame(width: 50, height: 50)
                                .background(Color.systemBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedColorAdjustment == adjustment.0 ? AppStyle.accentColor_SwiftUI : .clear, lineWidth: 2)
                                        .frame(width: 55, height: 55)
                                )
                                
                                
                                Text(adjustment.0)
                                    .font(.subheadline)
                                    .foregroundColor(selectedColorAdjustment == adjustment.0 ? AppStyle.accentColor_SwiftUI : .primary)
                                    .frame(width: 80)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                
                                // Dot indicator
                                Circle()
                                    .fill(value != 0.0 ? AppStyle.accentColor_SwiftUI : .clear)
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 4)
                                    .padding(.bottom, 2)
                                
                            }
                            .frame(width: 80, height: 80)
                            .onTapGesture {
                                selectedAdjustment = adjustment
                                selectedColorAdjustment = adjustment.0
                                updateThumb = true
                            }
                        }
                    }
                    .frame(height: 100)
                    .padding(.horizontal)
                    .onChange(of: selectedColorAdjustment) { newValue in
                        if let matchingAdjustment = adjustments.first(where: { $0.0 == newValue }) {
                            selectedAdjustment = matchingAdjustment
                            scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: newValue)
                        }
                    }
                    .onAppear(){
                        scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: selectedColorAdjustment)
                    }
                   
                }
            }
            .frame(height: 110)
            
            
            HStack{
                GeometryReader { geometry in
                    ZStack {
                        
//                        Rectangle()
//                            .foregroundColor(AppStyle.accentColor_SwiftUI)
//                            .frame(
//                                width: ((geometry.size.width / 2) - sliderThumbOffset(geometry: geometry, sliderValue: CGFloat(self[keyPath: selectedAdjustment.1].wrappedValue)))
//                                ,height: 4
//                            )
//                            .offset(x: sliderThumbOffset(geometry: geometry, sliderValue: CGFloat(self[keyPath: selectedAdjustment.1].wrappedValue)))
                        
                        Slider(
                            value: Binding(get: {
                                self[keyPath: selectedAdjustment.1].wrappedValue
                            }, set: { newValue in
                                if abs(newValue) < 0.01 { // Snap threshold
                                    if self[keyPath: selectedAdjustment.1].wrappedValue != 0 {
                                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                                        feedback.impactOccurred() // Trigger vibration
                                    }
                                    self[keyPath: selectedAdjustment.1].wrappedValue = 0
                                } else {
                                    self[keyPath: selectedAdjustment.1].wrappedValue = newValue
                                }
                                //                                self[keyPath: selectedAdjustment.1].wrappedValue = newValue
                            }),
                            in: self[keyPath: selectedAdjustment.4]...self[keyPath: selectedAdjustment.5], onEditingChanged: { value in
                                
                                if value{
                                    self[keyPath: selectedAdjustment.2].wrappedValue = self[keyPath: selectedAdjustment.1].wrappedValue
                                }else{
                                    self[keyPath: selectedAdjustment.3].wrappedValue = self[keyPath: selectedAdjustment.1].wrappedValue
                                    updateThumb = true
                                }
                            }
                        )
//                        .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                            slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                        }
                        .tint(AppStyle.accentColor_SwiftUI)
//                        .tint(.clear)
                        
                        Text(String(format: "%.0f", self[keyPath: selectedAdjustment.1].wrappedValue * 100))
                            .font(.caption)
                            .foregroundColor(.black)
                            .offset(x: selectedAdjustment.0 == "Highlight" || selectedAdjustment.0 == "Shadows" ? sliderThumbOffset(geometry: geometry, sliderValue: CGFloat(self[keyPath: selectedAdjustment.1].wrappedValue), range: brightnessRange) : sliderThumbOffset(geometry: geometry, sliderValue: CGFloat(self[keyPath: selectedAdjustment.1].wrappedValue), range: range), y: -20)
                        
                    }
                }
                .frame(height: 40)
            }
            .frame(width: 350, height: 40)
        }
        .frame(height: 180)
    }
    
    private func sliderThumbOffset(geometry: GeometryProxy, sliderValue: CGFloat, range: ClosedRange<Double>) -> CGFloat {
        // Calculate the position of the slider thumb
        let sliderWidth = geometry.size.width
        let normalizedValue = CGFloat((sliderValue - range.lowerBound) / (range.upperBound - range.lowerBound))
        return normalizedValue * sliderWidth - (sliderWidth / 2)
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: String) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        }
            
    }
}
