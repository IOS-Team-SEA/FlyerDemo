//
//  MusicView.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 20/04/24.
//

import SwiftUI

struct PlayingStateView: View {
    @State private var rotationDegree = 0
    @Binding  var isAnimation : Bool
    let mainCirle: CGFloat = 30
    let rotationLine: CGFloat = 35
    let capshuleWidth: CGFloat = 12
    
    var body: some View {
        ZStack {
            Circle().fill(Color.getBallColor())
                .frame(width: mainCirle, height: mainCirle)
            
            HStack(alignment: .center, spacing: 8){
                SwiftUI.Image(systemName: "music.note")               .rotationEffect(.degrees(Double(isAnimation ? -360 : 0)))
                    .animation(Animation.linear(duration: isAnimation ? 3 : 0).repeatForever(autoreverses: false)).frame(height: mainCirle, alignment: .center)


                
            }.frame(height: mainCirle, alignment: .center)
            .animation(Animation.linear(duration: 0.5).repeatForever())
            
            if isAnimation == false {
                Circle().fill(.clear)

                .frame(width: rotationLine, height: rotationLine)
            }else {
                
                
                
                Circle()
                // .trim(from: 0.0, to: 1.0)
                    .stroke(Color.getBallColor(), style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [4, 4], dashPhase: 2))
                
                    .rotationEffect(.degrees(Double(rotationDegree)))
                
                    .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false))
                
                    .frame(width: rotationLine, height: rotationLine)
                    .onAppear() {
                        rotationDegree = -360

                    }
            }
            
            
        }.onAppear() {
           // rotationDegree = -360
           // isAnimation.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayingStateView(isAnimation: .constant(true))
    }
}
//
//  Color.swift
//  Insta-template
//
//  Created by Arvind on 03/12/20.
//

import SwiftUI

extension Color {
    
    static
    func getBallColor() -> LinearGradient {
        let color = [
            AppStyle.accentColor_SwiftUI,
            Color(hex: "f99068"),
        ]
        return LinearGradient(gradient: Gradient(colors: color), startPoint: .leading, endPoint: .trailing)
    }
    static
    func getClearColor() -> LinearGradient {
        let color = [
            Color.clear,
            Color.clear,
        ]
        return LinearGradient(gradient: Gradient(colors: color), startPoint: .leading, endPoint: .trailing)
    }
    
    static
    func getRightButtonColor() -> LinearGradient {
        let color = [
            Color(hex: "f99068"),
            Color(hex: "f35872"),
        ]
        return LinearGradient(gradient: Gradient(colors: color), startPoint: .leading, endPoint: .trailing)
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
