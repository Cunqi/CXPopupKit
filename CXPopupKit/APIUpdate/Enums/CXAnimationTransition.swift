//
//  CXAnimationTransition.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/5/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public enum CXAnimationTransition {
    public enum Direction {
        case center
        case left
        case right
        case up
        case down
    }
    
    case oneWay(in: CXAnimationTransition.Direction, out: CXAnimationTransition.Direction)
    case roundTrip(direction: CXAnimationTransition.Direction)
}

public enum CXAnimationDuration {
    case oneWay(in: TimeInterval, out: TimeInterval)
    case roundTrip(duration: TimeInterval)
}

public enum CXAnimationStyle {
    case plain
    case zoom
    case fade
    case bounce
    case bounceZoom
}

extension CXAnimationTransition {
    func getDirection(isIn: Bool) -> CXAnimationTransition.Direction {
        switch self {
        case let .oneWay(`in`, out):
            return isIn ? `in` : out
        case let .roundTrip(direction):
            return direction
        }
    }
}

extension CXAnimationDuration {
    func getDuration(isIn: Bool) -> TimeInterval {
        switch self {
        case let .oneWay(`in`, out):
            return isIn ? `in`: out
        case let .roundTrip(direction):
            return direction
        }
    }
}

extension CXAnimationStyle {
    func getAnimation(_ context: UIViewControllerContextTransitioning, _ transition: CXAnimationTransition, _ duration: CXAnimationDuration, _ isPresenting: Bool) -> CXAbstractPopupAnimation {
        switch self {
        case .plain:
            return CXPlainPopupAnimation(context, transition, duration, isPresenting)
        case .fade:
            return CXFadePopupAnimation(context, transition, duration, isPresenting)
        case .bounce:
            return CXBouncePopupAnimation(context, transition, duration, isPresenting)
        case .bounceZoom:
            return CXBounceZoomPopupAnimation(context, transition, duration, isPresenting)
        case .zoom:
            return CXZoomPopupAnimation(context, transition, duration, isPresenting)
        }
    }
}