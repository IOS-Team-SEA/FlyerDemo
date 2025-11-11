//
//  FlyerDemoApp.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import SwiftUI
import IOS_CommonEditor
import IOS_DiagnosticsSPM

class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    @Injected var shaderLibrary : IOS_CommonEditor.ShaderLibrary
//    @Injected var pipelineLibrary : PipelineLibrary
//    @Injected var  mVertexDescriptorLibrary : MVertexDescriptorLibrary
    var shaderLibrary: IOS_CommonEditor.ShaderLibrary!
        var pipelineLibrary: PipelineLibrary!
        var mVertexDescriptorLibrary: MVertexDescriptorLibrary!
    
    // Must return true if using SceneDelegate
        func application(
            _ application: UIApplication,
            configurationForConnecting connectingSceneSession: UISceneSession,
            options: UIScene.ConnectionOptions
        ) -> UISceneConfiguration {
            print("✅ configurationForConnecting called")
            let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
            config.delegateClass = SceneDelegate.self
            return config
        }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("✅ App launched successfully")
        
        DiagnosticManager.shared.startMonitoring(delegate: DiagnosticHandler.shared ,sendCrashReport: true)
        
        DependencyResolver.register(Injection.shared)
        
        AppFileManager.shared.configureDatabaseFolder()
        AppFileManager.shared.configureTemplatesFolder()
        AppFileManager.shared.configureBGAssetsFolder()
        AppFileManager.shared.configureLocalBGAssetsFolder()
        AppFileManager.shared.configureMusicAssetsFolder()
        AppFileManager.shared.configureFontAssetsFolder()
        AppFileManager.shared.configureMyDesignsFolder()
        AppFileManager.shared.configurePromotionalFolder()
        AppFileManager.shared.configureLocalMusicAssetsFolder()
        
        DBManager.setDBLogger(logger: AppDBLogger(), engineConfig: AppEngineConfigure())
        DatabaseManager.shared.configure()
        //        DatabaseManager.shared.getTemplates()
        
        
//        DBManager.createCopyOfDatabaseIfNeeded()
        
        DBManager.createCopyOfStickerDatabaseIfNeeded()
        
        DBManager.shared.manageDatabaseVersions()
        
        
        UserDefaultKeyManager.shared.updateAppOpenCount()
        //        manageOldNewUsers()
        
        shaderLibrary = Injected<IOS_CommonEditor.ShaderLibrary>().wrappedValue
        pipelineLibrary = Injected<PipelineLibrary>().wrappedValue
        mVertexDescriptorLibrary = Injected<MVertexDescriptorLibrary>().wrappedValue
        
        shaderLibrary.initialise(logger: AppPackageLogger())
        mVertexDescriptorLibrary.initialise()
        pipelineLibrary.initialise(logger: AppPackageLogger())
        
        
        
        
        return true
    }
    
    // Example: Handle background or notification logic here if needed
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("📱 App will enter foreground")
    }
}



//@main
//struct FlyerDemoApp: App {
//    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    
//    var body: some Scene {
//        WindowGroup {
////            ContentView()
//            //            RootViewControllerWrapper()
//        }
//    }
//}

//struct RootViewControllerWrapper: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UINavigationController {
//        let contentVC = UIHostingController(rootView: ContentView())
//        contentVC.title = "Home"
//
//        let nav = UINavigationController(rootViewController: contentVC)
//        nav.navigationBar.isHidden = false
//        nav.navigationBar.prefersLargeTitles = false
//        return nav
//    }
//
//    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
//}

class DatabaseManager: NSObject {
    
    private let databaseFileName = "DESIGN_DB.db" // "LOGOMAKER_DB"
    private var databasePath: String!
    static let shared: DatabaseManager = DatabaseManager()
    
    func configure() {
        self.inetilizeDataBasePath()
        DBManager.createCopyOfDatabaseIfNeeded()
    }
    
    private func inetilizeDataBasePath() {
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        databasePath = documentsDirectory.appending("/\(databaseFileName)")
    }
}

class DiagnosticHandler: DiagnosticDelegate{
    
    static var shared = DiagnosticHandler()
    
    func getPurchaseHistory() -> String {
        
        var string = "\n"
        string += "\(PersistentStorage.getPurchaseHistory())\n"
        return string
    }
    
    func crashAlert(title: String, message: String, with reportZip: URL) {
//        if let vc = UIApplication.shared.keyWindowPresentedController{
            self.showAlert_sendReport { onCancel in
                UserDefaults.standard.set("FALSE", forKey: "SEND_CRASH_REPORT_")
                //            cleanUpCrashReportData()
            } completionForSend: { sendReport in
                DispatchQueue.main.async {
                    //  onSendReport(reportTitle: text)
                    //                self.sendCrashReportMail(delegate: self)
//                    if ShareDirectViewModel().myShareOptionModels[5].shareOption == .Mail{
//                        ShareDirect.mailManager.sendMail(zip: reportZip, message: message, subject: title)
//                    }
//
                    MailManager.shared.sendCrashReportMail()
                    UserDefaults.standard.set("FALSE", forKey: "SEND_CRASH_REPORT_")
                    
                }
            }
//        }
    }
    
    func crashAlertDidFailed() {
        printLog("Failed")
    }
    
    func getInAppKeys() -> inAPpKeysDict {
        [
         "Monthly": "isMonthlyUser",
         "Yearly" : "isYearlyUser"
        ]
    }
    
    func getDeveloeprAccountName() -> String {
        return  "Simply Entertaining LLC"
    }
    
    func getCustomDiagnosticsIfAny() -> [DiagnosticsReporting] {
        [DiagnosticsReporting]()
    }
    
    func showAlert_sendReport(image: UIImage? = nil, completionForSkip: @escaping (_ onCancel: Bool) -> (), completionForSend: @escaping (_ sendReport: Bool) -> ()) {
        let alertController = UIAlertController(title: "SEND_CRASH_REPORT_".translate(),
                                                message: "Send_Crash_BODY_".translate(),
                                                preferredStyle: .alert)
        
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            alertController.view.addSubview(imageView)
            
            // Layout constraints for the image view (adjust as needed)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20),
                imageView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        // Send Report Action
        let sendReportAction = UIAlertAction(title: "Send_Report_".translate(), style: .default) { _ in
            completionForSend(true)
        }
        alertController.addAction(sendReportAction)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "_Cancel".translate(), style: .cancel) { _ in
            completionForSkip(true)
        }
        alertController.addAction(cancelAction)
        
        // Present the UIAlertController
        if let rootViewController = UIApplication.shared.keyWindowPresentedController?.children.first {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
