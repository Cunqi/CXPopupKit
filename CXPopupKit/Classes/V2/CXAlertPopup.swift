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

public typealias CXButtonAction = (target: Any?, selector: Selector)

class PlaceholderView: UIView, CXDialog {
    
}

public class CXAlertPopup: CXPopup {
    init(style: CXAlertStyle, title: String?, message: String?, presenting: UIViewController?) {
        super.init(PlaceholderView(), CXPopupConfig(), nil, presenting)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        public func withButton1(_ buttonText1: String, _ buttonAction1: CXButtonAction) {
            self.buttonText1 = buttonText1
            self.buttonAction1 = buttonAction1
        }
        
        public func withButton2(_ buttonText2: String, _ buttonAction2: CXButtonAction) {
            self.buttonText2 = buttonText2
            self.buttonAction2 = buttonAction2
        }
        
        public func withButton3(_ buttonText3: String, _ buttonAction3: CXButtonAction) {
            self.buttonText3 = buttonText3
            self.buttonAction3 = buttonAction3
        }
        
        public func withButtonArray(_ buttonTextArray: [String], _ buttonTextArraySelectedAction: CXButtonAction) {
            self.buttonTextArray = buttonTextArray
            self.buttonTextArraySelectedAction = buttonTextArraySelectedAction
        }
        
        public func create(on vc: UIViewController?) -> UIViewController {
            return CXAlertPopup(
                style: style,
                title: title,
                message: message,
                presenting: vc)
        }
    }
    
    class AlertView: UIView, CXDialog {
        init(_ style: CXAlertStyle, _ title: String, _ message: String, _ buttonLayoutBuilder: ButtonLayoutBuilder) {
            super.init(frame: .zero)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ButtonLayoutBuilder {
        var buttonStack = UIStackView()
        var height: CGFloat = 0
        
        init(
            style: CXAlertStyle,
            buttonText1: String?,
            buttonAction1: CXButtonAction?,
            buttonText2: String?,
            buttonAction2: CXButtonAction?,
            buttonText3: String?,
            buttonAction3: CXButtonAction?,
            buttonTextArray: [String]?,
            buttonTextArraySelectedAction: CXButtonAction?) {
         
            if let array = buttonTextArray, !array.isEmpty {
                for text in array {
                    buttonStack.addArrangedSubview(ButtonLayoutBuilder.createButton(text, buttonTextArraySelectedAction!))
                }
            } else {
                if let text = buttonText1, let action = buttonAction1 {
                    buttonStack.addArrangedSubview(ButtonLayoutBuilder.createButton(text, action))
                }
                if let text = buttonText2, let action = buttonAction2 {
                    buttonStack.addArrangedSubview(ButtonLayoutBuilder.createButton(text, action))
                }
                if let text = buttonText3, let action = buttonAction3 {
                    buttonStack.addArrangedSubview(ButtonLayoutBuilder.createButton(text, action))
                }
            }
            
            if style == .actionSheet || buttonStack.arrangedSubviews.count > 2 {
                buttonStack.axis = .vertical
            } else {
                buttonStack.axis = .horizontal
            }
        }
        
        private static func createButton(_ title: String, _ action: CXButtonAction) -> UIButton {
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.addTarget(action.target, action: action.selector, for: .touchUpInside)
            return button
        }
    }
}
