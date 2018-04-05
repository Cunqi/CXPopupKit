//
//  CXAbstractPopupAnimation.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/25/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

open class CXAbstractPopupAnimation {
    public private(set) var context: UIViewControllerContextTransitioning
    public let duration: TimeInterval
    public let direction: CXAnimationTransition.Direction

    var isPresenting: Bool = true
    
    init(_ context: UIViewControllerContextTransitioning, _ transition: CXAnimationTransition, _ duration: CXAnimationDuration, _ isPresenting: Bool) {
        self.context = context
        self.isPresenting = isPresenting
        self.duration = duration.getDuration(isIn: isPresenting)
        self.direction = transition.getDirection(isIn: isPresenting)
        
        if let mFromViewController = fromViewController {
            fromViewInitialFrame = context.initialFrame(for: mFromViewController)
            fromViewFinalFrame = context.finalFrame(for: mFromViewController)
        }
        
        if let mToViewController = toViewController {
            toViewInitialFrame = context.initialFrame(for: mToViewController)
            toViewFinalFrame = context.finalFrame(for: mToViewController)
        }
        
        if let mToView = toView {
            containerView.addSubview(mToView)
        }
    }
    
    public var containerView: UIView {
        return context.containerView
    }
    
    public var fromViewController: UIViewController? {
        return context.viewController(forKey: .from)
    }
    
    public var fromView: UIView? {
        return context.view(forKey: .from)
    }
    
    public var fromViewInitialFrame: CGRect = .zero
    public var fromViewFinalFrame: CGRect = .zero
    
    public var toViewController: UIViewController? {
        return context.viewController(forKey: .to)
    }
    
    public var toView: UIView? {
        return context.view(forKey: .to)
    }
    
    public var toViewInitialFrame: CGRect = .zero
    public var toViewFinalFrame: CGRect = .zero
    
    public func execute() {
        if isPresenting {
            transitionIn()
        } else {
            transitionOut()
        }
    }
    
    open func transitionIn() {
    }
    
    open func transitionOut() {
    }
}
