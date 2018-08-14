//
//  AnimationFactory.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class AnimationFactory {
    static func getAnimationInstance(from appearance: CXPopupAppearance, presentationController: UIPresentationController) -> UIViewControllerAnimatedTransitioning? {
        switch appearance.animationStyle {
        case .basic:
            return CXBasicAnimation(presenting: presentationController.presentingViewController,
                                    duration: appearance.animationDuration,
                                    transition: appearance.animationTransition)
        case .fade:
            return CXFadeAnimation(presenting: presentationController.presentingViewController,
                                   duration: appearance.animationDuration,
                                   transition: appearance.animationTransition)
        case .bounce:
            return CXBounceAnimation(presenting: presentationController.presentingViewController,
                                     duration: appearance.animationDuration,
                                     transition: appearance.animationTransition)
        case .zoom:
            return CXZoomAnimation(presenting: presentationController.presentingViewController,
                                   duration: appearance.animationDuration,
                                   transition: appearance.animationTransition)
        case .pop:
            return CXPopAnimation(presenting: presentationController.presentingViewController,
                            duration: appearance.animationDuration,
                            transition: appearance.animationTransition)
        case .custom(let animator):
            return animator
        }
    }
}
