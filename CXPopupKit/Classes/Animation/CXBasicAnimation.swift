//
//  CXBasicAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

enum CXAnimationDirectionType {
    case `in`, out
}

class CXBasicAnimation: CXAnimation {
    static let opaque: CGFloat = 1
    static let transparent: CGFloat = 0

    var animateInFinalFrame: CGRect = .zero
    var animateOutInitialFrame: CGRect {
        get {
            return animateInFinalFrame
        }

        set {
            animateInFinalFrame = newValue
        }
    }

    override func presenting(_ context: UIViewControllerContextTransitioning, _ from: UIViewController, _ to: UIViewController) {
        let container = context.containerView
        let toViewFinalFrame = context.finalFrame(for: to)
        let toViewInitialFrame = toViewFinalFrame.offsetForInitialPosition(direction: direction, offsetSize: container.bounds.size)
        let duration = transitionDuration(using: context)

        to.view.frame = toViewInitialFrame
        UIView.animate(withDuration: duration, animations: {
            to.view.frame = toViewFinalFrame
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
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }
}
