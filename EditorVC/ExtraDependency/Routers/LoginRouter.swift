//
//  LoginRouter.swift
//  VideoInvitation
//
//  Created by HKBeast on 29/05/25.
//

import Foundation
import SwiftUI
enum LoginSheetType: SheetRepresentable {

    case WhatsNew
    
    var id: String {
        switch self {
        case .WhatsNew: return "WhateNew"
        }
    }

}

final class LoginRouter: BaseRouter<AppRoute,LoginSheetType,AppFullScreenSheetType>{
    enum LoginRoute: Hashable {
        case emailLogin
        case signUp
        case verifyOTP
        case forgetPassword
        case emailSent
    }

    @Published var loginPath: [LoginRoute] = []

    func push(_ route: LoginRoute) {
        loginPath.append(route)
    }

    override func pop() {
        _ = loginPath.popLast()
    }

    override func popToRoot() {
        loginPath.removeAll()
    }
    
    func replace(with route: LoginRoute) {
        _ = loginPath.popLast()
        loginPath.append(route)
    }
    
    override func present(_ sheet: LoginSheetType) {
    }
}
