//
//  CXDialog.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/22/19.
//

import UIKit

public protocol CXDialog where Self: UIResponder {
    var popupController: CXPopupController? { get }
}

public extension CXDialog {
    var popupController: CXPopupController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let popupController = responder as? CXPopupController {
                return popupController
            }
        }
        return nil
    }
}
