//
//  CXPopupable.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public protocol CXPopupable where Self: UIView {
    var popupController: CXPopupController? { get }
}

public extension CXPopupable {
    var popupController: CXPopupController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let window = responder as? CXPopupController {
                return window
            }
        }
        return nil
    }
}
