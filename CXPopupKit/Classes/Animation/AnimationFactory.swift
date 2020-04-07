import UIKit

class AnimationFactory {
    static func animation(_ style: CXAnimationType,
                          _ duration: CXAnimationDuration,
                          _ transition: CXAnimationTransition,
                          _ presenting: UIViewController) -> UIViewControllerAnimatedTransitioning {
        switch style {
        case .basic:
            return CXBasicAnimation(presenting, duration, transition)
        case .fade:
            return CXFadeAnimation(presenting, duration, transition)
        case .bounce:
            return CXBounceAnimation(presenting, duration, transition)
        case .zoom:
            return CXZoomAnimation(presenting, duration, transition)
        case .pop:
            return CXPopAnimation(presenting, duration, transition)
        case .custom(let animator):
            return animator
        }
    }
}
