//
//  CXBasicAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXBasicAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: CXAnimationDuration
    let transition: CXAnimationTransition

    var animateInFinalFrame: CGRect = .zero
    var animateOutInitialFrame: CGRect {
        get {
            return animateInFinalFrame
        }

        set {
            animateInFinalFrame = newValue
        }
    }

    weak var presentingViewController: UIViewController?

    init(presenting: UIViewController, duration: CXAnimationDuration, transition: CXAnimationTransition) {
        self.presentingViewController = presenting
        self.duration = duration
        self.transition = transition
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isPresenting(transitionContext) {
            return duration.animateInDuration
        } else {
            return duration.animateOutDuration
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        if isPresenting(transitionContext) {
            presenting(transitionContext, container: container)
        } else {
            dismissing(transitionContext, container: container)
        }
    }

    func presenting(_ context: UIViewControllerContextTransitioning, container: UIView) {
        guard let toVC = context.viewController(forKey: .to), let toView = context.view(forKey: .to) else {
            return
        }
        let toViewFinalFrame = context.finalFrame(for: toVC)
        let toViewInitialFrame = toViewFinalFrame.offsetForInitialPosition(direction: transition.animateInDirection, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        animateInFinalFrame = toViewFinalFrame

        toView.frame = toViewInitialFrame
        UIView.animate(withDuration: duration, animations: {
            toView.frame = toViewFinalFrame
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }

    func dismissing(_ context: UIViewControllerContextTransitioning, container: UIView) {
        guard let fromView = context.view(forKey: .from) else {
            return
        }
        let fromViewFinalFrame = animateOutInitialFrame.offsetForFinalPosition(direction: transition.animateOutDirection, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, animations: {
            fromView.frame = fromViewFinalFrame
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

extension CGRect {
    func offsetForInitialPosition(direction: CXAnimationDirection, offsetSize: CGSize) -> CGRect {
        let origin = direction.getDeparturePoint(base: self.origin, size: offsetSize)
        return CGRect(origin: origin, size: self.size)
    }

    func offsetForFinalPosition(direction: CXAnimationDirection, offsetSize: CGSize) -> CGRect {
        let origin = direction.getArrivalPoint(base: self.origin, size: offsetSize)
        return CGRect(origin: origin, size: self.size)
    }
}

extension CXAnimationDirection {
    func getDeparturePoint(base: CGPoint, size: CGSize) -> CGPoint {
        switch self {
        case .up:
            return CGPoint(x: base.x, y: base.y + size.height)
        case .down:
            return CGPoint(x: base.x, y: base.y - size.height)
        case .center:
            return base
        case .left:
            return CGPoint(x: base.x + size.width, y: base.y)
        case .right:
            return CGPoint(x: base.x - size.width, y: base.y)
        }
    }

    func getArrivalPoint(base: CGPoint, size: CGSize) -> CGPoint {
        switch self {
        case .up:
            return CGPoint(x: base.x, y: base.y - size.height)
        case .down:
            return CGPoint(x: base.x, y: base.y + size.height)
        case .center:
            return base
        case .left:
            return CGPoint(x: base.x - size.width, y: base.y)
        case .right:
            return CGPoint(x: base.x + size.width, y: base.y)
        }
    }
}
