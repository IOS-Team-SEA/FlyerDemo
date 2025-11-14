//
//  ParentEditorVC.swift
//  FlyerDemo
//
//  Created by HKBeast on 11/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct ParentEditorVC: View {
    
    @ObservedObject var viewModel: EditorVM
    
    init(templateInfo: TemplateInfo, thumbImage: UIImage = UIImage(systemName: "plus") ?? UIImage()) {
//        let resolver = Injection.shared.appLevelResolver
//        let resolvedVM = resolver.resolve(EditorVM.self, arguments: templateInfo, thumbImage)!
        let resolvedVM = Injection.shared.inject(id: "TemplateInfo_\(templateInfo.templateId)", type: EditorVM.self, argumentA: templateInfo, argumentB: thumbImage)!
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
