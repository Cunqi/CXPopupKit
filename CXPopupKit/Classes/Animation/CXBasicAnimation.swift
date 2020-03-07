import UIKit

class CXBasicAnimation: NSObject, CXAnimation {
    static let opaque: CGFloat = 1
    static let transparent: CGFloat = 0

    let duration: CXAnimationDuration
    let transition: CXAnimationTransition

    weak var presentingViewController: UIViewController?

    var animateInFinalFrame: CGRect = .zero

    init(_ presenting: UIViewController, _ duration: CXAnimationDuration, _ transition: CXAnimationTransition) {
        self.presentingViewController = presenting
        self.duration = duration
        self.transition = transition
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isPresenting(transitionContext) {
            return duration.in
        } else {
            return duration.out
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresenting(transitionContext) ? presenting(transitionContext) : dismissing(transitionContext)
    }

    func presenting(_ context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController(forKey: .to), let toView = context.view(forKey: .to) else {
            return
        }
        let container = context.containerView
        let toViewFinalFrame = context.finalFrame(for: toVC)
        let toViewInitialFrame = toViewFinalFrame.offsetForInitialPosition(direction: transition.`in`, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        animateInFinalFrame = toViewFinalFrame

        toView.frame = toViewInitialFrame
        toView.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            toView.frame = toViewFinalFrame
            toView.alpha = 1
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }

    func dismissing(_ context: UIViewControllerContextTransitioning) {
        guard let fromView = context.view(forKey: .from) else {
            return
        }
        let container = context.containerView
        let fromViewFinalFrame = animateInFinalFrame.offsetForFinalPosition(direction: transition.out, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, animations: {
            fromView.frame = fromViewFinalFrame
            fromView.alpha = 0
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }

    final func isPresenting(_ context: UIViewControllerContextTransitioning?) -> Bool {
        guard let from = context?.viewController(forKey: .from), let presenting = self.presentingViewController else {
            return false
        }
        return from == presenting
    }
}
