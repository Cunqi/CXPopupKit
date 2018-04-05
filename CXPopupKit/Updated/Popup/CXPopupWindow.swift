//
//  CXPopupWindow.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/8/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

class CXPopupWindow: UIViewController {
    override var shouldAutorotate: Bool {
        return appearance.orientation.isAutoRotationEnabled
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return appearance.orientation.supportedInterfaceOrientations
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return appearance.orientation.preferredInterfaceOrientationForPresentation
    }

    var holder: CXPopup?
    var appearance = CXPopupAppearance.createAppearance()
    var content: CXPopupable?

    var negativeAction: CXPopupHandler?
    var positiveAction: CXPopupHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        content?.popupWindowDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        holder = nil
        content?.popupWindowDidDisappear()
    }

    private func setup() {
        let style = appearance.uiStyle
        view.backgroundColor = style.popupBackgroundColor ?? (content as? UIView)?.backgroundColor

//        let dimension = appearance.dimension
        LayoutUtil.fill(view: (content as? UIView) ?? UIView(), at: view)
    }

    deinit {
        print("CXPopupWindow deinit")
    }
}
