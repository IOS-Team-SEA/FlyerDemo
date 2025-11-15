//
//  SceneDelegate.swift
//  FlyerDemo
//
//  Created by HKBeast on 11/11/25.
//

import Foundation
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("✅ SceneDelegate willConnectTo called")

        guard let windowScene = scene as? UIWindowScene else { return }

        // SwiftUI View
        let contentView = ContentView()

        // Wrap SwiftUI view in a HostingController
        let hostingVC = UIHostingController(rootView: contentView)
        hostingVC.title = "Home"

        // UINavigationController as root
        let navController = UINavigationController(rootViewController: hostingVC)
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationBar.isHidden = false

        // Create and assign window
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
