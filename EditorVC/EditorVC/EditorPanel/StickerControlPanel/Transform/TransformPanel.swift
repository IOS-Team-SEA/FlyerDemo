//
//  TransformPanel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 28/03/24.
//

import SwiftUI

struct TransformPanel: View {
    
    @Binding var flipHorizontal: Bool
    @Binding var flipVertical: Bool
    @Binding var lastSelectedFlipV: Bool
    @Binding var lastSelectedFlipH : Bool
    
    var body: some View {
        VStack{
            HStack(spacing: 50){
                VStack{
                    VStack{
                        SwiftUI.Image("flip_horizontal")
                            .resizable()
                            .renderingMode(flipHorizontal == true ? .template : .original)
                            .foregroundColor(AppStyle.accentColor_SwiftUI)
                            .frame(width: 30, height: 30)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(5)
                            
                    }
                    .onTapGesture {
                        if flipHorizontal{
                            flipHorizontal = false
                        }else{
                            flipHorizontal = true
                        }
                        lastSelectedFlipH = flipHorizontal
                    }
                    .frame(width: 50, height: 50)
                    
                    Text("Flip_Horizontal")
                        .foregroundColor(flipHorizontal == true ? AppStyle.accentColor_SwiftUI : .label)
                        .font(.caption)
                }.frame(width: 100, height: 80)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(5)
                
                VStack{
                    VStack{
                        SwiftUI.Image("flip_vertical")
                            .resizable()
                            .renderingMode(flipVertical == true ? .template : .original)
                            .foregroundColor(AppStyle.accentColor_SwiftUI)
                            .frame(width: 30, height: 30)
                    }
                    .onTapGesture {
                        if flipVertical{
                            flipVertical = false
                        }else{
                            flipVertical = true
                        }
                        lastSelectedFlipV = flipVertical
                    }
                    .frame(width: 50, height: 50)
                    Text("Flip_Vertical")
                        .foregroundColor(flipVertical == true ? AppStyle.accentColor_SwiftUI : .label)
                        .font(.caption)
                    
                }
                .frame(width: 100, height: 80)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(5)
            }
        }
        .onAppear(){
//            flipVertical = lastSelectedFlipV
//            flipHorizontal = lastSelectedFlipH
        }
        .frame(height: 125)
    }
}

#Preview {
    TransformPanel(flipHorizontal: .constant(false), flipVertical: .constant(false), lastSelectedFlipV: .constant(false), lastSelectedFlipH: .constant(false))
}
