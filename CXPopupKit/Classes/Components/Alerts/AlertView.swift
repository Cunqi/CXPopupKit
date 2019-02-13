//
//  AlertView.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/23/19.
//

import UIKit

class AlertView: UIView, CXDialog {
    var config: CXAlertConfig
    private var alertViewHeight: CGFloat = 0
    private var buttonHandler1: CXButtonHandler?
    private var buttonHandler2: CXButtonHandler?
    private var buttonHandler3: CXButtonHandler?
    private var buttonInArrayHandler: CXButtonHandler?
    
    init(
        config: CXAlertConfig,
        title: String?,
        message: String?,
        buttonText1: String?,
        buttonHandler1: CXButtonHandler?,
        buttonText2: String?,
        buttonHandler2: CXButtonHandler?,
        buttonText3: String?,
        buttonHandler3: CXButtonHandler?,
        buttonTextArray: [String]?,
        buttonInArrayHandler: CXButtonHandler?) {
        self.config = config
        self.buttonHandler1 = buttonHandler1
        self.buttonHandler2 = buttonHandler2
        self.buttonHandler3 = buttonHandler3
        self.buttonInArrayHandler = buttonInArrayHandler
        super.init(frame: .zero)
        
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
        
        let buttonLayout = ButtonLayout(
            config,
            buttonText1,
            CXButtonAction(self, #selector(didTapButton1(sender:))),
            buttonText2,
            CXButtonAction(self, #selector(didTapButton2(sender:))),
            buttonText3,
            CXButtonAction(self, #selector(didTapButton3(sender:))),
            buttonTextArray,
            CXButtonAction(self, #selector(didTapButtonInArray(sender:))))
        if let layout = buttonLayout.layout {
            stackView.addArrangedSubview(layout)
            alertViewHeight += buttonLayout.height
        }
        
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(top: CXSpacing.spacing4 - CXSpacing.spacing2, left: CXSpacing.spacing4, bottom: CXSpacing.spacing2, right: CXSpacing.spacing4))
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
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
    
    @objc private func didTapButton1(sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        self.cxPopup?.dismiss({ [weak self] in
            self?.buttonHandler1?(title)
            self?.cleanup()
        })
    }
    
    @objc private func didTapButton2(sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        self.cxPopup?.dismiss({ [weak self] in
            self?.buttonHandler2?(title)
            self?.cleanup()
        })
    }
    
    @objc private func didTapButton3(sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        self.cxPopup?.dismiss({ [weak self] in
            self?.buttonHandler3?(title)
            self?.cleanup()
        })
    }
    
    @objc private func didTapButtonInArray(sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        self.cxPopup?.dismiss({ [weak self] in
            self?.buttonInArrayHandler?(title)
            self?.cleanup()
        })
    }
    
    private func cleanup() {
        buttonHandler1 = nil
        buttonHandler2 = nil
        buttonHandler3 = nil
        buttonInArrayHandler = nil
    }
    
    class ButtonLayout {
        let layout: UIView?
        var height: CGFloat = 0
        
        init(
            _ config: CXAlertConfig,
            _ buttonText1: String?,
            _ buttonAction1: CXButtonAction?,
            _ buttonText2: String?,
            _ buttonAction2: CXButtonAction?,
            _ buttonText3: String?,
            _ buttonAction3: CXButtonAction?,
            _ buttonTextArray: [String]?,
            _ buttonTextArraySelectedAction: CXButtonAction?) {
            
            let buttonStack = UIStackView()
            if let array = buttonTextArray, !array.isEmpty {
                for text in array {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, buttonTextArraySelectedAction!, config.buttonColor, config.buttonHighlightColor, config.buttonTitleColor, config.buttonFont))
                }
            } else {
                if let text = buttonText1, let action = buttonAction1 {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, action, config.buttonColor, config.buttonHighlightColor, config.buttonTitleColor, config.buttonFont))
                }
                if let text = buttonText2, let action = buttonAction2 {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, action, config.buttonColor, config.buttonHighlightColor, config.buttonTitleColor, config.buttonFont))
                }
                if let text = buttonText3, let action = buttonAction3 {
                    buttonStack.addArrangedSubview(ButtonLayout.createButton(text, action, config.buttonColor, config.buttonHighlightColor, config.buttonTitleColor, config.buttonFont))
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
        
        private static func createButton(_ title: String, _ action: CXButtonAction, _ bgColor: UIColor, _ bgHighlightColor: UIColor, _ titleColor: UIColor, _ titleFont: UIFont) -> UIButton {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(createButtonBackgroundColorImage(for: bgColor), for: .normal)
            button.setBackgroundImage(createButtonBackgroundColorImage(for: bgHighlightColor), for: .highlighted)
            button.setTitleColor(titleColor, for: .normal)
            button.titleLabel?.font = titleFont
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
