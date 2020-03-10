import UIKit

public class CXPopupStyle: NSObject {
    /*Dimension*/
    public var width: CXEdge = .full
    public var height: CXEdge = .full
    public var position: CXPosition = .center
    public var safeAreaPolicy: CXSafeAreaPolicy = .system
    
    /*Shadow*/
    public var isShadowEnabled: Bool = true
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.8
    public var shadowRadius: CGFloat = 13.0
    public var shadowOffset: CGSize = CGSize(width: 0, height: 6.0)
    
    /*UI*/
    public var backgroundColor: UIColor = .clear
    public var maskBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.8)
    public var maskBackgroundAlpha: CGFloat = 1.0
    public var cornerRadius: CGFloat = 4.0

    /*Behavior*/
    public var shouldDismissOnBackgroundTap: Bool = true
    
    // Animation
    public var animationStyle: CXAnimationStyle = .basic
    public var animationDuration: CXAnimationDuration = CXAnimationDuration(0.5)
    public var animationTransition: CXAnimationTransition = CXAnimationTransition(.center)
}
