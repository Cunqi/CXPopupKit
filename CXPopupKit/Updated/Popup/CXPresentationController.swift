//
//  CXPresentationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 12/25/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

final class CXPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var appearance = CXPopupAppearance()

    private var presentationWrapperView: UIView?
    private var backgroundView: UIView?

    override var frameOfPresentedViewInContainerView: CGRect {
        let dimension = appearance.dimension
        let rect = DimensionUtil.rect(width: dimension.width, height: dimension.height, position: dimension.position, margin: dimension.margin, safeAreaOption: dimension.safeAreaOption, basedOn: containerView!)
        print("Presenter \(rect)")
//        let updatedRect = DimensionUtil.updatedRect(rect: rect, position: dimension.position, margin: dimension.margin, safeAreaOption: dimension.safeAreaOption, basedOn: containerView!)
//        print("Presenter \(updatedRect)")
        return rect
    }

    override var presentedView: UIView? {
        return presentationWrapperView
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }

    override func presentationTransitionWillBegin() {
        setupPresentationWrapperView()
        updatePresentedViewControllerView()
        setupBackgroundView()
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentationWrapperView = nil
            self.backgroundView = nil
        }
    }

    override func dismissalTransitionWillBegin() {
        let coordinator = self.presentingViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { [weak self] context in
            self?.backgroundView?.alpha = 0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentationWrapperView = nil
            self.backgroundView = nil
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let animation = appearance.animation
        guard let fromViewController = transitionContext?.viewController(forKey: .from) else {
            return animation.duration.getDuration(isIn: false)
        }
        let isPresenting = fromViewController == self.presentingViewController
        return animation.duration.getDuration(isIn: isPresenting)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animation = appearance.animation
        let isPresenting = transitionContext.viewController(forKey: .from) == self.presentingViewController
        let popupAnimation = animation.style.getAnimation(transitionContext, animation.transition, animation.duration, isPresenting)
        popupAnimation.execute()
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.backgroundView?.frame = self.containerView!.bounds
        updatePresentationWrapperViewFrame()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    private func updatePresentedViewControllerView() {
        let presentedViewControllerView = super.presentedView!
        let frame = CGRect(origin: .zero, size: frameOfPresentedViewInContainerView.size)
        presentedViewControllerView.frame = frame
        presentedViewControllerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        presentationWrapperView?.addSubview(presentedViewControllerView)
    }

    private func setupPresentationWrapperView() {
        presentationWrapperView = UIView()
        presentationWrapperView?.backgroundColor = appearance.uiStyle.popupBackgroundColor ?? super.presentedView?.backgroundColor
        updatePresentationWrapperViewFrame()

        let shadow = appearance.shadow
        if shadow.isEnabled {
            presentationWrapperView?.layer.shadowColor = shadow.color.cgColor
            presentationWrapperView?.layer.shadowOffset = shadow.offset
            presentationWrapperView?.layer.shadowRadius = shadow.radius
            presentationWrapperView?.layer.shadowOpacity = shadow.opacity
        }
    }

    private func updatePresentationWrapperViewFrame() {
        let dimension = appearance.dimension
        let rect = DimensionUtil.rect(width: dimension.width, height: dimension.height, position: dimension.position, margin: dimension.margin, safeAreaOption: dimension.safeAreaOption, basedOn: containerView!)
        let updatedRect = DimensionUtil.updatedRect(rect: rect, position: dimension.position, margin: dimension.margin, safeAreaOption: dimension.safeAreaOption, basedOn: containerView!)
        presentationWrapperView?.frame = updatedRect
    }

    private func setupBackgroundView() {
        backgroundView = UIView(frame: containerView!.bounds)
        backgroundView?.backgroundColor = appearance.uiStyle.maskBackgroundColor
        backgroundView?.alpha = appearance.uiStyle.maskBackgroundAlpha
        backgroundView?.isOpaque = false

        if appearance.isTouchOutsideDismissEnabled {
            backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped)))
        }
        containerView?.addSubview(backgroundView!)

        let coordinator = self.presentingViewController.transitionCoordinator
        backgroundView?.alpha = 0
        coordinator?.animate(alongsideTransition: { [unowned self] context in
            self.backgroundView?.alpha = self.appearance.uiStyle.maskBackgroundAlpha
        }, completion: nil)
    }

    @objc private func backgroundViewTapped(gesture: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
