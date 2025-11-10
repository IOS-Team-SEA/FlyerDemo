//
//  ContentView.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct ContentView: View {
    
    @State var tempId: Int? = nil
    
    var body: some View {
//        NavigationView{
//            VStack{
//                Button {
                    EditorViewWrapper(templateID: 239, thumbImage: UIImage(systemName: "plus") ?? UIImage())
                            .ignoresSafeArea()
                            
//                } label: {
//                    Text("push To Editor")
//                }
//                
//            }
//        }
        

    }
    
}

#Preview {
    ContentView()
}

struct EditorViewWrapper: UIViewControllerRepresentable {
    let templateID: Int
    let thumbImage: UIImage

    func makeUIViewController(context: Context) -> UINavigationController {
        let editorVC = EditorVC(templateID: templateID, thumbImage: thumbImage)
//        return editorVC
        let navController = UINavigationController(rootViewController: editorVC)
            navController.navigationBar.isTranslucent = true
            navController.navigationBar.prefersLargeTitles = false
            return navController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // You can update state here if needed
    }
}
