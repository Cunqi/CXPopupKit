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
    init(config: CXAlertConfig, title: String?, message: String?, buttonLayoutBuilder: ButtonLayout, presenting: UIViewController?) {
        let alertView = AlertView(config, title, message, buttonLayoutBuilder)
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
        private var buttonAction1: CXButtonAction?
        private var buttonAction2: CXButtonAction?
        private var buttonAction3: CXButtonAction?
        private var buttonTextArray: [String]?
        private var buttonTextArraySelectedAction: CXButtonAction?
        
        public init(_ style: CXAlertStyle) {
            self.style = style
        }
        
        public func withTitle(_ title: String) -> Self {
            self.title = title
            return self
        }
        
        public func withMessage(_ message: String) -> Self {
            self.message = message
            return self
        }
        
        public func withButton1(_ buttonText1: String, _ buttonAction1: CXButtonAction) -> Self {
            self.buttonText1 = buttonText1
            self.buttonAction1 = buttonAction1
            return self
        }
        
        public func withButton2(_ buttonText2: String, _ buttonAction2: CXButtonAction) -> Self {
            self.buttonText2 = buttonText2
            self.buttonAction2 = buttonAction2
            return self
        }
        
        public func withButton3(_ buttonText3: String, _ buttonAction3: CXButtonAction) -> Self {
            self.buttonText3 = buttonText3
            self.buttonAction3 = buttonAction3
            return self
        }
        
        public func withButtonArray(_ buttonTextArray: [String], _ buttonTextArraySelectedAction: CXButtonAction) -> Self {
            self.buttonTextArray = buttonTextArray
            self.buttonTextArraySelectedAction = buttonTextArraySelectedAction
            return self
        }
        
        public func create(on vc: UIViewController?) -> UIViewController {
            let config = CXAlertConfig(with: style)
            let buttonLayoutBuilder = ButtonLayout(
                config: config,
                buttonText1: buttonText1,
                buttonAction1: buttonAction1,
                buttonText2: buttonText2,
                buttonAction2: buttonAction2,
                buttonText3: buttonText3,
                buttonAction3: buttonAction3,
                buttonTextArray: buttonTextArray,
                buttonTextArraySelectedAction: buttonTextArraySelectedAction)

            return CXAlertPopup(
                config: config,
                title: title,
                message: message,
                buttonLayoutBuilder: buttonLayoutBuilder,
                presenting: vc)
        }
    }
    
    class AlertView: UIView, CXDialog {
        var config: CXAlertConfig
        private var alertViewHeight: CGFloat = 0

        init(_ config: CXAlertConfig, _ title: String?, _ message: String?, _ buttonLayout: ButtonLayout) {
            self.config = config

            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill

            let titleLayout = AlertView.createTitleLayout(title, config)
            if let layout = titleLayout.layout {
                stackView.addArrangedSubview(layout)
                alertViewHeight += titleLayout.height
            }

            let messageLayout = AlertView.createMessageLayout(title, message, config)
            if let layout = messageLayout.layout {
                stackView.addArrangedSubview(layout)
                alertViewHeight += messageLayout.height
            }

            if let layout = buttonLayout.layout {
                stackView.addArrangedSubview(layout)
                alertViewHeight += buttonLayout.height
            }
            super.init(frame: .zero)
            CXLayoutUtil.fill(stackView, at: self)
            self.config.finalHeight = alertViewHeight
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private static func createTitleLayout(_ title: String?, _ config: CXAlertConfig) -> (layout: UIView?, height: CGFloat) {
            var height: CGFloat = 0
            guard let title = title else {
                return (nil, height)
            }
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.font = config.titleFont
            label.textColor = config.titleColor

            let width = config.style == .alert ? CXAlertConfig.alertViewWidth : UIScreen.main.bounds.size.width
            let estimatedHeight = CXTextUtil.getTextSize(
                for: title,
                with: CGSize(width: width - CXSpacing.spacing5, height: CGFloat(Double.greatestFiniteMagnitude)),
                font: config.titleFont).height
            height = estimatedHeight + CXSpacing.spacing4

            let layout = UIView()
            layout.backgroundColor = config.alertBackgroundColor
            layout.heightAnchor.constraint(equalToConstant: height).isActive = true
            CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(top: CXSpacing.spacing3, left: CXSpacing.spacing4, bottom: CXSpacing.spacing3, right: CXSpacing.spacing4))
            return (layout, height)
        }

        private static func createMessageLayout(_ title: String?, _ message: String?, _ config: CXAlertConfig) -> (layout: UIView?, height: CGFloat) {
            var height: CGFloat = 0
            guard let message = message else {
                return (nil, height)
            }
            let label = UILabel()
            label.text = message
            label.textAlignment = config.messageTextAlignment
            label.font = config.messageFont
            label.textColor = config.messageColor

            let width = config.style == .alert ? CXAlertConfig.alertViewWidth : UIScreen.main.bounds.size.width
            let estimatedHeight = CXTextUtil.getTextSize(
                for: message,
                with: CGSize(width: width - CXSpacing.spacing4, height: CGFloat(Double.greatestFiniteMagnitude)),
                font: config.messageFont).height
            height = estimatedHeight + CXSpacing.spacing4

            let layout = UIView()
            layout.backgroundColor = config.alertBackgroundColor
            layout.heightAnchor.constraint(equalToConstant: height).isActive = true

            if title == nil {
                CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(top: CXSpacing.spacing3, left: CXSpacing.spacing3, bottom: CXSpacing.spacing3, right: CXSpacing.spacing3))
            } else {
                CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(top: 0, left: CXSpacing.spacing3, bottom: CXSpacing.spacing4, right: CXSpacing.spacing3))
            }
            return (layout, height)
        }
    }
    
    class ButtonLayout {
        let layout: UIView?
        var height: CGFloat = 0
        
        init(
            config: CXAlertConfig,
            buttonText1: String?,
            buttonAction1: CXButtonAction?,
            buttonText2: String?,
            buttonAction2: CXButtonAction?,
            buttonText3: String?,
            buttonAction3: CXButtonAction?,
            buttonTextArray: [String]?,
            buttonTextArraySelectedAction: CXButtonAction?) {

            let buttonStack = UIStackView()
            if let array = buttonTextArray, !array.isEmpty {
                for text in array {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, buttonTextArraySelectedAction!, config.buttonColor, config.buttonHighlightColor))
                }
            } else {
                if let text = buttonText1, let action = buttonAction1 {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, action, config.buttonColor, config.buttonHighlightColor))
                }
                if let text = buttonText2, let action = buttonAction2 {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, action, config.buttonColor, config.buttonHighlightColor))
                }
                if let text = buttonText3, let action = buttonAction3 {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, action, config.buttonColor, config.buttonHighlightColor))
                }
            }

            guard !buttonStack.arrangedSubviews.isEmpty else {
                layout = nil
                return
            }
            
            if config.style == .actionSheet || buttonStack.arrangedSubviews.count > 2 {
                buttonStack.axis = .vertical
                buttonStack.distribution = .fillEqually
                height = CGFloat(buttonStack.arrangedSubviews.count) * config.buttonHeight
            } else {
                buttonStack.axis = config.defaultAxis ?? .horizontal
                buttonStack.distribution = .fillEqually
                height = buttonStack.arrangedSubviews.isEmpty ? 0 : config.buttonHeight
            }
            buttonStack.spacing = 1.0


            layout = UIView()
            layout?.backgroundColor = config.buttonDividerColor
            CXLayoutUtil.fill(buttonStack, at: layout, with: UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0))
        }
        
        private static func createButton(_ title: String, _ action: CXButtonAction, _ bgColor: UIColor, _ bgHighlightColor: UIColor) -> UIButton {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(createButtonBackgroundColorImage(for: bgColor), for: .normal)
            button.setBackgroundImage(createButtonBackgroundColorImage(for: bgHighlightColor), for: .highlighted)
            button.setTitle(title, for: .normal)
            button.addTarget(action.target, action: action.selector, for: .touchUpInside)
            return button
        }

        private static func createButtonBackgroundColorImage(for color: UIColor) -> UIImage? {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
    }
}

struct CXAlertConfig {
    static let alertViewWidth: CGFloat = 270

    let style: CXAlertStyle
    var buttonHeight: CGFloat = 44
    var buttonColor = UIColor.white
    var buttonHighlightColor = UIColor(white: 0.9, alpha: 1.0)
    var buttonDividerColor = UIColor(white: 0.7, alpha: 1.0)
    var defaultAxis: UILayoutConstraintAxis? = nil

    var titleFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    var titleColor = UIColor.black
    var messageFont = UIFont.systemFont(ofSize: 12.0)
    var messageColor = UIColor.darkGray
    var messageTextAlignment = NSTextAlignment.center

    var alertBackgroundColor = UIColor.white

    var finalHeight: CGFloat = 0
    var popupConfig = CXPopupConfig()

    init(with style: CXAlertStyle) {
        self.style = style
    }

    func exportPopupConfig() -> CXPopupConfig {
        var config = CXPopupConfig()
        switch style {
        case .actionSheet:
            config.allowTouchOutsideToDismiss = true
            config.layoutStyle = .bottom(height: finalHeight)
            config.animationTransition = CXAnimationTransition(in: .up)
        case .alert:
            config.allowTouchOutsideToDismiss = false
            config.layoutStyle = .center(size: CGSize(width: CXAlertConfig.alertViewWidth, height: finalHeight))
            config.animationStyle = .pop
            config.animationTransition = CXAnimationTransition(in: .center)
        }
        return config
    }
}
