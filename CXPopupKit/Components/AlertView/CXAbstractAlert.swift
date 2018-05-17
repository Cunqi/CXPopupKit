//
// Created by Cunqi Xiao on 5/16/18.
// Copyright (c) 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

public class CXAbstractAlert: UIView {
    struct CXAlertContent {
        let title: String?
        let message: String?
        let cancelButtonTitle: String?
        let actionButtonTitles: [String]
    }

    static let cancelButtonTag = -1

    public var appearance: CXPopupAppearance
    public var alertAppearance: CXAlertAppearance

    public let titleLabel = UILabel()
    public let messageLabel = UILabel()
    public var actionButtons = [UIButton]()

    let stackView = UIStackView()
    let stackViewBackgroundView = UIView()
    let content: CXAlertContent
    let layoutStrategy: CXAlertViewLayoutStrategy

    init(layoutStrategy strategy: CXAlertViewLayoutStrategy, title: String?, message: String?, cancel: String?, actions: [String]) {
        self.layoutStrategy = strategy
        self.alertAppearance = CXAlertAppearance()
        self.content = CXAlertContent(title: title, message: message, cancelButtonTitle: cancel, actionButtonTitles: actions)
        self.appearance = CXPopupAppearance()
        super.init(frame: .zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        backgroundColor = appearance.uiStyle.popupBackgroundColor
        layer.cornerRadius = alertAppearance.dimension.cornerRadius
        layer.masksToBounds = true

        setupTitleLabel()
        setupMessageLabel()
        setupActionButton()
        setupStackViewBackground()
    }

    func setupTitleLabel() {
        titleLabel.text = content.title
        titleLabel.font = alertAppearance.font.title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = .clear
        addSubview(titleLabel)
    }

    func setupMessageLabel() {
        messageLabel.text = content.message
        messageLabel.font = alertAppearance.font.detail
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        addSubview(messageLabel)
    }

    func setupActionButton() {
        for actionTitle in content.actionButtonTitles {
            actionButtons.append(getActionButton(with: actionTitle))
        }

        if let cancelButtonTitle = content.cancelButtonTitle {
            let cancelButton = getActionButton(with: cancelButtonTitle)
            cancelButton.tag = CXAbstractAlert.cancelButtonTag
            actionButtons.append(cancelButton)
        }

        actionButtons.forEach {
            stackView.addArrangedSubview($0)
        }
    }

    func getActionButton(with buttonTitle: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = alertAppearance.font.action
        button.backgroundColor = alertAppearance.color.actionBackground
        button.setTitleColor(alertAppearance.color.actionTitle, for: .normal)
        button.addTarget(self, action: #selector(actionTriggered(button:)), for: .touchUpInside)
        return button
    }

    func setupStackViewBackground() {
        self.addSubview(stackViewBackgroundView)
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = layoutStrategy.layoutAxis(count: actionButtons.count)

        if alertAppearance.separator.isEnabled {
            stackViewBackgroundView.backgroundColor = alertAppearance.separator.color
            stackView.spacing = alertAppearance.separator.width
        }

        stackViewBackgroundView.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalTo(stackViewBackgroundView)
            maker.top.equalTo(stackViewBackgroundView).offset(1)
        }

        stackViewBackgroundView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalTo(self)
            maker.top.equalTo(self.messageLabel.snp.bottom).offset(alertAppearance.dimension.messageMargin.bottom)
        }
    }

    func setupLayout() {
        var height: CGFloat = 0
        height += layoutStrategy.layout(titleLabel: titleLabel, at: self, alertAppearance: alertAppearance, appearance: appearance)
        height += layoutStrategy.layout(messageLabel: messageLabel, based: titleLabel, at: self, alertAppearance: alertAppearance, appearance: appearance)
        height += layoutStrategy.layout(isVertical: stackView.axis == .vertical, actionCount: actionButtons.count, stackViewBackgroundView: stackViewBackgroundView, based: messageLabel, at: self, alertAppearance: alertAppearance, appearance: appearance)
        appearance.dimension.height = .fixValue(size: height)
    }

    @objc func actionTriggered(button: UIButton) {
    }
}
