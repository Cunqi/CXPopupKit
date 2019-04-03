//
//  CXFadeAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/13/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

class CXFadeAnimation: CXAnimation {
    override func presenting(_ context: UIViewControllerContextTransitioning, _ from: UIViewController, _ to: UIViewController) {
        let container = context.containerView
        let toViewFinalFrame = context.finalFrame(for: to)
        let toViewInitialFrame = toViewFinalFrame.offsetForInitialPosition(direction: direction, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)

        to.view.frame = toViewInitialFrame
        to.view.alpha = CXBasicAnimation.transparent
        UIView.animate(withDuration: duration, animations: {
            to.view.frame = toViewFinalFrame
            to.view.alpha = CXBasicAnimation.opaque
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })

    }

    override func dismissing(_ context: UIViewControllerContextTransitioning, _ from: UIViewController, _ to: UIViewController) {
        let container = context.containerView
        let fromViewInitialFrame = context.initialFrame(for: from)
        let fromViewFinalFrame = fromViewInitialFrame.offsetForFinalPosition(direction: direction, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, animations: {
            from.view.frame = fromViewFinalFrame
            from.view.alpha = CXBasicAnimation.transparent
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }
}
