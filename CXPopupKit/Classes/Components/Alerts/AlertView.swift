//
//  AlertView.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/23/19.
//

import UIKit

class AlertView: UIView, CXDialog {
    var config: CXAlertConfig
    private var finalHeight: CGFloat = 0
    private var tappableArray: [CXTappable]
    
    init(
        config: CXAlertConfig,
        title: String?,
        message: String?,
        tappableArray: [CXTappable]) {
        self.config = config
        self.tappableArray = tappableArray
        super.init(frame: .zero)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        setupLabelLayout(title, message, at: stackView)
        setupButtonLayout(at: stackView, config: self.config)
        CXLayoutUtil.fill(stackView, at: self)
        self.config.popupConfig.layoutStyle.update(size: CGSize(width: config.style.width, height: finalHeight))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabelLayout(_ title: String?, _ message: String?, at stackView: UIStackView) {
        if let title = title {
            let titleLabelLayout = LabelLayoutBuilder(title)
                    .withBackgroundColor(config.backgroundColor)
                    .withEstimateWidth(config.style.width - CXSpacing.spacing5)
                    .withInsets(UIEdgeInsets(CXSpacing.spacing4))
                    .withTextColor(config.titleColor)
                    .withFont(config.titleFont)
                    .build()
            stackView.addArrangedSubview(titleLabelLayout.view)
            titleLabelLayout.view.heightAnchor.constraint(equalToConstant: titleLabelLayout.size.height).isActive = true
            finalHeight += titleLabelLayout.size.height
        }

        if let message = message {
            let messageInsets = title == nil ? UIEdgeInsets(CXSpacing.spacing4) :
                    UIEdgeInsets(top: 0, left: CXSpacing.spacing4, bottom: CXSpacing.spacing4, right: CXSpacing.spacing4)
            let messageLabelLayout = LabelLayoutBuilder(message)
                    .withBackgroundColor(config.backgroundColor)
                    .withEstimateWidth(config.style.width)
                    .withInsets(messageInsets)
                    .withTextColor(config.messageColor)
                    .withFont(config.messageFont)
                    .withTextAlignment(config.messageTextAlignment)
                    .build()

            stackView.addArrangedSubview(messageLabelLayout.view)
            messageLabelLayout.view.heightAnchor.constraint(equalToConstant: messageLabelLayout.size.height).isActive = true
            finalHeight += messageLabelLayout.size.height
        }
    }
    
    private func setupButtonLayout(at stackView: UIStackView, config: CXAlertConfig) {
        let buttons = tappableArray.map {
            return ButtonLayoutBuilder()
                .withFont(config.buttonFont)
                .withTitle($0.text, state: .normal)
                .withTitleColor(config.buttonTitleColor, state: .normal)
                .withBackgroundImage(config.buttonColor.asImage(), state: .normal)
                .withBackgroundImage(config.buttonHighlightColor.asImage(), state: .highlighted)
                .withTarget(self, action: #selector(didTapButton(sender:)))
                .build()
        }
        
        guard !buttons.isEmpty else {
            return
        }
        
        let buttonLayout = UIView()
        let buttonStackView = UIStackView()
        let isVertical = config.style == .actionSheet || buttons.count > 2
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 1.0
        buttonStackView.axis = isVertical ? .vertical : .horizontal
        buttons.forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        buttonLayout.backgroundColor = config.buttonDividerColor
        CXLayoutUtil.fill(buttonStackView, at: buttonLayout, insets: UIEdgeInsets(top: 1.0, left: 0, bottom: 0, right: 0))
        stackView.addArrangedSubview(buttonLayout)
        finalHeight += isVertical ? config.buttonHeight * CGFloat(buttons.count) : config.buttonHeight
    }
    
    @objc private func didTapButton(sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        
        let responsors = tappableArray.filter { $0.text == title }
        
//        self.cxPopup?.dismiss({
//            responsors.forEach { $0.handler(title) }
//        })
        self.popupController?.dismiss()
    }
}
