//
//  CXPresentationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/17/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXPresentationController: UIPresentationController {
    var lastPresentedFrame: CGRect = .zero
    var contentView: UIView?
    var dimmingView: UIView?

    var appearance: CXPopupAppearance {
        let popupController = self.presentedViewController as? CXBasePopupController
        return popupController?.popupAppearance ?? CXPopupAppearance()
    }

    lazy var tapOutsideGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideToDismiss))
        return gesture
    }()

    lazy var animationController: UIViewControllerAnimatedTransitioning? = {
        return AnimationFactory.getAnimationInstance(from: appearance, presentationController: self)
    }()

    var coordinator: UIViewControllerTransitionCoordinator? {
        return self.presentingViewController.transitionCoordinator
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerBounds = self.containerView?.bounds ?? .zero
        let rect = CXDimensionUtil.getRect(width: appearance.width,
                                           height: appearance.height,
                                           position: appearance.position,
                                           safeAreaType: appearance.safeAreaType,
                                           screen: containerBounds.size)
        lastPresentedFrame = rect
        return rect
    }

    override var presentedView: UIView? {
        return contentView
    }

    @objc private func tapOutsideToDismiss() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.presentedViewController.modalPresentationStyle = .custom
        self.presentedViewController.transitioningDelegate = self
    }

    override func presentationTransitionWillBegin() {
        // contentView
        contentView = UIView(frame: self.frameOfPresentedViewInContainerView)
        if appearance.isShadowEnabled {
            contentView?.layer.shadowOpacity = appearance.shadowOpacity
            contentView?.layer.shadowRadius = appearance.shadowRadius
            contentView?.layer.shadowOffset = appearance.shadowOffset
            contentView?.layer.shadowColor = appearance.shadowColor.cgColor
        }

        // roundedCornerView
        let roundedCornerView = UIView(frame: contentView?.bounds ?? .zero)
        roundedCornerView.layer.cornerRadius = appearance.cornerRadius
        roundedCornerView.layer.masksToBounds = true

        // super.presentedView
        let presentedView = super.presentedView ?? UIView()
        presentedView.frame = contentView?.bounds ?? .zero

        // Add dependencies between each view
        CXLayoutUtil.fill(presentedView, at: roundedCornerView)
        CXLayoutUtil.fill(roundedCornerView, at: contentView)

        // Dimming view
        dimmingView = UIView()
        dimmingView?.backgroundColor = appearance.maskBackgroundColor
        dimmingView?.alpha = 0
        if appearance.shouldDismissOnBackgroundTap {
            dimmingView?.addGestureRecognizer(tapOutsideGestureRecognizer)
        }
        containerView?.addSubview(dimmingView!)
        containerView?.addSubview(contentView!) // make sure content view is above dimming view

        let destinationAlpha = appearance.maskBackgroundAlpha
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
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController
    }
}
