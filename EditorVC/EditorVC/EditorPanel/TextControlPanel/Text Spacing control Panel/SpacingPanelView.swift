//
//  SpacingPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 03/04/24.
//

import SwiftUI
//import SwiftUIIntrospect

struct SpacingPanelView: View {
    
    @Binding var letterSpacing: Float
    @Binding var lineSpacing: Float
    @Binding var beginLetterSpacing: Float
    @Binding var endLetterSpacing: Float
    @Binding var beginLineSpacing: Float
    @Binding var endLineSpacing: Float
    @Binding var updateThumb: Bool
//    @Binding var redraw: Bool
    
    var body: some View {
        VStack{
            SpacingView(letterSpacing: $letterSpacing, lineSpacing: $lineSpacing, beginLetterSpacing: $beginLetterSpacing, endLetterSpacing: $endLetterSpacing, beginLineSpacing: $beginLineSpacing, endLineSpacing: $endLineSpacing, updateThumb: $updateThumb)
        }.frame(height: 125)
    }
}

//#Preview {
//    SpacingPanelView(letterSpacing: .constant(1), lineSpacing: .constant(1), beginLetterSpacing: .constant(1), endLetterSpacing: .constant(1), beginLineSpacing: .constant(1), endLineSpacing: .constant(1))
//}

struct SpacingView: View {
    
    @Binding var letterSpacing: Float
    @Binding var lineSpacing: Float
    @Binding var beginLetterSpacing: Float
    @Binding var endLetterSpacing: Float
    @Binding var beginLineSpacing: Float
    @Binding var endLineSpacing: Float
    @Binding var updateThumb: Bool
//    @Binding var redraw :Bool
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("Letter_Spacing")
                        .font(.subheadline)
//                        .padding(.leading, 20)
//                }
//                HStack{
//                    
                    Slider(
                        value: $letterSpacing ,
                        in: 0...2,
                        
                        onEditingChanged: { value in
                           
                            if value{
//                                redraw = true
                                beginLetterSpacing = letterSpacing
                            }else{
                                endLetterSpacing = letterSpacing
                                updateThumb = true
                                // redraw
                            }
                        }
                        
                    )
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
                    Text("\(String(format: "%.0f", letterSpacing*50))%")
                        .font(.subheadline)
                }.frame(width: 350)
            }.frame(height: 50)
            
            VStack{
                HStack{
                    Text("Line_Spacing")
                        .font(.subheadline)
//                        .padding(.leading, 20)
//                    Spacer()
//                }
//                HStack{
                    
                    Slider(
                        value: $lineSpacing,
                        in: 1...2,
                        onEditingChanged: { value in
                            if value{
                                beginLineSpacing = lineSpacing
                            }else{
                                endLineSpacing = lineSpacing
                                updateThumb = true
                            }
                        }
                    )
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
                    Text("\(String(format: "%.0f", (lineSpacing - 1) * 100))%")
                        .font(.subheadline)
                }.frame(width: 350)
            }.frame(height: 50)
        }
    }
}
