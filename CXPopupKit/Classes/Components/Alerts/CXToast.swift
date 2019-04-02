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

    var duration: CXToastDuration = .short
    private let estimateWidth: CGFloat = 340

    lazy var config: CXPopupConfig = {
        var popupConfig = CXPopupConfig()
        popupConfig.layoutStyle = .bottomCenter(size: .zero)
        popupConfig.layoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: CXSpacing.spacing6, right: 0)
        popupConfig.animationStyle = .fade
        popupConfig.animationTransition = CXAnimationTransition(.center)
        popupConfig.maskBackgroundColor = .clear
        return popupConfig
    }()

    public init(_ text: String, _ duration: CXToastDuration = .short) {
        super.init(frame: .zero)
        label.text = text
        self.duration = duration
        self.backgroundColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let insets: UIEdgeInsets = UIEdgeInsets(top: CXSpacing.spacing3, left: CXSpacing.spacing4, bottom: CXSpacing.spacing3, right: CXSpacing.spacing4)
        let estimateSize = CGSize(width: estimateWidth, height: CGFloat(Double.greatestFiniteMagnitude))
        let calculatedSize = CXTextUtil.getTextSize(for: label.text ?? "", with: estimateSize, font: label.font)
        let finalSize = CGSize(width: ceil(calculatedSize.width) + insets.horizontal, height: ceil(calculatedSize.height) + insets.vertical)
        CXLayoutUtil.fill(label, at: self, insets: insets)
        config.layoutStyle.update(size: finalSize)
    }

    private static func getMostTopViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }

    public func toast() {
        setupLayout()
        CXPopup.Builder(self)
            .withConfig(config)
            .withDelegate(self)
            .create(on: CXToast.getMostTopViewController())
            .pop()
    }
}

extension CXToast: CXPopupLifeCycleDelegate {
    public func viewDidLoad() {
        setupDelayDismiss()
    }

    private func setupDelayDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.duration.duration) { [weak self] in
            self?.cxPopup?.dismiss()
        }
    }
}
