//
//  CXAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

public enum CXAnimation {
    case basic
}

public struct CXAnimationDuration {
    let animateInDuration: TimeInterval
    let animateOutDuration: TimeInterval

    init(`in`: TimeInterval, out: TimeInterval) {
        self.animateInDuration = `in`
        self.animateOutDuration = out
    }

    init(round: TimeInterval) {
        self.animateInDuration = round
        self.animateOutDuration = round
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
    let animateInDirection: CXAnimationDirection
    let animateOutDirection: CXAnimationDirection

    init(`in`: CXAnimationDirection, out: CXAnimationDirection) {
        self.animateInDirection = `in`
        self.animateOutDirection = out
    }

    init(`in`: CXAnimationDirection, oppositeDirectionForOut: Bool = true) {
        self.animateInDirection = `in`
        if oppositeDirectionForOut {
            self.animateOutDirection = `in`.opposite
        } else {
            self.animateOutDirection = `in`
        }
    }
}
