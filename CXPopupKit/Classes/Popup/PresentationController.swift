//
//  PresentationController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/3/19.
//

import UIKit

class PresentationController: UIPresentationController {
    let config: CXPopupConfig

    private lazy var backgroundView: PopupBackgroundView = {
        let view = PopupBackgroundView(frame: .zero)
        view.backgroundColor = self.config.maskBackgroundColor
        return view
    }()

    private lazy var tapOutsideGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideToDismiss))
        return gesture
    }()

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, config: CXPopupConfig) {
        self.config = config
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        if config.allowTouchOutsideToDismiss {
            backgroundView.addGestureRecognizer(tapOutsideGestureRecognizer)
        }
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        backgroundView.frame = containerView.bounds
        containerView.insertSubview(backgroundView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 1.0
            }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0.0
            }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {

        guard let presentedView = presentedView else { return }

        presentedView.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return CXLayoutUtil.layout(layoutStyle: config.layoutStyle, safeAreaStyle: config.safeAreaStyle, insets: config.layoutInsets)
    }

    @objc private func tapOutsideToDismiss() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}
