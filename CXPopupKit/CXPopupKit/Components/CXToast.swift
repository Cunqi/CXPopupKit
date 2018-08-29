//
//  CXToast.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/29/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public enum CXToastDuration {
    case short
    case long
    case custom(duration: TimeInterval)

    var duration: TimeInterval {
        switch self {
        case .short:
            return 1.5
        case .long:
            return 3
        case .custom(let duration):
            return duration
        }
    }
}

public struct CXToastAppearance {

}

public class CXToastBuilder {
    let toast: CXToast
    let popupBuilder: CXPopupBuilder

    var popupAppearance: CXPopupAppearance = {
        var appearance = CXPopupAppearance()
        appearance.allOutsideDismiss = false
        appearance.backgroundColor = .clear
        appearance.isShadowEnabled = false
        appearance.maskBackgroundAlpha = 0
        appearance.maskBackgroundColor = .clear
        appearance.animationTransition = CXAnimationTransition.init(in: .center)
        appearance.animationStyle = .fade
        return appearance
    }()
    
    public init(message: String) {
        self.toast = CXToast(message: message)
        popupBuilder = CXPopupBuilder(content: self.toast, presenting: UIScreen.getMostTopViewController())
        updateToastAppearance()
    }

    public init(attributedMessage: NSAttributedString) {
        self.toast = CXToast(attributedMessage: attributedMessage)
        popupBuilder = CXPopupBuilder(content: self.toast, presenting: UIScreen.getMostTopViewController())
        updateToastAppearance()
    }

    private func updateToastAppearance() {
        popupAppearance.height = .fixed(value: toast.calculateHeightAndUpdateWidth())
        popupAppearance.position = CXPosition(horizontal: .center, vertical: .custom(y: UIScreen.getCustomY(for: 0.2)))
    }

    public func withDuration(duration: CXToastDuration) -> Self {
        toast.toastDuration = duration
        return self
    }

    public func withToastLabelConfiguration(_ configuration: @escaping (UILabel) -> Void) -> Self {
        toast.toastLabelConfiguration = configuration
        return self
    }

    public func build() -> CXPopupWindow & UIViewController {
        return popupBuilder
            .withViewDidAppear(toast.setupDelayDismiss)
            .withAppearance(popupAppearance)
            .build()
    }
}

class CXToast: UIView, CXPopupable {
    static let maximumWidth = UIScreen.main.bounds.width - 32 * 2
    static let minimumHeight: CGFloat = 36
    static let padding: CGFloat = 8 * 2

    let toastLabel: UILabel
    var toastDuration: CXToastDuration = .short
    var toastLabelConfiguration: ((UILabel) -> Void)?

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
            self?.popupWindow?.close()
        }
    }

    func calculateHeightAndUpdateWidth() -> CGFloat {
        let estimateSize = CGSize(width: CXToast.maximumWidth, height: CGFloat(Double.greatestFiniteMagnitude))
        if let text = toastLabel.text as NSString? {
            let size = text.boundingRect(with: estimateSize,
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     attributes: [.font: toastLabel.font], context: nil)
                    .size
            toastLabel.widthAnchor.constraint(equalToConstant: min(size.width + CXToast.padding, CXToast.maximumWidth)).isActive = true
            return max(size.height + CXToast.padding, CXToast.minimumHeight)
        } else if let attributedText = toastLabel.attributedText {
            let size = attributedText.boundingRect(with: estimateSize,
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               context: nil)
                    .size
            toastLabel.widthAnchor.constraint(equalToConstant: min(size.width + CXToast.padding, CXToast.maximumWidth)).isActive = true
            return max(size.height + CXToast.padding, CXToast.minimumHeight)
        } else {
            return 0
        }
    }
}
