//
//  CXBasePopupController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 10/2/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

typealias BaseContentView = CXPopupable & UIView

class CXBasePopupController: UIViewController, CXPopupController {
    override var shouldAutorotate: Bool {
        return popupAppearance.isAutoRotateEnabled
    }
    
    var popupAppearance = CXPopupAppearance()
    var viewDidAppearAction: CXVoidAction?

    private let contentView: CXPopupable
    private var cxPresentationController: CXPresentationController?

    // MARK - Initialization & De-initialization

    init(_ content: CXPopupable, _ presenting: UIViewController?) {
        self.contentView = content
        super.init(nibName: nil, bundle: nil)
        self.cxPresentationController = CXPresentationController(presentedViewController: self, presenting: presenting)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        #if DEBUG
        print("PopupWindow dealloced.")
        #endif
    }

    // MARK - CXPopupController

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK - Lifecycle override

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

    // MARK - private helper methods

    private func setup() {
        self.view.backgroundColor = popupAppearance.backgroundColor
        let padding = popupAppearance.position.getPaddingInsets(for: popupAppearance.safeAreaType)
        CXLayoutUtil.fill(contentView as! UIView, at: self.view, with: padding)
    }

    private func cleanup() {
        self.cxPresentationController = nil
    }
}

