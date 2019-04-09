//
//  CXPresentationManager.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/3/19.
//

import UIKit

final class CXPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    let appearance: CXPopupAppearance

    init(appearance: CXPopupAppearance) {
        self.appearance = appearance
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: source, config: appearance)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationFactory.animation(for: appearance.animationStyle, appearance.animationDuration.in, appearance.animationTransition.in, .in)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationFactory.animation(for: appearance.animationStyle, appearance.animationDuration.out, appearance.animationTransition.out, .out)
    }
}
