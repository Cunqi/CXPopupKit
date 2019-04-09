//
//  CXPresentationManager.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/3/19.
//

import UIKit

final class CXPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    let config: CXPopupAppearance

    init(config: CXPopupAppearance) {
        self.config = config
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: source, config: config)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationFactory.animation(for: config.animationStyle, config.animationDuration.in, config.animationTransition.in, .in)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationFactory.animation(for: config.animationStyle, config.animationDuration.out, config.animationTransition.out, .out)
    }
}
