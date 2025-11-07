//
//  OpacityPanel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 11/03/24.
//

import SwiftUI
//import SwiftUIIntrospect

protocol ContainerHeightProtocol:AnyObject{
    func didContainerHeightChanged(height : CGFloat)
}

struct OpacityPanel: View {
    /*var editorVM = EditorVM()*/ //JM ** not used
    @Binding var opacity : Float
    @Binding var showPanel: Bool
    @Binding var endOpacity: Float
    @Binding var beginOpacity: Float 
    @Binding var updateThumb: Bool
//    @State var dbOpacity : Float
    
    var body: some View {
//        ZStack {
//            Color.white
            VStack{
                HStack{
                    Text("Opacity_")
                        .font(.subheadline)
                    Slider(
                        value: $opacity,
                        in: 0...1,
                        onEditingChanged: { value in
                            //                      dbOpacity = opacity
                            //                      currentModel.modelOpacity = opacity
                            
                            //
                            if value{
                                
                                beginOpacity = opacity
//                                isOpacityEnded = editing
                            }else{
                                
                                endOpacity = opacity
                                updateThumb = true
                            }
                        }
                    )
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
//                    .onch
                    
                    Text("\(String(format: "%.0f", opacity*100))%")
                    .font(.subheadline)
                }.frame(width: 350, height: 50)
            }.frame(height: 180)
            
//        }
    }
}

//#Preview {
//    OpacityPanel(opacity: 4.0 , dbOpacity: 9.0)
//}


