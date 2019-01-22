//
//  CXAlertPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public enum CXAlertStyle {
    case alert
    case actionSheet
}

public typealias CXButtonAction = (String) -> Void

public class CXAlertPopup: CXPopup {
    init(style: CXAlertStyle, title: String?, message: String?) {
        super.init(<#T##view: UIView & CXCustomPopup##UIView & CXCustomPopup#>, <#T##config: CXPopupConfig##CXPopupConfig#>, nil)
    }
    
    public class Builder {
        private var style: CXAlertStyle
        private var title: String?
        private var message: String?
        private var buttonText1: String?
        private var buttonText2: String?
        private var buttonText3: String?
        private var buttonAction1: CXButtonAction?
        private var buttonAction2: CXButtonAction?
        private var buttonAction3: CXButtonAction?
        private var buttonTextArray: [String]?
        private var buttonTextArraySelectedAction: CXButtonAction?
        
        public init(_ style: CXAlertStyle) {
            self.style = style
        }
        
        public func withTitle(_ title: String) {
            self.title = title
        }
        
        public func withMessage(_ message: String) {
            self.message = message
        }
        
        public func withButton1(_ buttonText1: String, _ buttonAction1: @escaping CXButtonAction) {
            self.buttonText1 = buttonText1
            self.buttonAction1 = buttonAction1
        }
        
        public func withButton2(_ buttonText2: String, _ buttonAction2: @escaping CXButtonAction) {
            self.buttonText2 = buttonText2
            self.buttonAction2 = buttonAction2
        }
        
        public func withButton3(_ buttonText3: String, _ buttonAction3: @escaping CXButtonAction) {
            self.buttonText3 = buttonText3
            self.buttonAction3 = buttonAction3
        }
        
        public func withButtonArray(_ buttonTextArray: [String], _ buttonTextArraySelectedAction: @escaping CXButtonAction) {
            self.buttonTextArray = buttonTextArray
            self.buttonTextArraySelectedAction = buttonTextArraySelectedAction
        }
        
        public func create() -> CXAlertPopup {
            return CXAlertPopup(
                style: style,
                title: title,
                message: message)
        }
    }
}
