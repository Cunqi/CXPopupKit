//
//  CXToast.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/24/19.
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

public class CXToast: CXPopup {
    public init(_ text: String, _ duration: CXToastDuration = .short) {
        let toast = Toast(text, duration)
        let presenting = CXToast.getMostTopViewController()
        super.init(toast, toast.config.exportPopupConfig(), toast, presenting)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func getMostTopViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
}

class Toast: UIView, CXDialog {
    var config = CXToastConfig()
    private let toastDuration: CXToastDuration
    init(_ text: String, _ duration: CXToastDuration) {
        self.toastDuration = duration
        super.init(frame: .zero)
        setupToastLayout(text, config)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupToastLayout(_ toast: String, _ config: CXToastConfig) {
        var height: CGFloat = 0
        let label = UILabel()
        label.text = toast
        label.textAlignment = config.toastTextAligment
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = config.toastFont
        label.textColor = config.toastTextColor
        label.backgroundColor = .clear

        let maximumWidth = UIScreen.main.bounds.size.width - CXSpacing.spacing7
        let estimatedSize = CXTextUtil.getTextSize(
            for: toast,
            with: CGSize(width: maximumWidth, height: CGFloat(Double.greatestFiniteMagnitude)),
            font: config.toastFont)
        height = estimatedSize.height + CXSpacing.spacing4

        let layout = self
        layout.backgroundColor = config.backgroundColor

        CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(top: CXSpacing.spacing3, left: CXSpacing.spacing3, bottom: CXSpacing.spacing3, right: CXSpacing.spacing3))
        self.config.finalHeight = height
        self.config.finalWidth = ceil(estimatedSize.width) + CXSpacing.spacing4
    }
}

extension Toast: CXPopupLifeCycleDelegate {
    func viewDidLoad() {
        setupDelayDismiss()
    }

    private func setupDelayDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + toastDuration.duration) { [weak self] in
            self?.cxPopup?.dismiss(completion: nil)
        }
    }

    func viewDidDisappear() {
    }
}

struct CXToastConfig {
    var backgroundColor = UIColor(white: 0, alpha: 0.8)
    var toastFont = UIFont.systemFont(ofSize: 13.0)
    var toastTextColor = UIColor.white
    var toastTextAligment = NSTextAlignment.center
    var toastMinimumHeight: CGFloat = 44.0

    var finalHeight: CGFloat = 0
    var finalWidth: CGFloat = 0

    func exportPopupConfig() -> CXPopupConfig {
        var popupConfig = CXPopupConfig()
        popupConfig.layoutStyle = .bottomCenter(size: CGSize(width: finalWidth, height: finalHeight))
        popupConfig.layoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: CXSpacing.spacing6, right: 0)
        popupConfig.animationStyle = .fade
        popupConfig.animationTransition = CXAnimationTransition(.center)
        popupConfig.maskBackgroundColor = .clear
        return popupConfig
    }
}
