//
//  CXAbstractAlertView.swift
//  CXPopupKit
//
//  Created by Cunqi on 10/2/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXAbstractAlertView: UIView, CXPopupable {
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    var titleText: String? {
        didSet {
            self.titleLabel.text = titleText
        }
    }

    var messageText: String? {
        didSet {
            self.messageLabel.text = messageText
        }
    }

    var actions = [CXAlertAction]()
    var cancelAction: CXAlertAction?

    var popupAppearance = CXPopupAppearance()

    var finalHeight: CGFloat = 0 {
        didSet {
            self.popupAppearance.height = .fixed(value: finalHeight)
        }
    }

    init() {
        super.init(frame: .zero)
        setupPopupAppearance()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // override by subclasses
    func setupPopupAppearance() {
    }

    func addConfirmAction(_ confirm: String, _ handler: CXAlertActionHandler?) {
        self.addActions([confirm], handler)
    }

    func addActions(_ actions: [String], _ handler: CXAlertActionHandler?) {
        self.actions = actions.map {
            return CXAlertAction($0, .default) { [weak self] actionText in
                handler?(actionText)
                self?.popupController?.close()
            }
        }
    }

    func addCancelAction(_ cancel: String, _ handler: CXAlertActionHandler?) {
        self.cancelAction = CXAlertAction(cancel, .cancel) { [weak self] actionText in
            handler?(actionText)
            self?.popupController?.close()
        }
    }

    func render() -> Self {
        layout()
        return self
    }

    func setup() {
        setupTitleLabel()
        setupMessageLabel()
    }

    private func setupTitleLabel() {
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.titleLabel.textColor = CXColorStyle.important
    }

    private func setupMessageLabel() {
        self.messageLabel.textAlignment = .center
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = .byWordWrapping
        self.messageLabel.font = UIFont.systemFont(ofSize: 13)
        self.messageLabel.textColor = CXColorStyle.normal
    }

    func layout() {
        layoutTitleLabel()
        layoutMessageLabel()
        layoutActions()
    }

    // override by subclasses
    func layoutActions() {
        guard !actions.isEmpty else {
            return
        }
    }

    private func layoutTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CXSpacing.item4.value).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CXSpacing.item4.value).isActive = true

        guard let mTitleText = titleText else {
            titleLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            return
        }
        let width = popupAppearance.width.getValue(based: UIScreen.screenSize().width)
        let finalTitleHeight = CXTextUtil.getTextSize(for: mTitleText,
                                                      with: CGSize(width: width - CXSpacing.item8.value, height: CGFloat(Double.greatestFiniteMagnitude)),
                                                      font: titleLabel.font
            ).height + CXSpacing.item2.value
        titleLabel.heightAnchor.constraint(equalToConstant: finalTitleHeight).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CXSpacing.item2.value).isActive = true

        // Update total height
        finalHeight += (finalTitleHeight + CXSpacing.item2.value)
    }

    private func layoutMessageLabel() {
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CXSpacing.item2.value).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CXSpacing.item2.value).isActive = true
        messageLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        guard let mMessageText = messageText else {
            messageLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            return
        }

        let width = popupAppearance.width.getValue(based: UIScreen.screenSize().width)
        let finalMessageHeight = CXTextUtil.getTextSize(for: mMessageText,
                                                      with: CGSize(width: width - CXSpacing.item8.value, height: CGFloat(Double.greatestFiniteMagnitude)),
                                                      font: messageLabel.font
            ).height + CXSpacing.item2.value
        messageLabel.heightAnchor.constraint(equalToConstant: finalMessageHeight).isActive = true

        // Update total height
        finalHeight += (finalMessageHeight + CXSpacing.item2.value)
    }
}
