//
//  CXPopAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/13/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

class CXZoomAnimation: CXBasicAnimation {
    override func presenting(_ context: UIViewControllerContextTransitioning) {
        guard let toView = context.view(forKey: .to) else {
            return
        }
        let duration = transitionDuration(using: context)
        toView.transform = CGAffineTransform.zero
        UIView.animate(withDuration: duration, animations: {
            toView.transform = CGAffineTransform.identity
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }

    override func dismissing(_ context: UIViewControllerContextTransitioning) {
        guard let fromView = context.view(forKey: .from) else {
            return
        }
        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, animations: {
            fromView.transform = CGAffineTransform.zero
        }, completion: { finished in
            let wasCancelled = context.transitionWasCancelled
            context.completeTransition(!wasCancelled)
        })
    }
}
