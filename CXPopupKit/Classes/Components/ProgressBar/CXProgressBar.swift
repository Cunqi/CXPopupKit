//
//  CXProgressBar.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 2/6/19.
//

import UIKit

public enum CXProgressBarStyle {
    case line
    case circle
    case ring
}

public enum CXProgressBarSize {
    case small
    case medium
    case large
    case custom(size: CGSize)
}

public class CXProgressBar: CXPopup, CXProgressBarUpdatable {
    private let progressBarView: ProgressBarWrapperView
    init(_ style: CXProgressBarStyle, _ format: String?, _ config: CXProgressConfig, _ vc: UIViewController?) {
        self.progressBarView = ProgressBarWrapperView(style, format, config)
        super.init(progressBarView, progressBarView.config.popupConfig, progressBarView, vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateProgress(_ progress: CGFloat) {
        guard Thread.isMainThread else {
            return
        }
        progressBarView.updateProgress(progress)
    }

    class ProgressBarWrapperView: UIView, CXDialog, CXProgressBarUpdatable, CXPopupLifecycleDelegate {
        typealias Layout = (view: UIView, size: CGSize)
        
        var config: CXProgressConfig
        private(set) var progressBar: CXProgressBarView
        private(set) var messageLabel: UILabel?
        private let style: CXProgressBarStyle
        private var msgFormat: String?
        
        init(_ style: CXProgressBarStyle, _ format: String?, _ config: CXProgressConfig) {
            self.style = style
            self.msgFormat = format
            self.config = config
            self.progressBar = CXProgressBarView.create(for: style)
            self.progressBar.config = config
            super.init(frame: .zero)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            backgroundColor = config.backgroundColor

            let msgLayout = createMessageLayout(msgFormat, config)
            let msgLayoutSize = msgLayout?.size ?? .zero
            let progressBarLayout = createProgressBarLayout(config.progressBarSize, msgLayoutSize.width)
            
            let stackView = UIStackView(arrangedSubviews: [msgLayout?.view, progressBarLayout.view].compactMap { $0 })
            stackView.axis = .vertical
            stackView.distribution = .fill
            CXLayoutUtil.fill(stackView, at: self)

            let finalSize = CGSize(
                width: progressBarLayout.size.width,
                height: progressBarLayout.size.height + msgLayoutSize.height)
            config.popupConfig.layoutStyle.update(size: finalSize)
        }

        private func createProgressBarLayout(_ barSize: CXProgressBarSize, _ msgWidth: CGFloat) -> Layout {
            let layout = UIView()
            layout.backgroundColor = .clear
            
            switch style {
            case .line:
                let height = 3 * CXSpacing.spacing3
                let minimumWidth = UIScreen.main.bounds.size.width * 0.6 + CXSpacing.spacing4

                CXLayoutUtil.fill(progressBar, at: layout, insets: UIEdgeInsets(CXSpacing.spacing3))
                layout.heightAnchor.constraint(equalToConstant: height).isActive = true
                return (layout, CGSize(width: max(msgWidth, minimumWidth), height: height))
            case .ring, .circle:
                let barWidth = barSize.size.width + CXSpacing.spacing4
                let height = barSize.size.height + CXSpacing.spacing4
                let hPadding: CGFloat = max((msgWidth - barSize.size.width) / 2.0, CXSpacing.spacing3)
                let vPadding: CGFloat = CXSpacing.spacing3
                CXLayoutUtil.fill(
                    progressBar,
                    at: layout,
                    insets: UIEdgeInsets(top: vPadding, left: hPadding, bottom: vPadding, right: hPadding))
                layout.heightAnchor.constraint(equalToConstant: height).isActive = true
                return (layout, CGSize(width: max(msgWidth, barWidth), height: height))
            }
        }

        private func createMessageLayout(_ messageFormat: String?, _ config: CXProgressConfig) -> Layout? {
            guard let msgFormat = messageFormat else {
                return nil
            }
            let label = UILabel()
            label.text = msgFormat
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = config.messageFont
            label.textColor = config.messageTextColor
            label.backgroundColor = .clear
            messageLabel = label

            let maximumWidth = UIScreen.main.bounds.size.width * 0.8
            let estimatedSize = CXTextUtil.getTextSize(
                for: msgFormat,
                with: CGSize(width: maximumWidth, height: CGFloat(Double.greatestFiniteMagnitude)),
                font: config.messageFont)
            let height = estimatedSize.height + CXSpacing.spacing3

            let layout = UIView()
            layout.backgroundColor = UIColor.clear
            layout.heightAnchor.constraint(equalToConstant: height).isActive = true

            CXLayoutUtil.fill(
                label,
                at: layout,
                insets: UIEdgeInsets(top: 0, left: CXSpacing.spacing3, bottom: CXSpacing.spacing3, right: CXSpacing.spacing3))
            return (layout, CGSize(width: ceil(estimatedSize.width) + CXSpacing.spacing4, height: height))
        }

        func updateProgress(_ progress: CGFloat) {
            progressBar.updateProgress(progress)
            guard let format = msgFormat else {
                return
            }
            messageLabel?.text = String(format: format, progress * 100)
        }

        func updateConfig() -> CXProgressConfig {
            return config
        }

        func viewDidLoad() {
            updateProgress(0)
        }
    }

    public class Builder {
        private let style: CXProgressBarStyle
        private var format: String?
        private var config = CXProgressConfig()

        public init(_ style: CXProgressBarStyle) {
            self.style = style
        }

        public func withMessageFormat(_ format: String) -> Self {
            self.format = format
            return self
        }

        public func withConfig(_ config: CXProgressConfig) -> Self {
            self.config = config
            return self
        }

        public func create(on vc: UIViewController?) -> CXProgressBar {
            return CXProgressBar(style, format, config, vc)
        }
    }
}

public struct CXProgressConfig {
    public var backgroundColor = UIColor.white
    public var barBackgroundColor = UIColor(white: 0.95, alpha: 1.0)
    public var barForegroundColor = UIColor.black
    public var progressWidth: CGFloat = 8.0
    public var progressBarSize: CXProgressBarSize = .small
    public var messageFont = UIFont.systemFont(ofSize: 13.0)
    public var messageTextColor = UIColor.black
    public var popupConfig: CXPopupAppearance

    // internal properties
    var lineProgressBarBorderWidth: CGFloat = 1.0
    var lineProgressBarCornerRadius: CGFloat = 3.0

    public init() {
        popupConfig = CXPopupAppearance()
        popupConfig.layoutStyle = .center(size: .zero)
        popupConfig.isAutoRotateEnabled = false
        popupConfig.maskBackgroundColor = .clear
        popupConfig.animationTransition = CXAnimationTransition(.center)
        popupConfig.animationStyle = .pop
        popupConfig.allowTouchOutsideToDismiss = false
    }
}

extension CXProgressBarView {
    static func create(for style: CXProgressBarStyle) -> CXProgressBarView {
        switch style {
        case .line:
            return CXLineProgressBar()
        case .circle:
            return CXCircleProgressBar()
        case .ring:
            return CXRingProgressBar()
        }
    }
}

extension CXProgressBarSize {
    var size: CGSize {
        switch self {
        case .small:
            return CGSize(width: CXSpacing.spacing5, height: CXSpacing.spacing5)
        case .medium:
            return CGSize(width: CXSpacing.spacing6, height: CXSpacing.spacing6)
        case .large:
            return CGSize(width: CXSpacing.spacing8, height: CXSpacing.spacing8)
        case .custom(let size):
            return size.square
        }
    }
}
