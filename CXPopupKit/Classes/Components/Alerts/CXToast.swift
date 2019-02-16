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
            let labelLayout = LabelLayoutBuilder(toast)
                    .withFont(config.toastFont)
                    .withTextColor(config.toastTextColor)
                    .withBackgroundColor(config.backgroundColor)
                    .withEstimateWidth(UIScreen.main.bounds.width * 0.8)
                    .withInsets(UIEdgeInsets(CXSpacing.spacing3))
                    .build()
            CXLayoutUtil.fill(labelLayout.view, at: self)
            self.config.popupConfig.layoutStyle.update(size: labelLayout.size)
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
    var toastTextAlignment: NSTextAlignment = .center
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
