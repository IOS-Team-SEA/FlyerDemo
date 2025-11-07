//
//  CustomNavigation.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 22/01/25.
//

import UIKit

protocol NavAction{
    func onBackPressed()
}

class MyNavigationController: UINavigationController {
//    @Injected var analyticsLogger : AnalyticsLogger
//    override var navigationBar: UINavigationBar = MyNavBar()
    
    var skipBackInterception: Bool = false
    
    
    var needBackAlert  : Bool  {
        if skipBackInterception {
            return false
        }
//        if visibleViewController is NavAction {
//            return true
//        }
//        return false
        return visibleViewController is NavAction
    }
    private let navigationControllerDelegate = RootNavigationControllerDelegate()

    override func viewDidLoad() {
        self.delegate = navigationControllerDelegate
        navigationBar.tintColor = ThemeManager.shared.accentColor
        navigationBar.backItem?.backButtonTitle = ""
    }
   
    var onBackButton : (()->())?
   
    func goBack(){
        setTransitionType(transitionType: .FromBottom)
        super.popViewController(animated: true)
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print("push called")
        super.setTransitionType(transitionType: .FromBottom)
        super.pushViewController(viewController, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        print("pop called")
        if needBackAlert {
            
            if  let currentVC = visibleViewController as? NavAction {
                currentVC.onBackPressed()
                return nil
            }
        }
        super.setTransitionType(transitionType: .FromBottom)
        return super.popViewController(animated: true)
    
    }
    
    
    
}


enum HSTransitionType {
    case Standard, Fade, FromBottom
}

class RootNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    /** Set this if you want a custom animation when Pushing or Popping.
    It will be reset to .Standard after the operation is complete.
    It is more easily set on the UINavigationController itself, via the +Transitions extension. */
    var transitionType: HSTransitionType = .FromBottom
    

    // MARK: - UINavigationControllerDelegate Functions
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.transitionType == .Standard {
            return nil
        }
        let animator = TransitionAnimator(type: self.transitionType, operation: operation)
        self.transitionType = .FromBottom
        return animator
    }
    
}
extension UINavigationController {
    
    func transitionType() -> HSTransitionType {
        if let delegate = self.delegate as? RootNavigationControllerDelegate {
            return delegate.transitionType
        }
        return .FromBottom
    }
    
    func setTransitionType(transitionType: HSTransitionType) {
        if let delegate = self.delegate as? RootNavigationControllerDelegate {
            delegate.transitionType = transitionType
        }
    }
    
}

class BottomUpTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func animateTransition(using context: UIViewControllerContextTransitioning) {
        let container = context.containerView

        let fromVC = context.viewController(forKey: .from)!
        let toVC = context.viewController(forKey: .to)!

        let finalFrame = context.finalFrame(for: toVC)
        let duration = transitionDuration(using: context)

        if isPresenting {
            toVC.view.frame = finalFrame.offsetBy(dx: 0, dy: container.frame.height)
            container.addSubview(toVC.view)

            UIView.animate(withDuration: duration, animations: {
                toVC.view.frame = finalFrame
            }, completion: { finished in
                context.completeTransition(finished)
            })
        } else {
            container.insertSubview(toVC.view, belowSubview: fromVC.view)
            UIView.animate(withDuration: duration, animations: {
                fromVC.view.frame = fromVC.view.frame.offsetBy(dx: 0, dy: container.frame.height)
            }, completion: { finished in
                context.completeTransition(finished)
            })
        }
    }
}
class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    private let type: HSTransitionType
    private let operation: UINavigationController.Operation
    
    init(type: HSTransitionType, operation: UINavigationController.Operation) {
        self.type = type
        self.operation = operation
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning Functions
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let completion = {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        if !transitionContext.isAnimated {
            completion()
            return()
        }
        
        let toView = transitionContext.viewController(forKey: .to)!.view!
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        
        let containerView = transitionContext.containerView
        
       
         
            containerView.addSubview(toView)
             
         
        
        switch self.operation {
        case .push:
            self.performPushAnimation(toView: toView, completion: completion)
        case .pop:
            self.performPopAnimation(fromView: fromView, completion: completion)
        default:
            completion()
            return()
        }
    }
    
    // MARK: - Custom Animation Functions
    
    private func performPushAnimation(toView: UIView, completion: @escaping () -> ()) {
        var frame = toView.frame
        switch self.type {
        case .Standard:
            frame.origin.x += frame.size.width
        case .Fade:
            toView.alpha = 0
        case .FromBottom:
            frame.origin.y += frame.size.height
        }
        toView.frame = frame
        
        UIView.animate(withDuration: self.duration, animations: {
            
            switch self.type {
            case .Standard:
                frame.origin.x -= frame.size.width
            case .Fade:
                toView.alpha = 1
            case .FromBottom:
                frame.origin.y -= frame.size.height
            }
            toView.frame = frame
            
            }) { (finished: Bool) -> Void in
                completion()
        }
    }
    
    private func performPopAnimation(fromView: UIView, completion: @escaping () -> ()) {
        fromView.superview?.bringSubviewToFront(fromView)
        var frame = fromView.frame
        UIView.animate(withDuration: self.duration, animations: {
            
            switch self.type {
            case .Standard:
                frame.origin.x += frame.size.width
            case .Fade:
                fromView.alpha = 0
            case .FromBottom:
                frame.origin.y += frame.size.height
            }
            fromView.frame = frame
            
            }) { (finished: Bool) -> Void in
                completion()
        }
    }
    
}
