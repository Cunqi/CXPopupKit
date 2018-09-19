//
//  CXAlert.swift
//  CXPopupKit
//
//  Created by Cunqi on 9/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public typealias CXAlertAction = (String) -> Void

public enum CXAlertType {
    case alert
    case actionSheet
    
    var popupAppearance: CXPopupAppearance {
        var appearance = CXPopupAppearance()
        appearance.backgroundColor = .white
        
        switch self {
        case .alert:
            appearance.shouldDismissOnBackgroundTap = false
            appearance.animationTransition = CXAnimationTransition(in: .center)
            appearance.animationStyle = .pop
            appearance.width = .fixed(value: 270)
        case.actionSheet:
            appearance.position = .init(horizontal: .center, vertical: .bottom)
            appearance.width = .full
            appearance.safeAreaType = .wrapped
            appearance.animationTransition = CXAnimationTransition(in: .up)
            appearance.animationStyle = .basic
        }
        return appearance
    }
}

enum CXDividerPosition {
    case top
    case bottom
    case left
    case right
}

public class CXAlertBuilder {
    let alert: CXAlert
    let popupBuilder: CXPopupBuilder

    var popupAppearance: CXPopupAppearance

    public init(type: CXAlertType, at presenting: UIViewController?) {
        self.alert = CXAlert(type)
        self.popupBuilder = CXPopupBuilder(content: self.alert, presenting: presenting)
        self.popupAppearance = type.popupAppearance
    }

    public func withTitle(_ title: String) -> Self {
        self.alert.titleText = title
        return self
    }

    public func withMessage(_ message: String) -> Self {
        self.alert.messageText = message
        return self
    }

    public func withConfirmText(_ confirm: String) -> Self {
        self.alert.actionTexts = [confirm]
        return self
    }

    public func withCancelText(_ cancelText: String) -> Self {
        self.alert.cancelText = cancelText
        return self
    }

    public func withActions(_ actions: [String]) -> Self {
        self.alert.actionTexts = actions
        return self
    }

    public func withCancelAction( _ cancelAction: @escaping CXSimpleAction) -> Self {
        self.alert.cancelAction = cancelAction
        return self
    }
    
    public func withConfirmAction(_ confirmAction: @escaping CXAlertAction) -> Self {
        self.alert.confirmAction = confirmAction
        return self
    }

    public func withModal(_ enabled: Bool) -> Self {
        self.popupAppearance.shouldDismissOnBackgroundTap = enabled
        return self
    }

    public func withAlertConfiguration(_ configuration: @escaping (UILabel, UILabel, [UIButton]) -> Void) -> Self {
        self.alert.alertConfiguration = configuration
        return self
    }

    public func build() -> CXPopupWindow & UIViewController {
        updateAlertAndAppearance()
        return popupBuilder.withAppearance(popupAppearance).build()
    }
    
    func updateAlertAndAppearance() {
        self.alert.setupLayout()
        self.popupAppearance.height = .fixed(value: self.alert.finalHeight)
    }
}

class CXAlert: UIView, CXPopupable {
    static let buttonHeight: CGFloat = 44
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let alertType: CXAlertType
    
    var titleText: String?
    var messageText: String?
    var actionTexts = [String]()
    var cancelText: String?

    var confirmAction: CXAlertAction?
    var cancelAction: CXSimpleAction?
    var finalHeight: CGFloat = 0
    var actionButtons = [UIButton]()
    var alertConfiguration: ((UILabel, UILabel, [UIButton]) -> Void)?

    init(_ type: CXAlertType) {
        self.alertType = type
        super.init(frame: .zero)
    }
    
    func setupLayout() {
        setupTitleLabel()
        setupMessageLabel()
        setupActionButtons()

        alertConfiguration?(titleLabel, messageLabel, actionButtons)
        
        layoutTitleLabel()
        layoutMessageLabel()
        layoutActionButtons()
    }
    
    private func setupTitleLabel() {
        self.titleLabel.text = titleText
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    private func layoutTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if let titleText = titleText {
            let width = alertType.popupAppearance.width.getValue(based: UIScreen.screenSize().width)
            let textWidth = width - CXSpacing.item8.value
            let estimatedSize = CGSize(width: textWidth, height: CGFloat(Double.greatestFiniteMagnitude))
            let finalTitleHeight = CXTextUtil.getTextSize(for: titleText, with: estimatedSize, font: titleLabel.font).height + CXSpacing.item4.value
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CXSpacing.item4.value).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CXSpacing.item4.value).isActive = true
            titleLabel.heightAnchor.constraint(equalToConstant: finalTitleHeight).isActive = true
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CXSpacing.item2.value).isActive = true
            finalHeight += (finalTitleHeight + CXSpacing.item2.value)
        } else {
            makeLabelInvisible(titleLabel)
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setupMessageLabel() {
        self.messageLabel.text = messageText
        self.messageLabel.textAlignment = .center
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = .byWordWrapping
        self.messageLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func layoutMessageLabel() {
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        if let messageText = messageText {
            let width = alertType.popupAppearance.width.getValue(based: UIScreen.screenSize().width)
            let textWidth = width - CXSpacing.item6.value
            let estimatedSize = CGSize(width: textWidth, height: CGFloat(Double.greatestFiniteMagnitude))
            let finalMessageHeight = CXTextUtil.getTextSize(for: messageText, with: estimatedSize, font: messageLabel.font).height + CXSpacing.item2.value
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CXSpacing.item3.value).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CXSpacing.item3.value).isActive = true
            messageLabel.heightAnchor.constraint(equalToConstant: finalMessageHeight).isActive = true
            finalHeight += finalMessageHeight
        } else {
            makeLabelInvisible(messageLabel)
        }
        messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func makeLabelInvisible(_ label: UILabel) {
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }

    private func setupActionButtons() {
        if let cancelText = self.cancelText {
            actionTexts.append(cancelText)
            if alertType == .alert && actionTexts.count == 2 {
                actionTexts = actionTexts.reversed()
            }
        }
        for (index, actionText) in actionTexts.enumerated() {
            let action = UIButton(type: .custom)
            action.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            action.tag = index
            action.setTitle(actionText, for: .normal)
            action.setTitleColor(.darkGray, for: .normal)
            action.setBackgroundImage(createHighlightedImage(), for: .highlighted)
            action.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
            actionButtons.append(action)
        }
    }

    private func createHighlightedImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor(white: 0.95, alpha: 0.9).cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private func layoutActionButtons() {
        let stackView = UIStackView(arrangedSubviews: actionButtons)
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = (actionButtons.count > 2 || alertType == .actionSheet) ? .vertical : .horizontal
        self.addSubview(stackView)

        for button in actionButtons {
            attachDividerOnButton(button, .top)
        }

        if actionButtons.count == 2 {
            attachDividerOnButton(actionButtons[0], .right)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: CXSpacing.item2.value).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        if alertType == .alert && actionButtons.count == 2 {
            finalHeight += CXAlert.buttonHeight
        } else {
            finalHeight += (CXAlert.buttonHeight * CGFloat(actionButtons.count))
        }
    }

    private func attachDividerOnButton(_ button: UIButton, _ position: CXDividerPosition) {
        let divider = UIView()
        divider.backgroundColor = UIColor(white: 0, alpha: 0.15)
        self.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false

        if position == .top || position == .bottom {
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
            divider.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        } else {
            divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
            divider.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
            divider.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        }

        switch position {
        case .top:
            divider.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        case .bottom:
            divider.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        case .left:
            divider.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        case .right:
            divider.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        }
    }

    @objc private func didTapActionButton(_ sender: UIButton) {
        let index = sender.tag
        let action = actionTexts[index]
        confirmAction?(action)
        popupWindow?.close()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
