//
//  CXPopupWindow.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/8/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

public final class CXPopupWindow: CXAbstractPopupWindow, CXPopupWindowDisplayable {
    public var negativeAction: CXPopupHandler?
    public var positiveAction: CXPopupHandler?

    var cxPresentationController: CXPresentationController?

    public static func createPopup(with popupable: CXPopupable, appearance: CXPopupAppearance) -> CXPopupWindowDisplayable {
        return CXPopupWindow(with: popupable, appearance: appearance)
    }

    public func popup(at presenter: UIViewController?, positive: CXPopupHandler? = nil, negative: CXPopupHandler? = nil) {
        self.negativeAction = negative
        self.positiveAction = positive

        cxPresentationController = CXPresentationController(presentedViewController: self, presenting: presenter)
        cxPresentationController?.appearance = appearance
        self.transitioningDelegate = cxPresentationController
        presenter?.present(self, animated: true)
    }

    public func executePositiveAction(with result: Any?) {
        positiveAction?(result)
    }

    public func executeNegativeAction(with result: Any?) {
        negativeAction?(result)
    }

    public func dismissAfterExecutingPositiveAction(with result: Any?) {
        executePositiveAction(with: result)
        dismiss(animated: true)
    }

    public func dismissAfterExecutingNegativeAction(with result: Any?) {
        executeNegativeAction(with: result)
        dismiss(animated: true)
    }
}
