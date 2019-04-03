//
//  CXAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval
    let direction: CXAnimationDirection
    let directionType: CXAnimationDirectionType

    init(duration: TimeInterval, direction: CXAnimationDirection, directionType: CXAnimationDirectionType) {
        self.duration = duration
        self.direction = direction
        self.directionType = directionType
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch directionType {
        case .in:
            guard let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }

            let container = transitionContext.containerView
            container.addSubview(to.view)

            presenting(transitionContext, from, to)
        case .out:
            guard let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }

            dismissing(transitionContext, from, to)
        }
    }

    func presenting(_ context: UIViewControllerContextTransitioning, _ from: UIViewController, _ to: UIViewController) {}
    func dismissing(_ context: UIViewControllerContextTransitioning, _ from: UIViewController, _ to: UIViewController) {}
}

public enum CXAnimationStyle {
    case basic
    case fade
    case bounce
    case zoom
    case pop
    case custom(animator: UIViewControllerAnimatedTransitioning)
}

public struct CXAnimationDuration {
    let `in`: TimeInterval
    let out: TimeInterval

    public init(_ `in`: TimeInterval, _ out: TimeInterval) {
        self.`in` = `in`
        self.out = out
    }

    public init(_ duration: TimeInterval) {
        self.`in` = duration
        self.out = duration
    }
}

public enum CXAnimationDirection {
    case up
    case down
    case left
    case right
    case center

    public var opposite: CXAnimationDirection {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        case .center:
            return .center
        }
    }
}

public struct CXAnimationTransition {
    public let `in`: CXAnimationDirection
    public let out: CXAnimationDirection

    public init(_ `in`: CXAnimationDirection, _ out: CXAnimationDirection) {
        self.`in` = `in`
        self.out = out
    }

    public init(_ in: CXAnimationDirection) {
        self.`in` = `in`
        self.out = `in`.opposite
    }
}

// Helper methods

extension CGRect {
    func offsetForInitialPosition(direction: CXAnimationDirection, offsetSize: CGSize) -> CGRect {
        let origin = direction.getDeparturePoint(base: self.origin, size: offsetSize)
        return CGRect(origin: origin, size: self.size)
    }

    func offsetForFinalPosition(direction: CXAnimationDirection, offsetSize: CGSize) -> CGRect {
        let origin = direction.getArrivalPoint(base: self.origin, size: offsetSize)
        return CGRect(origin: origin, size: self.size)
    }
}

extension CXAnimationDirection {
    func getDeparturePoint(base: CGPoint, size: CGSize) -> CGPoint {
        switch self {
        case .up:
            return CGPoint(x: base.x, y: base.y + size.height)
        case .down:
            return CGPoint(x: base.x, y: base.y - size.height)
        case .center:
            return base
        case .left:
            return CGPoint(x: base.x + size.width, y: base.y)
        case .right:
            return CGPoint(x: base.x - size.width, y: base.y)
        }
    }

    func getArrivalPoint(base: CGPoint, size: CGSize) -> CGPoint {
        switch self {
        case .up:
            return CGPoint(x: base.x, y: base.y - size.height)
        case .down:
            return CGPoint(x: base.x, y: base.y + size.height)
        case .center:
            return base
        case .left:
            return CGPoint(x: base.x - size.width, y: base.y)
        case .right:
            return CGPoint(x: base.x + size.width, y: base.y)
        }
    }
}
