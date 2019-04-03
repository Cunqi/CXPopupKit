//
//  CXZoomAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/13/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

extension CGAffineTransform {
    static var zero: CGAffineTransform {
        return CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
}

class CXPopAnimation: CXAnimation {

    override func presenting(_ context: UIViewControllerContextTransitioning, _ from: UIViewController, _ to: UIViewController) {
        let duration = transitionDuration(using: context)
        to.view.transform = CGAffineTransform.zero
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            to.view.transform = CGAffineTransform.identity
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }

    override func dismissing(_ context: UIViewControllerContextTransitioning, _ from: UIViewController, _ to: UIViewController) {
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, animations: {
            from.view.transform = CGAffineTransform.zero
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }
}
