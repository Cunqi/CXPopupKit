//
//  AnimationFactory.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class AnimationFactory {
    static func getAnimation(presenting: UIViewController, style: CXAnimationStyle, duration: CXAnimationDuration, transition: CXAnimationTransition) -> UIViewControllerAnimatedTransitioning? {
        switch style {
        case .basic:
            return CXBasicAnimation(presenting: presenting, duration: duration, transition: transition)
        case .fade:
            return CXFadeAnimation(presenting: presenting, duration: duration, transition: transition)
        case .bounce:
            return CXBounceAnimation(presenting: presenting, duration: duration, transition: transition)
        case .zoom:
            return CXZoomAnimation(presenting: presenting, duration: duration, transition: transition)
        case .pop:
            return CXPopAnimation(presenting: presenting, duration: duration, transition: transition)
        case .custom(let animator):
            return animator
        }
    }
}
