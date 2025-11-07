//
//  BlurPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/04/24.
//

import SwiftUI
//import SwiftUIIntrospect

struct BlurPanelView: View {
    
    @Binding var blur: Float
    @Binding var beginBlur: Float
    @Binding var endBlur: Float
    @Binding var updateThumb: Bool
    var body: some View {
        VStack{
            HStack{
//                Text("Blur_")
                Text("Blur_")
                    .font(.subheadline)
                Slider(
                    value: $blur,
                    in: 0...1,
                    onEditingChanged: { value in

                        if value{
                            
                            beginBlur = blur
                        }else{
                            
                            endBlur = blur
                            updateThumb = true
                        }
                    }
                )
//                .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                    slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                }
                .tint(AppStyle.accentColor_SwiftUI)
                Text("\(String(format: "%.0f", blur*100))%")
                    .font(.subheadline)
            }.frame(width: 350, height: 50)
        }.frame(height: 125)
    }
}

//#Preview {
//    BlurPanelView(blur: .constant(1), beginBlur: .constant(1), endBlur: .constant(1))
//}
