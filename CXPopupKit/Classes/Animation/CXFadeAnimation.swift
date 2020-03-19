import Foundation

class CXFadeAnimation: CXBasicAnimation {
    override func presenting(_ context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController(forKey: .to), let toView = context.view(forKey: .to) else {
            return
        }
        let container = context.containerView
        let toViewFinalFrame = context.finalFrame(for: toVC)
        let toViewInitialFrame = toViewFinalFrame.offsetForInitialPosition(direction: transition.`in`, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        animateInFinalFrame = toViewFinalFrame

        toView.frame = toViewInitialFrame
        toView.alpha = CXBasicAnimation.transparent
        UIView.animate(withDuration: duration, animations: {
            toView.frame = toViewFinalFrame
            toView.alpha = CXBasicAnimation.opaque
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }

    override func dismissing(_ context: UIViewControllerContextTransitioning) {
        guard let fromView = context.view(forKey: .from) else {
            return
        }
        let container = context.containerView
        let fromViewFinalFrame = animateInFinalFrame.offsetForFinalPosition(direction: transition.out, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, animations: {
            fromView.frame = fromViewFinalFrame
            fromView.alpha = CXBasicAnimation.transparent
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }
}
