//
//  PositionUtil.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/26/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import Foundation

class PositionUtil {
    static func inferInitialFrame(from frame: CGRect, direction: CXAnimationTransition.Direction, based size: CGSize) -> CGRect {
        switch direction {
        case .center:
            return frame
        case .left:
            return frame.offsetBy(dx: size.width, dy: 0)
        case .right:
            return frame.offsetBy(dx: -size.width, dy: 0)
        case .up:
            return frame.offsetBy(dx: 0, dy: size.height)
        case .down:
            return frame.offsetBy(dx: 0, dy: -size.height)
        }
    }
    
    static func inferFinalFrame(from frame: CGRect, direction: CXAnimationTransition.Direction, based size: CGSize) -> CGRect {
        switch direction {
        case .center:
            return frame
        case .left:
            return frame.offsetBy(dx: -size.width, dy: 0)
        case .right:
            return frame.offsetBy(dx: size.width, dy: 0)
        case .up:
            return frame.offsetBy(dx: 0, dy: -size.height)
        case .down:
            return frame.offsetBy(dx: 0, dy: size.height)
        }
    }
}
