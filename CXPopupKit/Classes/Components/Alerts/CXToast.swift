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

public class CXToast: UIView, CXDialog {
    @objc public dynamic var font: UIFont {
        get { return label.font }
        set { label.font = newValue }
    }

    @objc public dynamic var textColor: UIColor {
        get { return label.textColor }
        set { label.textColor = newValue }
    }

    @objc public dynamic var textAlignment: NSTextAlignment {
        get { return label.textAlignment }
        set { label.textAlignment = newValue }
    }

    @objc public dynamic var numberOfLines: Int {
        get { return label.numberOfLines }
        set { label.numberOfLines = newValue }
    }

    @objc public dynamic var lineBreakMode: NSLineBreakMode {
        get { return label.lineBreakMode }
        set { label.lineBreakMode = newValue }
    }

    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.white
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()

    lazy var appearance: CXPopupAppearance = {
        var popupAppearance = CXPopupAppearance()
        popupAppearance.layoutStyle = .bottomCenter(size: .zero)
        popupAppearance.layoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: CXSpacing.spacing6, right: 0)
        popupAppearance.animationStyle = .fade
        popupAppearance.animationTransition = CXAnimationTransition(.center)
        popupAppearance.maskBackgroundColor = .clear
        return popupAppearance
    }()

    private let duration: CXToastDuration

    public init(text: String, duration: CXToastDuration = .short) {
        self.duration = duration
        super.init(frame: .zero)
        self.label.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let insets: UIEdgeInsets = UIEdgeInsets(top: CXSpacing.spacing3,
                                                left: CXSpacing.spacing4,
                                                bottom: CXSpacing.spacing3,
                                                right: CXSpacing.spacing4)

        CXLayoutBuilder.fill(label, self, insets)
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 340).isActive = true
    }

    private static func getMostTopViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
}

extension CXToast: CXPopupable {
    public func toast() {
        pop(on: CXToast.getMostTopViewController())
    }

    public func pop(on vc: UIViewController?) {
        CXPopupController(self, appearance: appearance, self).pop(on: vc)
    }
}

extension CXToast: CXPopupLifecycleDelegate {
    public func viewDidLoad() {
        layout()
        setupDelayDismiss()
    }

    private func setupDelayDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.duration.duration) { [weak self] in
            self?.popupController?.dismiss()
        }
    }
}
