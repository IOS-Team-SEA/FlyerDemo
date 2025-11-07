//
//  AppRouter.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 09/05/25.
//


import SwiftUI

enum AppSheetType: SheetRepresentable {

    case WhatsNew
    case SideMenu
    case Rating
    case PremiumPage
    
    var id: String {
        switch self {
        case .WhatsNew: return "WhateNew"
        case .SideMenu: return "SideMenu"
        case .Rating: return "Rating"
        case .PremiumPage: return "Premium Page"

        }
    }

}

enum AppFullScreenSheetType: SheetRepresentable {

    case InvitationResponseViaLink(code: String)
    case PremiumPage
    case RatingPage

    var id: String {
        switch self {
        case .InvitationResponseViaLink(let code): return "\(code)"
        case .RatingPage: return "RatingPage"
        case .PremiumPage: return "PremiumPage"

        }
    }

}

enum TemplateContext{
    case chooseTemplate
    case home
}

enum LaunchScreenRoute: Hashable {
    case splash
    case onboarding
    case loginFlow
    case content
  
}

enum AppRoute : Hashable {
    case home
    case trendingDetail
    case exploreDetail
    case saved
    case draft
 
}

//enum OverlayRoute {
//    case loginFlow(path: LoginStartedAction, templateId: Int? = nil)
//    case chooseTemplate
////    case createEvent(eventId: Int, templateId: Int, path: CreateEventStartedAction)
//}

//extension OverlayRoute: Equatable {
//    static func == (lhs: OverlayRoute, rhs: OverlayRoute) -> Bool {
//        switch (lhs, rhs) {
//        case let (.loginFlow(lp, _), .loginFlow(rp, _)):
//            return lp == rp
//        case (.chooseTemplate, .chooseTemplate):
//            return true
////        case let (.createEvent(le, lt, _), .createEvent(re, rt, _)):
////            return le == re && lt == rt
//        default:
//            return false
//        }
//    }
//}

//enum NotificationRoute: Hashable{
//    case rsvpRespond(eventId: Int)
//    case guestListView(eventId: Int)
//    case inviteResponse(code: String)
//    case loginFlow(path: LoginStartedAction, code: String)
//    
//    var routerName : String {
//        switch self {
//        case .rsvpRespond(_):
//            return "EditResponseView"
//        case .guestListView(_):
//            return "GuestView"
//        case .inviteResponse(_):
//            return "OpenInviteResponse"
//        case .loginFlow(let path, _):
//            return "Login"
//        }
//    }
//}

//enum PreviewTemplateRoute {
//    case metalPreviewForRespondPage(templateId: Int, thumbImage: UIImage, eventName: String)
//
//    case metalPreview(templateId: Int, thumbImage: UIImage, eventName: String)
//    case templatePreview(templateId: Int, thumbImage: UIImage, type: TemplatePreviewState)
//    case personalisePreview(templateId: Int, thumbImage: UIImage, path: PersonaliseStartedAction)
//
//   // case rsvpRespondPreview(eventModel: EventModel)
//}

//extension PreviewTemplateRoute: Equatable {
//    static func == (lhs: PreviewTemplateRoute, rhs: PreviewTemplateRoute) -> Bool {
//        switch (lhs, rhs) {
//        case let (.metalPreview(lp, _, _), .metalPreview(rp, _, _)):
//            return lp == rp
//        case let (.templatePreview(lt,_,_), .templatePreview(rt,_,_)):
//            return lt == rt
//        case let (.personalisePreview(le,_,_), .personalisePreview(re,_,_)):
//            return le == re
////        case let (.rsvpRespondPreview(le), .rsvpRespondPreview(re)):
////            return le == re
//        default:
//            return false
//        }
//    }
//}

enum RefreshKey: Hashable {
    case invites
    case events
    case eventDetail(Int)
    case guestList
    
    // Add more like: case userProfile, home, explore, etc.
}

@MainActor
final class AppRouter : BaseRouter<AppRoute,AppSheetType,AppFullScreenSheetType> , HomeScreenProtocol {
    func showPreview(templateID: Int, previewState: TemplatePreviewState, thumbImage: UIImage, completion: ((EditorExitResult) -> ())?) {
        
    }
    
    func templateID(templateID: Int, editorLoadingState: EditorLoadingState, thumbImage: UIImage, completion: ((EditorExitResult) -> ())?) {
        logError("This is Pending")
        rootController?.templateID(templateID: templateID, editorLoadingState: editorLoadingState, thumbImage: thumbImage, completion: completion)
    }
    
    func redirectToEditorPage(templateID: Int, editorLoadingState: EditorLoadingState, thumbImage: UIImage, completion: ((EditorExitResult) -> ())?) {
        logError("This is Pending")
        rootController?.redirectToEditorPage(templateID: templateID, editorLoadingState: editorLoadingState, thumbImage: thumbImage, completion: completion)

    }
    
    
//    @Published  var  tabSelection : TabBarItemsCase = .home
    
//    @Published var overlayScreeen : OverlayRoute?
    @Published var templateContext: TemplateContext = .home
//    @Published var overlayMetalScreen: PreviewTemplateRoute?

    @Published var isEditorPushed: Bool = false
    
    
    @Published var refreshEventsView: UUID? = nil
    @Published var refreshEventDetailsView: UUID? = nil
    @Published var refreshEventDetailsViewThumb: UUID? = nil
    @Published var refreshInvites: UUID? = nil
    @Published var refreshGuestList: UUID? = nil
//    @Published var chooseTemplateCreateEventAction: CreateEventStartedAction = .eventsTab
    

//    func switchTo(tab: TabBarItemsCase ) {
//        if tabSelection != tab {
//            tabSelection = tab
//        }
//        switch tab {
//        case .home:
//            break
//        case .myInvitations:
//            break
//        }
//    }
    
    func triggerRefreshEvents() {
        refreshEventsView = UUID()
    }
    
    func triggerRefreshEventDetails() {
        refreshEventDetailsView = UUID()
    }
    
    func triggerRefreshEventDetailsThumb() {
        refreshEventDetailsViewThumb = UUID()
    }
    
    func triggerRefreshInvites() {
        refreshInvites = UUID()
    }
   
    
    func triggerRefreshGuestList() {
        refreshGuestList = UUID()
    }
    
    
    weak var editorDelegate: EditorVCDelegate?
    
//    func showOverlayScreen(_ route: OverlayRoute) {
//        overlayScreeen = route
//    }
//    func dismissOverlayScreen() {
//        overlayScreeen = nil
//    }
    
    weak var rootController : HomeScreenProtocol?
    
    @Published var currentScreen : LaunchScreenRoute = .splash
    @Published var hideBlast: Bool = true

    @Published var pendingInvitationCode: String? = nil

    
    func popEditorIfAvailable() {
        editorDelegate?.popEditorIfAvailable()
    }
}


struct InvitationWrapper: Identifiable {
    let id: String
}

protocol HomeScreenProtocol : AnyObject {
    func templateID(templateID : Int, editorLoadingState : EditorLoadingState, thumbImage: UIImage, completion: ((EditorExitResult) -> ())?)
    func redirectToEditorPage(templateID: Int, editorLoadingState: EditorLoadingState, thumbImage: UIImage, completion: ((EditorExitResult) -> ())?)
    
//    func showPreview(templateID : Int, previewState : TemplatePreviewState , thumbImage: UIImage, completion: ((EditorExitResult) -> ())?)

    
}
