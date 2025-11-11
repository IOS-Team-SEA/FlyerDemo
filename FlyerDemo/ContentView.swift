//
//  ContentView.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Welcome Screen")
                .font(.title)
            
            Button("Open Editor") {
                pushParentEditorView()
            }
            .buttonStyle(.borderedProminent)
        }
        
    }
    
    private func pushParentEditorView() {
        guard let nav = (UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController as? UINavigationController)
        else {
            print("❌ Navigation controller not found")
            return
        }
        
        // Create SwiftUI ParentEditorView
        let parentEditorView = ParentEditorVC()
        
        // Wrap in a UIHostingController
        let hostingVC = UIHostingController(rootView: parentEditorView)
//        hostingVC.title = "Editor"
        
        // Push onto navigation controller
        nav.pushViewController(hostingVC, animated: true)
    }
    
}

#Preview {
    ContentView()
}

struct EditorViewWrapper: UIViewControllerRepresentable {
//    let templateId: Int
//    let thumbImage: UIImage
    let viewModel: EditorVM

    func makeUIViewController(context: Context) -> EditorVC {
        let editorVC = EditorVC(viewModel: viewModel/*templateID: templateId, thumbImage: thumbImage*/)
        return editorVC
//        let navController = UINavigationController(rootViewController: editorVC)
//            navController.navigationBar.isTranslucent = true
//            navController.navigationBar.prefersLargeTitles = false
//            return navController
    }

    func updateUIViewController(_ uiViewController: EditorVC, context: Context) {
        // You can update state here if needed
    }
}
