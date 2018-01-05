//
//  CXBounceZoomPopupAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/29/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import Foundation

final class CXBounceZoomPopupAnimation: CXAbstractPopupAnimation {
    override func transitionIn() {
        toViewInitialFrame = toViewFinalFrame
        toView?.frame = toViewInitialFrame
        toView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: { [unowned self] in
                        self.toView?.transform = .identity
        }) { completed in
            self.context.completeTransition(completed)
        }
    }
    
    override func transitionOut() {    
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: { [unowned self] in
                        self.fromView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { completed in
            self.context.completeTransition(completed)
        }
    }
}
