//
//  CXBounceAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/13/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

class CXBounceAnimation: CXBasicAnimation {
    override func presenting(_ context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController(forKey: .to), let toView = context.view(forKey: .to) else {
            return
        }
        let container = context.containerView
        let toViewFinalFrame = context.finalFrame(for: toVC)
        let toViewInitialFrame = toViewFinalFrame.offsetForInitialPosition(direction: transition.animateInDirection, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        animateInFinalFrame = toViewFinalFrame

        toView.frame = toViewInitialFrame
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            toView.frame = toViewFinalFrame
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
        let fromViewFinalFrame = animateOutInitialFrame.offsetForFinalPosition(direction: transition.animateOutDirection, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            fromView.frame = fromViewFinalFrame
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }
}
