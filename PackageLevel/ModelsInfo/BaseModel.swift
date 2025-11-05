//
//  BaseModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 28/03/24.
//

import Foundation
import UIKit

class BaseModel :ObservableObject, BaseModelProtocol{
    
    @Published var filterType: FiltersEnum = .none
    
    @Published var colorAdjustmentType: String = "brightness"
    
    @Published var brightnessIntensity: Float = 0
    
    @Published var contrastIntensity: Float = 0
    
    @Published var highlightIntensity: Float = 0
    
    @Published var shadowsIntensity: Float = 0
    
    @Published var saturationIntensity: Float = 0
    
    @Published var vibranceIntensity: Float = 0
    
    @Published var sharpnessIntensity: Float = 0
    
    @Published var warmthIntensity: Float = 0
    
    @Published var tintIntensity: Float = 0
    
    @Published var hasMask: Bool = false
    
    @Published var maskShape: String = ""
    
    var size: CGSize = .zero
    
    var center: CGPoint = .zero
    
    @Published var endFilterType: FiltersEnum = .none
    
    @Published var beginBrightnessIntensity: Float = 0
    @Published var endBrightnessIntensity: Float = 0
    
    @Published var beginContrastIntensity: Float = 0
    @Published var endContrastIntensity: Float = 0
    
    @Published var beginHighlightIntensity: Float = 0
    @Published var endHighlightIntensity: Float = 0
    
    @Published var beginShadowsIntensity: Float = 0
    @Published var endShadowsIntensity: Float = 0
    
    @Published var beginSaturationIntensity: Float = 0
    @Published var endSaturationIntensity: Float = 0
    
    @Published var beginVibranceIntensity: Float = 0
    @Published var endVibranceIntensity: Float = 0
    
    @Published var beginSharpnessIntensity: Float = 0
    @Published var endSharpnessIntensity: Float = 0
    
    @Published var beginWarmthIntensity: Float = 0
    @Published var endWarmthIntensity: Float = 0
    
    @Published var beginTintIntensity: Float = 0
    @Published var endTintIntensity: Float = 0
    
    @Published var baseFrame: Frame = Frame(size: CGSize(width: 1, height: 1), center: CGPoint(x: 0.5, y: 0.5), rotation: 0.0)
    @Published var baseTimeline: StartDuration = StartDuration(startTime: 0.0, duration: 5.0)
//    @Published var endFrame:Frame = Frame(size: .zero, center: .zero, rotation: 0.0)
    
    
    
  
    var identity: String = "Basemodel"
    var depthLevel : Int = 0 {
        didSet {
            if isParent {
                updateDepthLevelForChildren()
            }
        }
    }
   
     func findNodeByID(_ nodeID: Int) -> BaseModel? {
        if self.modelId == nodeID {
            return self
        }
         return nil
    }
   
       
    
    func updateDepthLevelForChildren() { }
    
    var isParent:Bool {
        return self is ParentModel
    }
    var mainAnimationID : Int = 0
    
    @Published var inAnimation: AnimTemplateInfo = AnimTemplateInfo()
    
    @Published var inAnimationDuration: Float = 1.0
    
    @Published var outAnimation: AnimTemplateInfo = AnimTemplateInfo()
    
    @Published var outAnimationDuration: Float = 1.0
    
    @Published var loopAnimation: AnimTemplateInfo = AnimTemplateInfo()
    
    @Published var loopAnimationDuration: Float = 1.0
    
    // Opacity
    @Published var beginOpacity: Float = 0
    @Published var endOpacity: Float = 0
    
    
    // Animation
    @Published var inAnimationBeginDuration: Float = 0
    @Published var inAnimationEndDuration: Float = 1.0
    
    @Published var outAnimationBeginDuration: Float = 0
    @Published var outAnimationEndDuration: Float = 1.0
    
    @Published var loopAnimationBeginDuration: Float = 0
    @Published var loopAnimationEndDuration: Float = 1.0
//    
////    // Pos X,Y
//    @Published var beginPosX: Float = 0
//    @Published var beginPosY: Float = 0
//    @Published var endPosX: Float = 0
//    @Published var endPosY: Float = 0
    
    
//    @Published var beginSize:CGSize = .zero
//    @Published var beginCenter:CGPoint = .zero
//    @Published var endSize:CGSize = .zero
//    @Published var endCenter:CGPoint = .zero
    @Published var beginFrame:Frame = Frame(size: .zero, center: .zero, rotation: .zero)
    @Published var endFrame:Frame = Frame(size: .zero, center: .zero, rotation: .zero)
    
    @Published var beginBaseTimeline: StartDuration = StartDuration(startTime: 0.0, duration: 0.0)
    @Published var endBaseTimeline: StartDuration = StartDuration(startTime: 0.0, duration: 15.0)
//    // Color
//    @Published var startColor: UIColor = .clear
//    @Published var endColor: UIColor = .clear
    
    // new sticker added
    @Published var newStickerImageAdded: StickerModel = StickerModel()
    
//    @Published var duplicate : Bool = false
//    @Published var copy : Bool = false
//    @Published var paste : Bool = false
    
    @Published var thumbImage: UIImage? = UIImage(named: "none")!
    
    @Published var beginStartTime:Float = 0.0
    @Published var endStartTime:Float = 0.0
    
    // duration
    @Published var beginDuration: Float = 0.0
    @Published var endDuration: Float = 15.0
   
    enum UIState {
        case Selected
        case EditOn
        case Idle
    }
    
//    enum ActiveState {
//        case Active(uiState:UIState)
//        case DeActive(uiState:UIState)
//    }
    
    @Published var isActive: Bool = false
//    @Published var group : Bool = false
//    @Published var ungroup : Bool = false
    
    @Published var isLayerAtive : Bool = false
    
    
    
    
    
    
     var isSelectedForMultiSelect = false
    
    
    init(thumbImage: UIImage? = nil, isSelected: Bool = false){
        self.thumbImage = thumbImage
        self.isActive = isSelected
        
    }
    
    func setAnimation(animationModel: DBAnimationModel ) {
        
        let inAnim = DataSourceRepository.shared.fetchAnimationInfo(for: animationModel.inAnimationTemplateId)
        let outAnim = DataSourceRepository.shared.fetchAnimationInfo(for: animationModel.outAnimationTemplateId)
        let loopAnim = DataSourceRepository.shared.fetchAnimationInfo(for: animationModel.loopAnimationTemplateId)

        self.inAnimation = inAnim
        self.outAnimation = outAnim
        self.loopAnimation = loopAnim
        
        self.inAnimationDuration = animationModel.inAnimationDuration
        self.outAnimationDuration = animationModel.outAnimationDuration
        self.loopAnimationDuration = animationModel.loopAnimationDuration
        
        self.mainAnimationID = animationModel.animationId
    }
    
    
    func getAnimation() -> DBAnimationModel {
        
        return DBAnimationModel(animationId: mainAnimationID, modelId: modelId, inAnimationTemplateId: inAnimation.animationTemplateId, inAnimationDuration: inAnimationDuration, loopAnimationTemplateId: loopAnimation.animationTemplateId, loopAnimationDuration: loopAnimationDuration, outAnimationTemplateId: outAnimation.animationTemplateId, outAnimationDuration: outAnimationDuration, templateID:  templateID)
         
    }
    
//    func getBaseModel(refSize:CGSize) -> DBBaseModel {
//        return DBBaseModel(
//            filterType: filterType.rawValue,
//            brightnessIntensity: brightnessIntensity,
//            contrastIntensity: contrastIntensity,
//            highlightIntensity: highlightIntensity,
//            shadowsIntensity: shadowsIntensity,
//            saturationIntensity: saturationIntensity,
//            vibranceIntensity: vibranceIntensity,
//            sharpnessIntensity: sharpnessIntensity,
//            warmthIntensity: warmthIntensity,
//            tintIntensity: tintIntensity,
//            parentId: parentId,
//            modelId: modelId,
//            modelType: modelType.rawValue,
//            dataId: dataId,
//            posX: (baseFrame.center.x).toDouble()/refSize.width,
//            posY: (baseFrame.center.y).toDouble()/refSize.height,
//            width: (baseFrame.size.width).toDouble()/refSize.width,
//            height: (baseFrame.size.height).toDouble()/refSize.height,
//            prevAvailableWidth: (prevAvailableWidth).toDouble()/refSize.width,
//            prevAvailableHeight: (prevAvailableHeight).toDouble()/refSize.height,
//            rotation: (baseFrame.rotation).toDouble(),
//            modelOpacity: (modelOpacity).toDouble()*255.0,
//            modelFlipHorizontal: modelFlipHorizontal.toInt(),
//            modelFlipVertical: modelFlipVertical.toInt(),
//            lockStatus: lockStatus.toString(),
//            orderInParent: orderInParent,
//            bgBlurProgress: bgBlurProgress.toInt(),
//            overlayDataId: overlayDataId,
//            overlayOpacity: overlayOpacity.toInt(),
//            startTime: (baseTimeline.startTime).toDouble(),
//            duration: (baseTimeline.duration).toDouble(),
//            softDelete: softDelete.toInt(),
//            isHidden: isHidden,
//            templateID: templateID
//        )
//    }
    
        //base model
    var parentId: Int = 0
    var modelId: Int = 0
    var modelType: ContentType = .Page
    var dataId: Int = 0
    @Published var posX: Float = 0.5
    @Published var posY: Float = 0.5
    @Published var width: Float = 1.0
    @Published var height: Float = 1.0 // Neeshu : Frame : CGRect - XY Cetner ,WH - Size
    @Published var prevAvailableWidth: Float = 0.0
    @Published var prevAvailableHeight: Float = 0.0
    @Published var rotation: Float = 0
    @Published var modelOpacity: Float = 1
    @Published var modelFlipHorizontal: Bool = false
    @Published var modelFlipVertical: Bool = false
    @Published var lockStatus: Bool = false
    @Published var orderInParent: Int = 0
    @Published var bgBlurProgress: Float = 0
    @Published var overlayDataId: Int = 0
    @Published var overlayOpacity: Float = 1
    @Published var startTime: Float = 0.0
    @Published var duration: Float = 5.0
    @Published var softDelete: Bool = false
    @Published var isHidden: Bool = false
    @Published var templateID : Int = 0 //Updated by Neeshu
//    @Published var baseFrame:Frame = Frame(size: .zero, center: .zero, rotation: 0.0)
   // @Published var editState : Bool = false
    
    
    func addDefaultModel(parentModel:BaseModelProtocol,baseModel:BaseModel){
//        var model = BaseModel()
        // calculate Size
        baseModel.baseFrame.size.width = parentModel.baseFrame.size.width/2
        baseModel.baseFrame.size.height = parentModel.baseFrame.size.height/2
        baseModel.prevAvailableWidth = Float(parentModel.baseFrame.size.width/2)
        baseModel.prevAvailableHeight = Float(parentModel.baseFrame.size.height/2)
        
        // calculate Center
        
        baseModel.baseFrame.center.x = parentModel.baseFrame.size.width/2
        baseModel.baseFrame.center.y = parentModel.baseFrame.size.height/2
        // calculate Time
//        baseModel.startTime = Float(currentTime)
//        baseModel.duration = parentModel.duration - Float(currentTime)
        // calculate opacity
        
        // calculate rotation
        //model.rotation =
       
        
        baseModel.parentId = parentModel.modelId
        baseModel.templateID = parentModel.templateID
       
    }
    
    func getModelStartTime(templatehandler:TemplateHandler)-> Float{
        var startTime = self.baseTimeline.startTime
        if let parentModel = templatehandler.getModel(modelId: parentId) as? ParentModel{
            startTime += recursiveParentStartTime(model: parentModel, templatehandler: templatehandler)
        }
        
        return startTime
    }

    private func recursiveParentStartTime(model:ParentModel,templatehandler:TemplateHandler)->Float{
       if model.modelType == .Page{
           return 0
       }
        var time = model.baseTimeline.startTime
        if let parent = templatehandler.getModel(modelId: model.parentId) as? ParentModel{
            time += recursiveParentStartTime(model: parent, templatehandler: templatehandler)
        }
        return time
    }
}
