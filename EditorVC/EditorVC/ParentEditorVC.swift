//
//  ParentEditorVC.swift
//  FlyerDemo
//
//  Created by HKBeast on 11/11/25.
//

import SwiftUI

struct ParentEditorVC: View {
    
    @ObservedObject var viewModel: EditorVM
    
    init(templateId: Int = 239, thumbImage: UIImage = UIImage(systemName: "plus") ?? UIImage()) {
        let resolver = Injection.shared.appLevelResolver
        let resolvedVM = resolver.resolve(EditorVM.self, arguments: templateId, thumbImage)!
        self.viewModel = resolvedVM
    }
    
    var body: some View {
        EditorViewWrapper(viewModel: viewModel/*templateId: 239, thumbImage: UIImage(systemName: "plus") ?? UIImage()*/)
                .ignoresSafeArea()
       
    }
    
    
}

//#Preview {
//    ParentEditorVC()
//}
