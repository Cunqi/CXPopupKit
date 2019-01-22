//
//  CXPresentationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/17/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXPresentationController: UIPresentationController {
    var contentView: UIView?
    var dimmingView: UIView?
    let config: CXPopupConfig

    lazy var tapOutsideGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideToDismiss))
        return gesture
    }()

    lazy var animationController: UIViewControllerAnimatedTransitioning? = {
        return AnimationFactory.getAnimation(
            presenting: self.presentingViewController,
            style: config.animationStyle,
            duration: config.animationDuration,
            transition: config.animationTransition)
    }()

    var coordinator: UIViewControllerTransitionCoordinator? {
        return self.presentingViewController.transitionCoordinator
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return CXLayoutUtil.layout(layoutStyle: config.layoutStyle, safeAreaStyle: config.safeAreaStyle, insets: config.layoutInsets)
    }

    override var presentedView: UIView? {
        return contentView
    }

    @objc private func tapOutsideToDismiss() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, config: CXPopupConfig) {
        self.config = config
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.presentedViewController.modalPresentationStyle = .custom
        self.presentedViewController.transitioningDelegate = self
    }

    override func presentationTransitionWillBegin() {
        // contentView
        contentView = UIView(frame: self.frameOfPresentedViewInContainerView)
        if config.isShadowEnabled {
            contentView?.layer.shadowOpacity = config.shadowOpacity
            contentView?.layer.shadowRadius = config.shadowRadius
            contentView?.layer.shadowOffset = config.shadowOffset
            contentView?.layer.shadowColor = config.shadowColor.cgColor
        }

        // roundedCornerView
        let roundedCornerView = UIView(frame: contentView?.bounds ?? .zero)
        roundedCornerView.layer.cornerRadius = config.cornerRadius
        roundedCornerView.layer.masksToBounds = true

        // super.presentedView
        let presentedView = super.presentedView ?? UIView()
        presentedView.frame = contentView?.bounds ?? .zero

        // Add dependencies between each view
        CXLayoutUtil.fill(presentedView, at: roundedCornerView)
        CXLayoutUtil.fill(roundedCornerView, at: contentView)

        // Dimming view
        dimmingView = UIView()
        dimmingView?.backgroundColor = config.maskBackgroundColor
        dimmingView?.alpha = 0

        // Behavior
        if config.allTapOutsideToDismiss {
            dimmingView?.addGestureRecognizer(tapOutsideGestureRecognizer)
        }
        containerView?.addSubview(dimmingView!)
        containerView?.addSubview(contentView!) // make sure content view is above dimming view

        coordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.dimmingView?.alpha = 1.0
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
