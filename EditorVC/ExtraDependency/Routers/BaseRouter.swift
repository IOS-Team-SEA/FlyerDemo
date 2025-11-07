//
//  BaseRouter.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 09/05/25.
//

import SwiftUI

class BaseRouter<AppRoute,SheetType: SheetRepresentable,FullSheetType:SheetRepresentable>: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var sheet: SheetType?
    @Published var fullSheet: FullSheetType?
    @Published var alert: AlertData?
    @Published var isLoaderVisible: Bool = false

    // MARK: - Navigation
    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
       
        path.removeAll()
    }

    func popBack(steps: Int) {
        guard steps > 0, steps <= path.count else { return }
        path.removeLast(steps)
    }

    // MARK: - Sheet Presentation
    func present(_ sheet: SheetType) {
        self.sheet = sheet
    }
    
    func presentFullScreen(_ sheet: FullSheetType) {
        self.fullSheet = sheet
    }
    func dismissFullSheet() {
        self.fullSheet = nil
    }
    
    func dismissSheet() {
        self.sheet = nil
    }

    // MARK: - Alert
    func showAlert(title: String, message: String) {
        self.alert = AlertData(title: title, message: message)
    }
    
    

    
    func setAlert(data:AlertData) {
        self.alert = alert
    }

    func dismissAlert() {
        self.alert = nil
    }

    // MARK: - Loader
    func showLoader() {
        isLoaderVisible = true
    }

    func hideLoader() {
        isLoaderVisible = false
    }
}

// MARK: - Alert Data
struct AlertData: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let message: String
}

import SwiftUI

protocol SheetRepresentable: Identifiable, Equatable {
    var id: String { get  }
}
extension SheetRepresentable {
    static func == (lhs:  Self, rhs:  Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Detented Sheet Wrapper

//struct DetentedSheetView<Content: View>: View {
//    let content: Content
//    let detents: [PresentationDetent]
//
//    init(detents: [PresentationDetent], @ViewBuilder content: () -> Content) {
//        self.content = content()
//        self.detents = detents
//    }
//
//    var body: some View {
//        content
//            .presentationDetents(Set(detents))
//            .presentationDragIndicator(.visible)
//    }
//}
