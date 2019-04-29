//
//  CXNavigatePopupController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/29/19.
//

import UIKit

public protocol CXNavigateBar {
    func tapLeftBarButtonItem(_ action: CXPopupNavigateAction)
    func tapRightBarButtonItem(_ action: CXPopupNavigateAction)
}

public class CXNavigatePopupController: CXPopupController {

    /// Popup a navigateable view with customized popup appearance
    ///
    /// - Parameters:
    ///   - content: customized popup view
    ///   - title: title for the view
    ///   - left: left action for navigation
    ///   - right: right action for navigation
    ///   - appearance: popup appearance
    ///   - delegate: hook to popup lifecycle methods
    public init(content: CXView,
                title: String?,
                left: CXPopupNavigateAction?,
                right: CXPopupNavigateAction?,
                appearance: CXPopupAppearance,
                delegate: CXPopupLifecycleDelegate? = nil) {
        let navigationController = CXNavigationController(title: title, left: left, right: right, view: content)
        super.init(navigationController, appearance, delegate)
    }


    /// Popup a navigateable view controller with customized popup appearance
    ///
    /// - Parameters:
    ///   - content: customized popup view controller
    ///   - title: title for the view controller
    ///   - left: left action for navigation
    ///   - right: right action for navigation
    ///   - appearance: popup appearance
    ///   - delegate: hook to popup lifecycle methods
    public init(content: CXViewController,
                title: String?,
                left: CXPopupNavigateAction?,
                right: CXPopupNavigateAction,
                appearance: CXPopupAppearance,
                delegate: CXPopupLifecycleDelegate? = nil) {
        let navigationController = CXNavigationController(title: title, left: left, right: right, viewController: content)
        super.init(navigationController, appearance, delegate)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
