////
////  CustomColorDropperView.swift
////  VideoInvitation
////
////  Created by SEA PRO2 on 21/08/24.
////
//
//import SwiftUI
//
//struct CustomColorDropperView: View {
//    
//    @Binding var image: UIImage?
//    @State var pickedColor: UIColor = .black
//    @Binding var currentColor: UIColor
//    let onDone: ((UIColor)->Void)?
//        
//    var body: some View {
//        
//        VStack {
//            HStack{
//                Button(action: {
//                    onDone?(pickedColor)
//                }, label: {
//                    Text("Cancel_")
//                        .font(.callout)
//                        .foregroundColor(AppStyle.accentColor_SwiftUI)
//                }).padding()
//                Spacer()
//                Button(action: {
//                    onDone?(pickedColor)
//                }, label: {
//                    Text("Done_")
//                        .font(.callout)
//                        .foregroundColor(AppStyle.accentColor_SwiftUI)
//                })
//            }
//            .padding(.top, -30)
//            .padding(.trailing, 20)
//            GeometryReader { geometry in
//                VStack{
//                    if let image = image{
//                        SwiftUI.Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .onTapGesture {
//                                let scenes = UIApplication.shared.connectedScenes
//                                let windowScenes = scenes.compactMap({ $0 as? UIWindowScene })
//                                if let windowScene = windowScenes.first(where: { $0.activationState == .foregroundActive }) {
//                                    let picker = ScopeColorPicker(windowScene: windowScene)
//                                    Task {
//                                        let color = await picker.pickColor()
//                                        pickedColor = color
//                                    }
//                                }
//                            }
//                        //                        .onChange(of: pickedColor) { newValue in
//                        //                            let scenes = UIApplication.shared.connectedScenes
//                        //                            let windowScenes = scenes.compactMap({ $0 as? UIWindowScene })
//                        //                            if let windowScene = windowScenes.first(where: { $0.activationState == .foregroundActive }) {
//                        //                                let picker = ScopeColorPicker(windowScene: windowScene)
//                        //                                Task {
//                        //                                    let color = await picker.pickColor()
//                        //                                    pickedColor = color
//                        //                                }
//                        //                            }
//                        //                        }
//                    }
//                }
//                .frame(width: 350)
//                .frame(maxHeight: .infinity)
//            }
//            .frame(width: 350)
//            .frame(maxHeight: .infinity)
//            .padding(.vertical)
//
//        }
//        .padding(.top, 50)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//        Spacer()
//            .onAppear(){
//                let scenes = UIApplication.shared.connectedScenes
//                let windowScenes = scenes.compactMap({ $0 as? UIWindowScene })
//                if let windowScene = windowScenes.first(where: { $0.activationState == .foregroundActive }) {
//                    let picker = ScopeColorPicker(windowScene: windowScene)
//                    Task {
//                        let color = await picker.pickColor()
//                        pickedColor = color
//                    }
//                }
//            }
//    }
//}
//
//struct CustomColorDropperView_Previews: PreviewProvider {
//    @State static var currentColor: UIColor = .red
//    @State static var pickedColor: UIColor = .black
//
//    static var previews: some View {
//        CustomColorDropperView(
//            image: .constant(UIImage(named: "b0")!), // Placeholder image
//            pickedColor: pickedColor,
//            currentColor: $currentColor,
//            onDone: { color in
//                // You can add any functionality here for preview purposes
//                print("Selected Color: \(color)")
//            }
//        )
//    }
//}
//
//
////struct SelectedColorView: View {
////    let title: String
////    @Binding var color: UIColor
////    
////    var body: some View {
////        VStack {
////            Text(title)
//////            if let color = color {
////                Rectangle()
////                    .fill(Color(color))
////                    .frame(width: 100, height: 100)
////                    .cornerRadius(10)
////                    .overlay {
////                        RoundedRectangle(cornerRadius: 10)
////                            .stroke(Color.label, lineWidth: 2)
////                            .frame(width: 105, height: 105)
////                    }
//////            } else {
//////                Rectangle()
//////                    .fill(Color.gray)
//////                    .frame(width: 100, height: 100)
//////                    .cornerRadius(10)
//////            }
////        }
////        .padding()
////    }
////}
//
//

import SwiftUI

struct CustomColorDropperView: View {
    @Binding var image: UIImage?
    @State private var pickedColor: UIColor = .black
    @Binding var currentColor: UIColor
    let onDone: ((UIColor) -> Void)?
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            // Header with Cancel and Done buttons
            HStack {
//                Button("Cancel") {
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .font(.callout)
//                .foregroundColor(AppStyle.accentColor_SwiftUI)
                Spacer()
                Button("Cancel_") {
                   // onDone?(pickedColor)
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.callout)
                .foregroundColor(AppStyle.accentColor_SwiftUI)
            }
            .padding()

            // Image display with tap gesture to pick color
            GeometryReader { geometry in
                if let image = image {
                    SwiftUI.Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        .onTapGesture {
                            presentColorPicker()
                        }
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
            TapLabel()
            Spacer() // Avoid overlapping buttons
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.sizeCategory, .medium)
    }

    /// Presents the `ScopeColorPicker` and dismisses after picking a color
    private func presentColorPicker() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.compactMap { $0 as? UIWindowScene }

        if let windowScene = windowScenes.first(where: { $0.activationState == .foregroundActive }) {
            let picker = ScopeColorPicker(windowScene: windowScene)

            Task {
                let color = await picker.pickColor()
                DispatchQueue.main.async {
                    pickedColor = color
                    //currentColor = color
                    onDone?(color) // Trigger the completion handler
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }
            }
        }
    }
}

struct CustomColorDropperView_Previews: PreviewProvider {
    @State static var currentColor: UIColor = .red

    static var previews: some View {
        CustomColorDropperView(
            image: .constant(UIImage(named: "b0")!), // Replace with a valid image
            currentColor: $currentColor,
            onDone: { color in
                print("Selected Color: \(color)")
            }
        )
    }
}


struct TapLabel: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Text("Tap_the_view_to_pick_a_color")
            .font(.headline)
            .padding()
            .foregroundColor(.black)
            //.background(AppStyle.accentColor_SwiftUI)
            .cornerRadius(12)
            .scaleEffect(scale) // Apply scaling
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    scale = 1.1 // Slightly zoom in
                }
            }
        
    }
}
