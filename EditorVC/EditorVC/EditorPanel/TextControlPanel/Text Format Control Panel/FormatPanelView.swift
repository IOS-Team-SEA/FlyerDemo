//
//  FormatPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 01/04/24.
//

import SwiftUI
import IOS_CommonEditor

struct FormatPanelView: View {
    
//    @State private var selectedSegment: Int = 0
    @Binding var alignment: HTextGravity
    @Binding var lastSelectedAlignment: HTextGravity
    @Binding var text : String
    @Binding var updatedText : String
    @Binding var updateThumb: Bool
    
    var body: some View {
        VStack{
            AlignmentView(alignment: $alignment, lastSelectedAlignment: $lastSelectedAlignment, text: $text, updatedText: $updatedText, updateThumb: $updateThumb)
                .frame(height: 100)
            
        }.frame(height: 125)
    }
}

//#Preview {
//    FormatPanelView(alignment: .constant(.Left), lastSelectedAlignment: .constant(.Center))
//}

struct AlignmentView: View {
    @Binding var alignment: HTextGravity
    @Binding var lastSelectedAlignment: HTextGravity
    @Binding var  text : String
    @Binding var updatedText : String
    @Binding var updateThumb: Bool
    
    var body: some View {
        VStack{
            VStack{
                HStack(spacing: 40){
                    //                VStack{
                    Button {
                        alignment = .Left
                        updateThumb = true
                        // lastSelectedAlignment = alignment
                    } label: {
                        SwiftUI.Image("alignLeft")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(alignment == .Left ? AppStyle.accentColor_SwiftUI : .label)
                            .frame(width: 30, height: 30)
                        
                    }
                    .frame(width: 70, height: 50)
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(5)
                    .buttonStyle(AlignmentBorderButtonStyle(borderColor: alignment == .Left ? AppStyle.accentColor_SwiftUI : .clear, borderWidth: alignment == .Left ? 2 : 0))
                    
                    //                }.onTapGesture {
                    //
                    //                }
                    //                .frame(width: 70, height: 50)
                    //
                    
                    //                VStack{
                    Button {
                        alignment = .Center
                        updateThumb = true
                        // lastSelectedAlignment = alignment
                    } label: {
                        SwiftUI.Image("alignCenter")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(alignment == .Center ? AppStyle.accentColor_SwiftUI : .label)
                            .frame(width: 30, height: 30)
                        
                    }
                    .frame(width: 70, height: 50)
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(5)
                    .buttonStyle(AlignmentBorderButtonStyle(borderColor: alignment == .Center ? AppStyle.accentColor_SwiftUI : .clear, borderWidth: alignment == .Center ? 2 : 0))
                    //                }
                    //                .onTapGesture {
                    //
                    //                }
                    //                .frame(width: 70, height: 50)
                    
                    
                    //                VStack{
                    Button {
                        alignment = .Right
                        updateThumb = true
                        // lastSelectedAlignment = alignment
                    } label: {
                        SwiftUI.Image("alignRight")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(alignment == .Right ? AppStyle.accentColor_SwiftUI : .label)
                            .frame(width: 30, height: 30)
                        
                    }
                    .frame(width: 70, height: 50)
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(5)
                    .buttonStyle(AlignmentBorderButtonStyle(borderColor: alignment == .Right ? AppStyle.accentColor_SwiftUI : .clear, borderWidth: alignment == .Right ? 2 : 0))
                    //                }
                    //                .onTapGesture {
                    //
                    //                }
                    //                .frame(width: 70, height: 50)
                    
                }
            }
            .frame(height: 100)
            .onAppear(){
                //alignment = lastSelectedAlignment
            }
            
            
            Button {
                if text == text.uppercased(){
                    updatedText = text.lowercased()
                }
                else if text == text.lowercased(){
                    updatedText = text.uppercased()
                }
                else{
                    updatedText = text.uppercased()
                }
                updateThumb = true
            } label: {
                Text(text == text.uppercased() ? "Lowercase_" : "Uppercase_" ).frame(width: 100, height: 30)
                    .background(AppStyle.accentColor_SwiftUI )
                    .foregroundColor(.white).cornerRadius(10)
                
            }
        }
    }
}



struct AlignmentBorderButtonStyle: ButtonStyle {
    let borderColor: Color
    let borderWidth: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(width: 70, height: 50)
            )
    }
}
