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
    init(_ text: String, _ config: CXToastConfig, _ vc: UIViewController?) {
        let toast = Toast(text, config)
        super.init(toast, toast.config.popupConfig, toast, vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class Toast: UIView, CXDialog {
        private(set) var config: CXToastConfig

        init(_ text: String, _ config: CXToastConfig) {
            self.config = config
            super.init(frame: .zero)
            setupToastLayout(text)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupToastLayout(_ toast: String) {
            let label = UILabel()
            label.text = toast
            label.textAlignment = config.toastTextAligment
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = config.toastFont
            label.textColor = config.toastTextColor
            label.backgroundColor = .clear

            let layout = self
            layout.backgroundColor = config.backgroundColor

            let maximumWidth = UIScreen.main.bounds.size.width - CXSpacing.spacing7
            let estimatedSize = CXTextUtil.getTextSize(
                for: toast,
                with: CGSize(width: maximumWidth, height: CGFloat(Double.greatestFiniteMagnitude)),
                font: config.toastFont)

            CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(CXSpacing.spacing3))
            let height = estimatedSize.height + CXSpacing.spacing4
            let finalSize = CGSize(width: ceil(estimatedSize.width) + CXSpacing.spacing4, height: height)
            self.config.popupConfig.layoutStyle.update(size: finalSize)
        }
    }

    private static func getMostTopViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }

    public class Builder {
        private let message: String
        private var config = CXToastConfig()

        public init(_ message: String) {
            self.message = message
        }

        public func withDuration(_ duration: CXToastDuration) -> Self {
            self.config.toastDuration = duration
            return self
        }

        public func create() -> CXToast {
            let vc = CXToast.getMostTopViewController()
            return CXToast(message, config, vc)
        }
    }
}

extension CXToast.Toast: CXPopupLifeCycleDelegate {
    func viewDidLoad() {
        setupDelayDismiss()
    }

    private func setupDelayDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + config.toastDuration.duration) { [weak self] in
            self?.cxPopup?.dismiss()
        }
    }
}

struct CXToastConfig {
    var backgroundColor = UIColor(white: 0, alpha: 0.8)
    var toastFont = UIFont.systemFont(ofSize: 13.0)
    var toastTextColor: UIColor = .white
    var toastTextAligment: NSTextAlignment = .center
    var toastMinimumHeight: CGFloat = 44.0
    var toastDuration: CXToastDuration = .short

    var popupConfig: CXPopupConfig

    init() {
        popupConfig = CXPopupConfig()
        popupConfig.layoutStyle = .bottomCenter(size: .zero)
        popupConfig.layoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: CXSpacing.spacing6, right: 0)
        popupConfig.animationStyle = .fade
        popupConfig.animationTransition = CXAnimationTransition(.center)
        popupConfig.maskBackgroundColor = .clear
    }
}
