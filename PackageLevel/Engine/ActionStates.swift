//
//  ActionsModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 13/03/24.
//

import Foundation
import UIKit

enum scrollViewDirection{
    case right
    case left
}

class MultiSelectedArrayObject : Equatable, ObservableObject{
    static func == (lhs: MultiSelectedArrayObject, rhs: MultiSelectedArrayObject) -> Bool {
       return lhs.id == rhs.id
    }
    
    var id: Int
    var thumbImage: UIImage?
    var orderID : Int = 0
    @Published var isEdited : Bool = false
    
    init(id: Int, thumbImage: UIImage?, orderID: Int = 0, isEdited : Bool = false) {
        self.id = id
        self.thumbImage = thumbImage
        self.orderID = orderID
        self.isEdited = false
    }
}

enum ZoomEditView{
    case scaleDown
    case scaleUp
}


class ActionStates: ObservableObject {
    @Published var personalizedState : Bool = false
    @Published var didPersonalizeTapped : Bool = false
    @Published var didPersonalizeTappedFromSaveNEdit : Bool = false
    @Published var zoomEditView : ZoomEditView = .scaleUp
    
    var logger: PackageLogger?
    var actionStateConfig: EngineConfiguration?
    
    func setPackageLogger(logger: PackageLogger, actionStateConfig: EngineConfiguration){
        self.logger = logger
        self.actionStateConfig = actionStateConfig
        snappingMode = getSnappingValue()
    }
    
    func getSnappingValue() -> SnappingMode{
        if actionStateConfig?.getSnappingMode == 0{
            return .off
        }
        else if actionStateConfig?.getSnappingMode == 1{
            return .basic
        }
        else if actionStateConfig?.getSnappingMode == 2{
            return .advanced
        }
        return .off
    }
    
    init() {
//        snappingMode = getSnappingValue()
    }
    
    deinit {
        logger?.printLog("de-init \(self)")
    }
    
    @Published var showPlayPauseButton : Bool = true
    @Published var showMusicPickerRoundButton : Bool = true
    @Published var ShowMusicSlider : Bool = true

    
    
    
    // MARK: - Template/Design State
    @Published var zoomEnable: Bool = false
    @Published var isTextInUpdateMode: Bool = false
    @Published var thumbUpdateId: Int = 0
    @Published var isTextNotValid = false
    @Published var lastSelectedBGContent: AnyBGContent?
    @Published var lastSelctedOverlayContent: AnyBGContent?
    @Published var lastSelectedFilter: FiltersEnum = .none
    @Published var isCurrentModelDeleted: Bool = false
    @Published var shouldRefreshOnAddComponent: Bool = false
    @Published var lastSelectedCategoryIndexIN: Int = 0
    @Published var lastSelectedCategoryIndexOUT: Int = 0
    @Published var lastSelectedCategoryIndexLOOP: Int = 0
    @Published var lastSelectedFont: String = "Default"
    @Published var lastSelectedFlipH: Bool = false
    @Published var lastSelectedFlipV: Bool = false
    @Published var lastSelectedBGColor: AnyBGContent?
  //  @Published var parentEditState: Bool = false
    
    // MARK: - Page-Level State
    @Published var pageSize: CGSize = CGSize(width: 100, height: 100)
    @Published var scrollOffset: CGFloat = 0
    @Published var pagerScrolledOff: Bool = false
    @Published var currentPage: Int = 0
    @Published var deletedPageID: Int = 0
    @Published var selectedPageID: Int = 0
    @Published var pageModelArray: [MultiSelectedArrayObject] = []
    @Published var updatePageArray: Bool = false
    @Published var updateThumb: Bool = false
    @Published var updatePageAndParentThumb: Bool = false
    @Published var currentThumbTime: Float = 0.0

    // MARK: - Component-Level State
    @Published var addNewText: String = "Enter Your Text"
    @Published var updatedText: String = ""
    @Published var fontChanged: String = ""
    @Published var addImage: ImageModel? = nil
    @Published var replaceSticker: ImageModel? = nil
    @Published var addNewpage: AnyBGContent = BGColor(bgColor: .blue)
    
    // MARK: - Action Tracking State
    @Published var didUseMeTapped: Bool = false
    @Published var didPurchasedTapped: Bool = false
    @Published var didPreviewTapped: Bool = false
    @Published var didGroupTapped: Bool = false
    @Published var didCancelTapped: Bool = false
    @Published var didWatchAdsTapped: Bool = false
    @Published var didGetPremiumTapped: Bool = false
    @Published var didCloseTabbarTapped: Bool = false
    @Published var didUngroupTapped: Bool = false
    @Published var didLayersTapped: Bool = false
    @Published var multiModeSelected: Bool = false
    @Published var exportPageTapped: Bool = false
    @Published var snappingMode: SnappingMode = .basic
  //  @Published var snappingOff: Bool = false
//    @Published var timelineHide: Bool = false
    @Published var timelineShow: Bool = false
    @Published var moveModel: MoveModel? = nil

    // MARK: - Music Control State
    @Published var musicAdded: Bool = false
    @Published var musicUpdate: MusicInfo?
    @Published var addNewMusicModel: MusicModel = MusicModel()
    @Published var deleteMusic: MusicInfo = MusicInfo()
    @Published var replaceMusic: MusicModel = MusicModel()
    @Published var didMusicPlayOnEditor: Bool = false
    @Published var currentMusic: MusicInfo?
    
    // MARK: - Multi-Select State
    @Published var addItemToMultiSelect: Int = 0
    @Published var removeItemFromMultiSelect: Int = 0
    @Published var multiSelectedItems: [BaseModel] = [BaseModel]()
    @Published var multiUnSelectItems: [BaseModel] = [BaseModel]()
    @Published var showGroupButton: Bool = false

    // MARK: - Ratio/Layout State
    @Published var didRatioSelected: DBRatioTableModel = DBRatioTableModel()
    @Published var currentRatio: Int = 0
    @Published var copyModel: Int = 0
    @Published var pasteModel: Bool = false
    @Published var duplicateModel: Int = 0
    @Published var hasOnce: Bool = false
    @Published var hasOnceForScene: Bool = false

    // MARK: - Editor Visibility State
    @Published var showNavgiationItems: Bool = false
    @Published var showMultiSelectNavItems: Bool = false
    @Published var showThumbnailNavItems: Bool = false
   // @Published var hideTimeLine: Bool = false
    @Published var isScrollViewShowOrNot: Bool = false

    // MARK: - Mute and Audio Settings State
    @Published var isMute: Bool = false

    // MARK: - Animation State
    @Published var lastSelectedAnimType: String = "IN"
    @Published var lastSelectedCategoryId: Int = 3
    
    // MARK: - Page Transitions/Duration State
    @Published var didShowDurationButtonCliked: Bool = false

    // MARK: - Last Selected States
    @Published var lastSelectedShadowButton: ShadowType = .direction
    @Published var lastSelectedBGButton: BGPanelType = .color
    @Published var lastSelectedFormatButton: HTextGravity = .Center
    @Published var lastSelectedTextTab: String = ""
    @Published var lastSelectedBGTab: String = ""
    @Published var lastSelectedColor: AnyColorFilter?
    @Published var lastSelctedBGContent: AnyBGContent?

    @Published var didEditTextClicked : Bool = false
    @Published var directionOfScrollView : scrollViewDirection = .left

    @Published var isNudgeAllowed: Bool = false
}
