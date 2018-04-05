//
//  CXAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/25/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import Foundation

public struct CXAnimation {
    public init() {
    }

    public var transition = Transition(.center)
    public var duration = Duration(0.35)
    public var style: Animation = .plain

    public struct Transition {
        let `in`: TransitionDirection
        let out: TransitionDirection

        public init(_ roundTransition: TransitionDirection) {
            self.init(in: roundTransition, out: roundTransition)
        }

        public init(in: TransitionDirection, out: TransitionDirection) {
            self.in = `in`
            self.out = out
        }
    }

    public struct Duration {
        let `in`: TimeInterval
        let out: TimeInterval

        public init(_ roundTransitionDuration: TimeInterval) {
            self.init(in: roundTransitionDuration, out: roundTransitionDuration)
        }

        public init(in: TimeInterval, out: TimeInterval) {
            self.in = `in`
            self.out = out
        }
    }

    public enum Animation {
        case plain
        case zoom
        case fade
        case bounce
        case bounceZoom
    }

    public enum TransitionDirection {
        case center
        case left
        case right
        case up
        case down
    }
}

extension CXAnimation {
    func getAnimation(_ context: UIViewControllerContextTransitioning, _ transition: CXAnimationTransition, _ duration: CXAnimationDuration,  _ isPresenting: Bool) -> CXAbstractPopupAnimation {
        switch self.style {
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

