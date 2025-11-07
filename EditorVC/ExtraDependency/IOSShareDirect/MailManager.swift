//
//  MailManager.swift
//  IOSShareDirect
//
//  Created by JD on 8/11/20.
//

import UIKit
import MessageUI
//import IOS_CommonUtil
import IOS_CommonUtilSPM
import IOS_DiagnosticsSPM

public protocol MailDelegate : AnyObject {
    func presentMail( _ mailControlller : MFMailComposeViewController ,with error : SwiftError?)
    func sentMail( _ mailControlller : MFMailComposeViewController ,didFinishWithResult result: MFMailComposeResult, error: SwiftError?)
}

public  class MailManager  : NSObject, MFMailComposeViewControllerDelegate {
    
    static var shared = MailManager()
    
    override init() {
         
    }
    
  private  var fileType : FileTypes?
    public var appName :String = ""//AppName
    public var supportEmail:String = ""
  private  var attachmentData : Data?
    var mailComposer = MFMailComposeViewController()
    public weak var delegate : MailDelegate?
    
    public func sendMail(image:UIImage, fileName : String = "image"  , message: String? = nil , subject: String? = nil ){
        fileType = .Image
        attachmentData = getData(image: image)

        DispatchQueue.main.async { [self] in
            send(fileName: fileName, message: message, subject: subject)
        }
    }
    public func sendMailNoAttachments(message: String? = nil , subject: String? = nil, isHtml: Bool = false){
        fileType = .Image

        DispatchQueue.main.async { [self] in
            
            send(fileName: "", message: message, subject: subject, isHtml: isHtml)
        }
    }
   public func sendMail(video:URL , fileName : String = "video" , message: String? = nil , subject: String? = nil) {
        fileType = .Video
        attachmentData = getData(videoOrAudio: video)

       DispatchQueue.main.async { [self] in
           
           send(fileName: fileName, message: message, subject: subject)
       }

    }
    
   public func sendMail(zip:URL , fileName : String = "compressed" , message: String? = nil , subject: String? = nil) {
        fileType = .zip
        attachmentData = getData(videoOrAudio: zip)

       DispatchQueue.main.async { [self] in
           
           send(fileName: fileName, message: message, subject: subject)
       }

    }
    
    private func send(fileName: String , message: String? = nil , subject: String? = nil, isHtml: Bool = false) {
        mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        //Check to see the device can send email.
        if( MFMailComposeViewController.canSendMail() ) {
            
            mailComposer.mailComposeDelegate = self
            var message_ = "Thank you for choosing Ace Logo Maker" //"\(appName) " + "\(Bundle.main.versionNumber!) \(fileName)"
            if message != nil {
                message_ = message!
            }
            var subj = ""//"\(fileName) Share Via \(appName)"
            if subject != nil {
                subj = subject!
            }
         //   Set the subject and message of the email
            if supportEmail != "" {
            mailComposer.setToRecipients([supportEmail])
            }
            mailComposer.setSubject(subj)
            mailComposer.setMessageBody("\(message_)", isHTML: isHtml)
            addAttachment(controller: mailComposer, fileName: fileName)
            presentMail(mailComposer, with: nil)
            
        }else{
            presentMail(mailComposer, with: SwiftError.applicationMessage(.AppNotInstalled))
        }
    }
    
   private func addAttachment(controller : MFMailComposeViewController , fileName : String) {
        if let data = attachmentData {
        switch fileType {
        case .Image :
            controller.addAttachmentData(data, mimeType: "image/png", fileName: fileName + ".png")
            
        case .Video :
        controller.addAttachmentData(data, mimeType: "mp4", fileName: fileName + ".mp4")
            
        case .zip :
        controller.addAttachmentData(data as Data, mimeType: "application/zip", fileName: fileName+".zip")
//        case .Audio :
//        controller.addAttachmentData(data, mimeType: "wav", fileName: fileName + ".wav")

        default : break
        }
        }
    }
    

    public func mailComposeController(_ controller: MFMailComposeViewController,
                          didFinishWith result: MFMailComposeResult,
                          error: Swift.Error?) {
        DispatchQueue.main.async { [self] in
            sentMail(controller, didFinishWithResult: result, error: .none)
        }

     }
    
    
    public func sendReportMail(subject:String = "Report - Cannot Read Media",message:String , supportMail:String , attachmentInZip:URL? = nil ) {
        let subj = appName + " " + Bundle.main.versionNumber!  + " " + subject
        if attachmentInZip != nil {
        sendMail(zip: attachmentInZip! ,fileName: "file" ,message : message ,subject :  subj)
        }else{
            sendMailNoAttachments(message:message,subject:subject)
        }
    }
    
    func sendSuggestionMail(){
        sendMailWithDiagnostics(format: StandardMailFormat.gotSuggestion)

    }
    func askForHelpMail(){
        sendMailWithDiagnostics(format: StandardMailFormat.askForHelp)

    }
    func reportABugMail(){
        sendMailWithDiagnostics(format: StandardMailFormat.reportABug)

    }
    func sendCrashReportMail(){
        sendMailWithDiagnostics(format: StandardMailFormat.shareCrashReport)
    }
    
    func sendErrorReportMail() {
        sendMailWithDiagnostics(format: StandardMailFormat.shareErrorReport)
    }
    func sendMediaReadErrorReportMail() {
        sendMailWithDiagnostics(format: StandardMailFormat.MediaReadErrorReport)
    }
    
    func requestForMoreTemplates(category: String){
        sendMailWithDiagnostics(format: StandardMailFormat.customMailFormat(subject: "Request For Templates", message: "Request for more \(category) templates"))
    }

    
    public func presentMail(_ mailControlller: MFMailComposeViewController, with error: SwiftError?) {
        print("Mail Present - ",error?.info.message ?? "No Error")
        IOSLoader.stopLoader()

        if let error = error {
//            Loaf(error.info.message!, sender: self).show()
            print("error sharing to Mails")
            let newDrop = Drop(
                title: "Failure_".translate(),
                subtitle: "\(error.info.message ?? "App Not Installed")".translate(),
                icon: nil,
                action: .init(icon: nil, handler: {
                    print("Drop tapped")
                    Drops.hideCurrent()
                }),
                position: .top,
                duration: 2.0
            )
            Drops.show(newDrop)
            
        }else{
            if let vc =  UIApplication.shared.keyWindowPresentedController {
                vc.present( mailControlller , animated: true, completion: nil)
            }
//        present(mailControlller, animated: true,completion: nil)
        }
    }
    
    public func sentMail(_ mailControlller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: SwiftError?) {
    
        print("Mail Finish - ",error?.info.message ?? "No Error")
        mailControlller.dismiss(animated: true) {
            IOSLoader.stopLoader()
            
            switch result{
                
            case .cancelled:
//                self.feedbackError = .failure("Email composition cancelled")
                let newDrop = Drop(
                    title: "Failure_".translate(),
                    subtitle: "Email_composition_cancelled".translate(),
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
            case .saved:
//                self.feedbackError = .success("Email saved as draft")
                let newDrop = Drop(
                    title: "Success_".translate(),
                    subtitle: "Email_saved_as_draft".translate(),
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
            case .sent:
//                self.feedbackError = .success("Email sent successfully")
                let newDrop = Drop(
                    title: "Success_".translate(),
                    subtitle: "Email_sent_successfully".translate(),
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
            case .failed:
//                self.feedbackError = .failure("Email sending failed")
                let newDrop = Drop(
                    title: "Failure_".translate(),
                    subtitle: "Email_sending_failed".translate(),
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
                
            default:
//                self.feedbackError = .failure("Unknown error occurred")
                let newDrop = Drop(
                    title: "Failure_".translate(),
                    subtitle: "Unknown_error_occurred".translate(),
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
            }
            
        }
    }
    
    
  

    
    public func sendMailWithDiagnostics(format:MailFormat){
        DiagnosticManager.shared.getDiagnosticsReport { result in
            switch result {
            case .success(let success):
                let name = "DReport_\(Bundle.appDisplayName)_\(self.getNewDate())"


                self.sendMail(url: success, fileName: name, subject:format.subject, bodyMsj: format.message)
            case .failure(let failure):
                self.sendMailNoAttachments()
            }
        }
        
        
    }
    
    func sendMail(url:URL , fileName:String , subject:String , bodyMsj : String) -> SwiftError?{
        
//        ShareDirect.mailManager.delegate = delegate
        //ShareDirect.mailManager.supportEmail = /*App.info.Support__Email*/"psma.satish@gmail.com"
#if DEBUG
        ShareDirect.mailManager.supportEmail = "jd.mobisoft@gmail.com"
#else
        ShareDirect.mailManager.supportEmail = "help.simplyentertaining@gmail.com"
#endif
        ShareDirect.mailManager.sendMail(zip:url, fileName: fileName, message: bodyMsj, subject:subject)

    return nil
}
    
    func getNewDate()->String {
        return Date().currentDateAndTime()
    }
    
    
}

public struct MailFormat{
    var subject : String
    var message : String
}

public struct StandardMailFormat {
    
//    static var imageFileName : String {
//           return "AWM_\(getNewDate())"
//    }
    
    static  let message_header = ""// ------------------------- \n " + deviceDetails() + " \n"

    static  let message_footer = "We_Will_Get_Back_To_You_".translate() + " \n -------------------------"
    
    static  let subjectFooter =  " : " + Bundle.appDisplayName/*App.info.Display__Name*/ + " " + Bundle.appVersion + "(\(Bundle.appBuildNumber))"
    
    static  var gotSuggestion : MailFormat = MailFormat(subject: "Suggestion_".translate() + subjectFooter,
                                        message: message_header + "Suggestion_Mail_Body_".translate() + message_footer
                                        )
    static var askForHelp : MailFormat = MailFormat(subject: "Need_Help".translate() + subjectFooter,
                                     message: message_header + "Need_Help_Mail_Body_".translate() + message_footer
                                   )
    static var reportABug : MailFormat = MailFormat(subject: "Report_Bug".translate() + subjectFooter,
                                            message: message_header + "Bug_Mail_Body_".translate() + message_footer
                                     )
 
    static var shareCrashReport : MailFormat = MailFormat(subject: "Crash_Report".translate() + subjectFooter,
                                                  message: message_header + "Error_Mail_Body_".translate() + "Crash_Report_Mail_Body_".translate() + message_footer
                                           )
    static var shareErrorReport : MailFormat  = MailFormat(subject: "Error_Report".translate() + subjectFooter,
                                                   message: message_header + "Error_Mail_Body_".translate() + "Error_Report_Mail_Body_".translate() + message_footer
                                            )
    static var MediaReadErrorReport : MailFormat  = MailFormat(subject: "Media_Read_Error".translate() + subjectFooter,
                                                   message: message_header + "Error_Mail_Body_".translate() + "Error_Report_Mail_Body_".translate() + message_footer
                                            )
    
    static func customMailFormat(subject:String,message:String) -> MailFormat {
        return MailFormat(subject: subject + subjectFooter,
                                                       message: message_header + message  + message_footer
                                                )
         
    }
    
    


}

extension Bundle {
//    static var appName: String {
//        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//    }

    static var appDisplayName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }

    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    static var appBuildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

extension Date {
   func currentDateAndTime(format:String? = "YYYY:MM:dd HH:mm:ss") -> String {
       let formatter = DateFormatter()
       formatter.timeZone = TimeZone.current
    formatter.dateFormat = format
    return formatter.string(from: self)
    }

}
