import UIKit

public class CXPopupStyle: NSObject {
    /*Dimension*/
    public var width: CXEdge = .ratio(0.8)
    public var height: CXEdge = .ratio(0.5)
    public var position: CXPosition = .center
    public var safeAreaPolicy: CXSafeAreaPolicy = .system
    
    /*Shadow*/
    public var isShadowEnabled: Bool = true
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.6
    public var shadowRadius: CGFloat = 10.0
    public var shadowOffset: CGSize = CGSize(width: 0, height: 10.0)
    
    /*UI*/
    public var backgroundColor: UIColor = .clear
    public var maskBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.8)
    public var maskBackgroundAlpha: CGFloat = 1.0
    public var cornerRadius: CGFloat = 4.0

    /*Behavior*/
    public var shouldDismissOnBackgroundTap: Bool = true
    
    // Animation
    public var animationType: CXAnimationType = .basic
    public var animationDuration: CXAnimationDuration = CXAnimationDuration(0.5)
    public var animationTransition: CXAnimationTransition = CXAnimationTransition(.center, .center)
}

public extension CXPopupStyle {
    static func style(axisX: CXAxisX) -> CXPopupStyle {
        let style = CXPopupStyle()
        style.position = CXPosition(axisX, .center)
        style.animationDuration = CXAnimationDuration(0.35, 0.067)
        style.animationType = .fade
        style.height = .full
        switch axisX {
        case .left:
            style.animationTransition = CXAnimationTransition(.right, .left)
        case .right:
            style.animationTransition = CXAnimationTransition(.left, .right)
        case .center:
            style.height = .ratio(0.5)
            style.animationType = .pop
            style.animationTransition = CXAnimationTransition(.center, .center)
        case .custom:
            fallthrough
        @unknown default:
            break
        }
        return style
    }

    static func style(axisY: CXAxisY) -> CXPopupStyle {
        let style = CXPopupStyle()
        style.position = CXPosition(.center, axisY)
        style.animationDuration = CXAnimationDuration(0.35, 0.067)
        style.animationType = .fade
        style.width = .full
        switch axisY {
        case .top:
            style.animationTransition = CXAnimationTransition(.down, .up)
        case .bottom:
            style.animationTransition = CXAnimationTransition(.up, .down)
        case .center:
            style.width = .ratio(0.5)
            style.animationTransition = CXAnimationTransition(.center, .center)
        case .custom:
            fallthrough
        @unknown default:
            break
        }
        return style
    }
}
