//
//  CXToast.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/29/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXToast: UIView, CXPopupable {
    static let maximumWidth = UIScreen.main.bounds.width - CXSpacing.item8.value * 2
    static let minimumHeight: CGFloat = CXSpacing.item9.value
    static let padding: CGFloat = CXSpacing.item4.value

    let toastLabel: UILabel
    var toastDuration: CXToastDuration = .short
    var toastLabelConfiguration: ((UILabel) -> Void)?

    var popupAppearance: CXPopupAppearance = {
        var appearance = CXPopupAppearance()
        appearance.shouldDismissOnBackgroundTap = false
        appearance.backgroundColor = .clear
        appearance.isShadowEnabled = false
        appearance.maskBackgroundAlpha = 0
        appearance.maskBackgroundColor = .clear
        appearance.animationTransition = CXAnimationTransition.init(in: .center)
        appearance.animationStyle = .fade
        return appearance
    }()

    init(message: String) {
        self.toastLabel = UILabel()
        toastLabel.text = message
        super.init(frame: .zero)
        setupToastLabel()
    }

    init(attributedMessage: NSAttributedString) {
        self.toastLabel = UILabel()
        toastLabel.attributedText = attributedMessage
        super.init(frame: .zero)
        setupToastLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupToastLabel() {
        toastLabel.backgroundColor = UIColor(white: 0, alpha: 0.8)
        toastLabel.textColor = .white
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 4
        toastLabel.layer.masksToBounds = true
        toastLabelConfiguration?(toastLabel)
        setupLayout()
        updateHeightAndPosition()
    }

    private func setupLayout() {
        self.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: CXToast.maximumWidth).isActive = true
        toastLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func setupDelayDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + toastDuration.duration) { [weak self] in
            self?.popupController?.close()
        }
    }

    func updateHeightAndPosition() {
        let finalHeight: CGFloat
        let estimateSize = CGSize(width: CXToast.maximumWidth, height: CGFloat(Double.greatestFiniteMagnitude))
        if let text = toastLabel.text {
            let size = CXTextUtil.getTextSize(for: text, with: estimateSize, font: toastLabel.font)
            toastLabel.widthAnchor.constraint(equalToConstant: min(size.width + CXToast.padding, CXToast.maximumWidth)).isActive = true
            finalHeight = max(size.height + CXToast.padding, CXToast.minimumHeight)
        } else if let attributedText = toastLabel.attributedText {
            let size = CXTextUtil.getTextSize(for: attributedText, with: estimateSize)
            toastLabel.widthAnchor.constraint(equalToConstant: min(size.width + CXToast.padding, CXToast.maximumWidth)).isActive = true
            finalHeight = max(size.height + CXToast.padding, CXToast.minimumHeight)
        } else {
            finalHeight = 0
        }
        popupAppearance.height = .fixed(value: finalHeight)
        popupAppearance.position = CXPosition(horizontal: .center, vertical: .custom(y: UIScreen.getCustomY(for: 0.2)))
    }
}
