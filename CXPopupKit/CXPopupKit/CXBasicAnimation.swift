//
//  CXBasicAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

open class CXBasicAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: CXAnimationDuration
    let transition: CXAnimationTransition

    weak var presentingViewController: UIViewController?

    init(presenting: UIViewController, duration: CXAnimationDuration, transition: CXAnimationTransition) {
        self.presentingViewController = presenting
        self.duration = duration
        self.transition = transition
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isPresenting(transitionContext) {
            return duration.animateInDuration
        } else {
            return duration.animateOutDuration
        }
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }

    private func isPresenting(_ context: UIViewControllerContextTransitioning?) -> Bool {
        guard let from = context?.viewController(forKey: .from), let presenting = self.presentingViewController else {
            return false
        }
        return from == presenting
    }
}
