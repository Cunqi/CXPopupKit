//
//  CXAlertBuilder.swift
//  CXPopupKit
//
//  Created by Cunqi on 10/2/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public enum CXAlertType {
    case alert
    case actionSheet
}

public typealias CXAlertActionHandler = (String) -> Void

public class CXAlertBuilder {
    let alertView: CXAbstractAlertView
    var presenting: UIViewController?
    
    public init(type: CXAlertType, at presenting: UIViewController?) {
        self.presenting = presenting
        switch type {
        case .alert:
            self.alertView = CXAlert()
        case .actionSheet:
            self.alertView = CXActionSheet()
        }
    }
    
    public func withTitle(_ title: String) -> Self {
        self.alertView.titleText = title
        return self
    }
    
    public func withMessage(_ message: String) -> Self {
        self.alertView.messageText = message
        return self
    }
    
    public func withConfirm(_ confirmText: String, _ handler: CXAlertActionHandler? = nil) -> Self {
        self.alertView.addConfirmAction(confirmText, handler)
        return self
    }
    
    public func withCancel(_ cancelText: String, _ handler: CXAlertActionHandler? = nil) -> Self {
        self.alertView.addCancelAction(cancelText, handler)
        return self
    }
    
    public func withActions(_ actions: [String], _ handler: CXAlertActionHandler? = nil) -> Self {
        self.alertView.addActions(actions, handler)
        return self
    }
    
    public func withModal(_ enabled: Bool) -> Self {
        return self
    }
        
    public func build() -> UIViewController {
        return CXPopupBuilder(content: self.alertView.render(), presenting: self.presenting)
            .withAppearance(self.alertView.popupAppearance)
            .build()
    }
}
