//
//  CXPopupWindow.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public protocol CXPopupWindow where Self: UIViewController {
    var vc: UIViewController { get }
    
    func close()
    func closeWithPositiveAction(_ result: Any?)
    func closeWithNegativeAction()
    func invokePositiveAction(_ result: Any?)
    func invokeNegativeAction()
}

final class CXBasicPopupWindow: UIViewController, CXPopupWindow {
    override var shouldAutorotate: Bool {
        return popupAppearance.isAutoRotateEnabled
    }

    var positiveAction: CXPopupAction?
    var negativeAction: CXPlainAction?
    var cxPresentationController: CXPresentationController?
    var popupAppearance = CXPopupAppearance()
    var contentView: CXPopupable?
    var viewDidAppearAction: CXPlainAction?
    
    var vc: UIViewController {
        return self
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func closeWithPositiveAction(_ result: Any?) {
        self.dismiss(animated: true) { [weak self] in
            self?.positiveAction?(result)
        }
    }
    
    func closeWithNegativeAction() {
        self.dismiss(animated: true) { [weak self] in
            self?.negativeAction?()
        }
    }
    
    func invokeNegativeAction() {
        negativeAction?()
    }
    
    func invokePositiveAction(_ result: Any?) {
        positiveAction?(result)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearAction?()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanup()
    }

    private func setup() {
        self.view.backgroundColor = popupAppearance.backgroundColor

        guard let contentView = self.contentView as? UIView else {
            return
        }
        addAndMakeViewFullScreen(contentView)
    }

    private func cleanup() {
        self.positiveAction = nil
        self.negativeAction = nil
        self.cxPresentationController = nil
    }

    private func addAndMakeViewFullScreen(_ content: UIView) {
        view.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false

        let padding = popupAppearance.position.getPaddingInsets(for: popupAppearance.safeAreaType)

        content.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding.left).isActive = true
        content.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: padding.right).isActive = true
        content.topAnchor.constraint(equalTo: self.view.topAnchor, constant: padding.top).isActive = true
        content.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: padding.bottom).isActive = true
    }

    deinit {
        #if DEBUG
            print("PopupWindow dealloced.")
        #endif
    }
}
