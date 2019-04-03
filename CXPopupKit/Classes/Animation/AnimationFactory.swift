//
//  AnimationFactory.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class AnimationFactory {
    static func animation(for style: CXAnimationStyle, _ duration: TimeInterval, _ direction: CXAnimationDirection, _ directionType: CXAnimationDirectionType) -> UIViewControllerAnimatedTransitioning {
        switch style {
        case .basic:
            return CXBasicAnimation(duration: duration, direction: direction, directionType: directionType)
        case .fade:
            return CXFadeAnimation(duration: duration, direction: direction, directionType: directionType)
        case .bounce:
            return CXBounceAnimation(duration: duration, direction: direction, directionType: directionType)
        case .zoom:
            return CXZoomAnimation(duration: duration, direction: direction, directionType: directionType)
        case .pop:
            return CXPopAnimation(duration: duration, direction: direction, directionType: directionType)
        case .custom(let animator):
            return animator
        }
    }
}
