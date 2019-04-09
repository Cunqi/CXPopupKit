//
//  CXDialog.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/22/19.
//

import UIKit

public protocol CXDialog where Self: UIResponder {
    var cxPopup: CXPopup? { get }
}

public extension CXDialog {
    var cxPopup: CXPopup? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let window = responder as? CXPopup {
                return window
            }
        }
        return nil
    }
}
