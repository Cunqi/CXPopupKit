//
//  CXPopupable.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public protocol CXPopupable where Self: UIView {
    var popupWindow: (CXPopupWindow & UIViewController)? { get }
}

public extension CXPopupable {
    var popupWindow: (CXPopupWindow & UIViewController)? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let window = responder as? CXPopupWindow & UIViewController {
                return window
            }
        }
        return nil
    }
}
