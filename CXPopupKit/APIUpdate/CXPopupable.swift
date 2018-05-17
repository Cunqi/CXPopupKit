//
//  CXPopupable.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/8/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

public protocol CXPopupable: CXLifecycleAction {
    var cxPopup: CXPopupWindow? { get }
}

public protocol CXPopupWindowDisplayable {
    func popup(at presenter: UIViewController?, positive: CXPopupHandler?, negative: CXPopupHandler?)
    func executePositiveAction(with result: Any?)
    func executeNegativeAction(with result: Any?)
    func dismissAfterExecutingPositiveAction(with result: Any?)
    func dismissAfterExecutingNegativeAction(with result: Any?)
}

extension CXPopupable {
    public var cxPopup: CXPopupWindow? {
        var responder: UIResponder? = self as? UIView
        while responder != nil {
            responder = responder?.next
            if let window = responder as? CXPopupWindow {
                return window
            }
        }
        return nil
    }
}

extension UIView: CXPopupable {}
