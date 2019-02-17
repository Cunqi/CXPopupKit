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
    
    var width: CGFloat {
        switch self {
        case .alert:
            return 270
        case .actionSheet:
            return UIScreen.main.bounds.width
        }
    }
}

public typealias CXButtonHandler = (String) -> Void

class CXTappable: Equatable, Hashable {
    let text: String
    var handler: CXButtonHandler
    
    var hashValue: Int {
        return text.hashValue
    }
    
    init(_ text: String, _ handler: @escaping CXButtonHandler) {
        self.text = text
        self.handler = handler
    }

    static func ==(lhs: CXTappable, rhs: CXTappable) -> Bool {
        return lhs.text == rhs.text
    }
}

public class CXAlert: CXPopup {
    init(config: CXAlertConfig, title: String?, message: String?, tappableArray: [CXTappable], presenting: UIViewController?) {
        let alertView = AlertView(config: config, title: title, message: message, tappableArray: tappableArray)
        super.init(alertView, alertView.config.popupConfig, nil, presenting)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public class Builder {
        private var style: CXAlertStyle
        private var title: String?
        private var message: String?
        
        private var tappable1: CXTappable?
        private var tappable2: CXTappable?
        private var tappable3: CXTappable?
        private var tappableArray: [CXTappable]?
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
            self.tappable1 = CXTappable(buttonText1, buttonHandler1)
            return self
        }
        
        public func withButton2(_ buttonText2: String, _ buttonHandler2: @escaping CXButtonHandler) -> Self {
            self.tappable2 = CXTappable(buttonText2, buttonHandler2)
            return self
        }
        
        public func withButton3(_ buttonText3: String, _ buttonHandler3: @escaping CXButtonHandler) -> Self {
            self.tappable3 = CXTappable(buttonText3, buttonHandler3)
            return self
        }
        
        public func withButtonArray(_ buttonTextSet: Set<String>, _ buttonInArrayHandler: @escaping CXButtonHandler) -> Self {
            self.tappableArray = buttonTextSet.map { CXTappable($0, buttonInArrayHandler) }
            return self
        }

        public func withConfig(_ config: CXAlertConfig) -> Self {
            self.config = config
            return self
        }
        
        public func create(on vc: UIViewController?) -> CXPopupInteractable {
            let tappableArray = self.tappableArray ?? [tappable1, tappable2, tappable3].compactMap { $0 }
            return CXAlert(
                config: config,
                title: title,
                message: message,
                tappableArray: tappableArray,
                presenting: vc)
        }
    }
}

public struct CXAlertConfig {
    public let style: CXAlertStyle
    public var buttonHeight: CGFloat = 44
    public var buttonColor = UIColor(white: 0.98, alpha: 1.0)
    public var buttonHighlightColor = UIColor(white: 0.9, alpha: 1.0)
    public var buttonDividerColor = UIColor(white: 0.7, alpha: 1.0)
    public var defaultAxis: NSLayoutConstraint.Axis? = nil

    public var titleFont = UIFont.systemFont(ofSize: 17.0, weight: .medium)
    public var titleColor = UIColor.black
    public var messageFont = UIFont.systemFont(ofSize: 14.0)
    public var messageColor = UIColor.darkGray
    public var messageTextAlignment = NSTextAlignment.center
    public var buttonFont = UIFont.systemFont(ofSize: 14.0)
    public var buttonTitleColor = UIColor.black

    public var backgroundColor = UIColor(white: 0.98, alpha: 1.0)
    
    var popupConfig: CXPopupConfig

    public init(with style: CXAlertStyle) {
        self.style = style
        self.popupConfig = CXPopupConfig()
        switch style {
        case .actionSheet:
            popupConfig.allowTouchOutsideToDismiss = true
            popupConfig.layoutStyle = .bottom(height: 0)
            popupConfig.animationTransition = CXAnimationTransition(.up)
            popupConfig.maskBackgroundColor = UIColor(white: 0.7, alpha: 0.8)
            popupConfig.safeAreaStyle = .wrap
            popupConfig.safeAreaGapColor = backgroundColor
        case .alert:
            popupConfig.allowTouchOutsideToDismiss = false
            popupConfig.layoutStyle = .center(size: .zero)
            popupConfig.animationStyle = .pop
            popupConfig.animationTransition = CXAnimationTransition(.center)
            popupConfig.maskBackgroundColor = .clear
        }
    }
}
