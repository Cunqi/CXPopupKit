//
//  CXPresentationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/17/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXPresentationController: UIPresentationController {
    let style: CXPopupStyle
    var contentView: UIView?
    var dimmingView: UIView?

    lazy var animation: UIViewControllerAnimatedTransitioning = {
        return AnimationFactory.animation(
            self.style.animationStyle,
            self.style.animationDuration,
            self.style.animationTransition,
            self.presentingViewController)
    }()

    var coordinator: UIViewControllerTransitionCoordinator? {
        self.presentingViewController.transitionCoordinator
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerBounds = self.containerView?.bounds ?? .zero
        let rect = CXDimensionUtil.rect(style.width, style.height, style.position, style.safeAreaPolicy, containerBounds.size)
        return rect
    }

    override var presentedView: UIView? {
        contentView
    }

    @objc
    private func tapOutsideToDismiss() {
        (self.presentedViewController as? CXPopupController)?.dismiss(animated: true, completion: nil)
    }

    init(_ style: CXPopupStyle, _ presented: UIViewController, _ presenting: UIViewController) {
        self.style = style
        super.init(presentedViewController: presented, presenting: presenting)
        presented.modalPresentationStyle = .custom
        presented.transitioningDelegate = self
    }

    override func presentationTransitionWillBegin() {
        // contentView
        contentView = UIView(frame: self.frameOfPresentedViewInContainerView)
        if style.isShadowEnabled {
            contentView?.layer.shadowOpacity = style.shadowOpacity
            contentView?.layer.shadowRadius = style.shadowRadius
            contentView?.layer.shadowOffset = style.shadowOffset
            contentView?.layer.shadowColor = style.shadowColor.cgColor
        }

        // roundedCornerView
        let roundedCornerView = UIView(frame: contentView?.bounds ?? .zero)
        roundedCornerView.layer.cornerRadius = style.cornerRadius
        roundedCornerView.layer.masksToBounds = true

        // super.presentedView
        let presentedView = super.presentedView ?? UIView()
        presentedView.frame = contentView?.bounds ?? .zero
        
        roundedCornerView.backgroundColor = .green

        // Add dependencies between each view
        CXLayoutUtil.fill(presentedView, roundedCornerView)
        CXLayoutUtil.fill(roundedCornerView, contentView)

        // Dimming view
        dimmingView = UIView()
        dimmingView?.backgroundColor = style.maskBackgroundColor
        dimmingView?.alpha = 0
        if style.shouldDismissOnBackgroundTap {
            dimmingView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOutsideToDismiss)))
        }
        containerView?.addSubview(dimmingView!)
        containerView?.addSubview(contentView!) // make sure content view is above dimming view

        let destinationAlpha = style.maskBackgroundAlpha
        coordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.dimmingView?.alpha = destinationAlpha
        }, completion: nil)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.contentView = nil
            self.dimmingView = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        coordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.dimmingView?.alpha = 0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.contentView = nil
            self.dimmingView = nil
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        self.dimmingView?.frame = self.containerView?.bounds ?? .zero
        self.contentView?.frame = self.frameOfPresentedViewInContainerView
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container === self.presentedViewController {
            self.containerView?.setNeedsLayout()
        }
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === self.presentedViewController {
            return (container as! UIViewController).preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
}

extension CXPresentationController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animation
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animation
    }
}
