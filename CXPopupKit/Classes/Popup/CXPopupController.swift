//
//  CXPopupController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/9/19.
//

import UIKit

public class CXPopupController: BasePopupController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Add child view controller
        addChild(viewController)
        popupContainer.install(viewController.view)
        viewController.didMove(toParent: self)

        let layoutStyle = appearance.layoutStyle
        let safeAreaInsets = appearance.safeAreaStyle.insets(layoutStyle)
        let layoutInsets = appearance.layoutInsets
        CXLayoutBuilder.attachToRootView(popupContainer.container, view, layoutStyle, layoutInsets.merge(safeAreaInsets))
    }
}
