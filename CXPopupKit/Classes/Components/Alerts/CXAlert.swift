//
//  CXAlert.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public enum CXAlertStyle {
    case alert
    case actionSheet
}

public typealias CXButtonHandler = (String) -> Void
typealias CXButtonAction = (target: Any?, selector: Selector)

public class CXAlert: CXPopup {
    init(config: CXAlertConfig,
        title: String?,
        message: String?,
        buttonText1: String?,
        buttonHandler1: CXButtonHandler?,
        buttonText2: String?,
        buttonHandler2: CXButtonHandler?,
        buttonText3: String?,
        buttonHandler3: CXButtonHandler?,
        buttonTextArray: [String]?,
        buttonInArrayHandler: CXButtonHandler?,
        presenting: UIViewController?) {
        
        let alertView = AlertView(
            config: config,
            title: title,
            message: message,
            buttonText1: buttonText1,
            buttonHandler1: buttonHandler1,
            buttonText2: buttonText2,
            buttonHandler2: buttonHandler2,
            buttonText3: buttonText3,
            buttonHandler3: buttonHandler3,
            buttonTextArray: buttonTextArray,
            buttonInArrayHandler: buttonInArrayHandler)
        super.init(alertView, alertView.config.exportPopupConfig(), nil, presenting)
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
        private var buttonHandler1: CXButtonHandler?
        private var buttonHandler2: CXButtonHandler?
        private var buttonHandler3: CXButtonHandler?
        private var buttonTextArray: [String]?
        private var buttonInArrayHandler: CXButtonHandler?
        private var config: CXAlertConfig
        
        public init(_ style: CXAlertStyle) {
            self.style = style
            self.config = CXAlertConfig(with: style)
        }
        
        public func withTitle(_ title: String) -> Self {
            self.title = title
            return self
        }
        
        public func withMessage(_ message: String) -> Self {
            self.message = message
            return self
        }
        
        public func withButton1(_ buttonText1: String, _ buttonHandler1: @escaping CXButtonHandler) -> Self {
            self.buttonText1 = buttonText1
            self.buttonHandler1 = buttonHandler1
            return self
        }
        
        public func withButton2(_ buttonText2: String, _ buttonHandler2: @escaping CXButtonHandler) -> Self {
            self.buttonText2 = buttonText2
            self.buttonHandler2 = buttonHandler2
            return self
        }
        
        public func withButton3(_ buttonText3: String, _ buttonHandler3: @escaping CXButtonHandler) -> Self {
            self.buttonText3 = buttonText3
            self.buttonHandler3 = buttonHandler3
            return self
        }
        
        public func withButtonArray(_ buttonTextArray: [String], _ buttonInArrayHandler: @escaping CXButtonHandler) -> Self {
            self.buttonTextArray = buttonTextArray
            self.buttonInArrayHandler = buttonInArrayHandler
            return self
        }

        public func withConfig(_ config: CXAlertConfig) -> Self {
            self.config = config
            return self
        }
        
        public func create(on vc: UIViewController?) -> CXPopupInteractable {
            return CXAlert(
                config: config,
                title: title,
                message: message,
                buttonText1: buttonText1,
                buttonHandler1: buttonHandler1,
                buttonText2: buttonText2,
                buttonHandler2: buttonHandler2,
                buttonText3: buttonText3,
                buttonHandler3: buttonHandler3,
                buttonTextArray: buttonTextArray,
                buttonInArrayHandler: buttonInArrayHandler,
                presenting: vc)
        }
    }
}

public struct CXAlertConfig {
    static let alertViewWidth: CGFloat = 270

    public let style: CXAlertStyle
    public var buttonHeight: CGFloat = 44
    public var buttonColor = UIColor(white: 0.98, alpha: 1.0)
    public var buttonHighlightColor = UIColor(white: 0.9, alpha: 1.0)
    public var buttonDividerColor = UIColor(white: 0.7, alpha: 1.0)
    public var defaultAxis: UILayoutConstraintAxis? = nil

    public var titleFont = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    public var titleColor = UIColor.black
    public var messageFont = UIFont.systemFont(ofSize: 14.0)
    public var messageColor = UIColor.darkGray
    public var messageTextAlignment = NSTextAlignment.center
    public var buttonFont = UIFont.systemFont(ofSize: 14.0)
    public var buttonTitleColor = UIColor.black

    public var alertBackgroundColor = UIColor(white: 0.98, alpha: 1.0)

    var finalHeight: CGFloat = 0

    public init(with style: CXAlertStyle) {
        self.style = style
    }

    func exportPopupConfig() -> CXPopupConfig {
        var config = CXPopupConfig()
        switch style {
        case .actionSheet:
            config.allowTouchOutsideToDismiss = true
            config.layoutStyle = .bottom(height: finalHeight)
            config.animationTransition = CXAnimationTransition(.up)
            config.maskBackgroundColor = UIColor(white: 0.7, alpha: 0.8)
            config.safeAreaStyle = .wrap
            config.safeAreaGapColor = alertBackgroundColor
        case .alert:
            config.allowTouchOutsideToDismiss = false
            config.layoutStyle = .center(size: CGSize(width: CXAlertConfig.alertViewWidth, height: finalHeight))
            config.animationStyle = .pop
            config.animationTransition = CXAnimationTransition(.center)
            config.maskBackgroundColor = .clear
        }
        return config
    }
}
