//
//  CXDatePicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/29/19.
//

import UIKit

public typealias CXDateHandler = (Date) -> Void
public typealias CXDatePickerConfiguration = (_ picker: UIView, _ picker: UIDatePicker, _ message: UILabel?) -> Void

public class CXDatePicker: CXPopup {
    init(_ config: CXDatePickerConfig, _ message: String?, _ defaultDate: Date?, _ confirmText: String?, _ handler: CXDateHandler?, _ configuration: CXDatePickerConfiguration?, _ vc: UIViewController?) {
        let picker = DatePickerView(config, message, defaultDate, confirmText, handler, configuration)
        super.init(picker, config.popupConfig, nil, vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public class Builder {
        private var handler: CXDateHandler?
        private var confirmText: String?
        private var defaultDate: Date?
        private var message: String?
        private var configuration: CXDatePickerConfiguration?
        private var config = CXDatePickerConfig()

        public init() {}
        
        public func withConfirmHandler(_ text: String, _ handler: @escaping CXDateHandler) -> Self {
            self.confirmText = text
            self.handler = handler
            return self
        }

        public func withDefault(_ date: Date) -> Self {
            self.defaultDate = date
            return self
        }

        public func withMessage(_ message: String) -> Self {
            self.message = message
            return self
        }

        public func withConfig(_ config: CXDatePickerConfig) -> Self {
            self.config = config
            return self
        }

        public func withConfiguration(_ configuration: @escaping CXDatePickerConfiguration) -> Self {
            self.configuration = configuration
            return self
        }

        public func create(on vc: UIViewController?) -> UIViewController {
            return CXDatePicker(config, message, defaultDate, confirmText, handler, configuration, vc)
        }
    }

    class DatePickerView: UIView, CXDialog {
        private let layout = UIStackView()
        private let datePicker = UIDatePicker(frame: .zero)
        private var messageLayout: UIView?
        private var messageLabel: UILabel?


        private let config: CXDatePickerConfig
        private var message: String?
        private var defaultDate: Date?
        private var confirmText: String?
        private var handler: CXDateHandler?
        private var configuration: CXDatePickerConfiguration?

        init(_ config: CXDatePickerConfig, _ message: String?, _ defaultDate: Date?, _ confirmText: String?, _ handler: CXDateHandler?, _ configuration: CXDatePickerConfiguration?) {
            self.config = config
            self.message = message
            self.defaultDate = defaultDate
            self.confirmText = confirmText
            self.handler = handler
            self.configuration = configuration
            super.init(frame: .zero)
            build()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func build() {
            self.backgroundColor = config.dividerColor

            layout.axis = .vertical
            layout.distribution = .fill

            if message != nil {
                messageLabel = UILabel()
                messageLabel?.textColor = config.messageTextColor
                messageLabel?.font = config.messageFont
                messageLabel?.backgroundColor = config.pickerBackgroundColor
                messageLabel?.textAlignment = .center
                messageLabel?.text = message
                
                messageLayout = UIView()
                layout.spacing = 1.0
                layout.addArrangedSubview(messageLayout!)
            }
            configuration?(self, datePicker, messageLabel)

            if let mLayout = setupMessageLayout(messageLayout, messageLabel, message) {
                self.layout.addArrangedSubview(mLayout)
            }
            setupDatePicker()

            CXLayoutUtil.fill(layout, at: self)
        }

        private func setupMessageLayout(_ messageLayout: UIView?, _ messageLabel: UILabel?, _ message: String?) -> UIView? {
            var height: CGFloat = 0
            guard let message = message, let layout = messageLayout, let label = messageLabel else {
                return nil
            }
            layout.backgroundColor = label.backgroundColor
            label.backgroundColor = .clear

            let width = config.popupConfig.layoutStyle.size.width
            let estimatedHeight = CXTextUtil.getTextSize(
                for: message,
                with: CGSize(width: width - CXSpacing.spacing4, height: CGFloat(Double.greatestFiniteMagnitude)),
                font: label.font).height
            height = estimatedHeight + CXSpacing.spacing5
            layout.heightAnchor.constraint(equalToConstant: height).isActive = true

            CXLayoutUtil.fill(label, at: layout, with: UIEdgeInsets(top: CXSpacing.spacing4, left: CXSpacing.spacing3, bottom: CXSpacing.spacing4, right: CXSpacing.spacing3))
            return layout
        }

        private func setupDatePicker() {
            datePicker.backgroundColor = config.pickerBackgroundColor
            datePicker.setDate(defaultDate ?? Date(), animated: true)
            layout.addArrangedSubview(datePicker)
        }
    }
}

extension CXDatePicker.DatePickerView: CXPopupLifeCycleDelegate {
    func viewDidLoad() {
    }

    func viewDidDisappear() {
        handler = nil
        configuration = nil
    }
}

public struct CXDatePickerConfig {
    public var popupConfig = CXPopupConfig()

    public var messageFont = UIFont.systemFont(ofSize: 14.0)
    public var messageTextColor = UIColor.black
    public var pickerBackgroundColor = UIColor.white
    public var dividerColor = UIColor(white: 0.85, alpha: 1.0)

    private var datePickerMode = UIDatePickerMode.date

    public init() {
        popupConfig.layoutStyle = .bottom(height: 240)
        popupConfig.animationStyle = .basic
        popupConfig.animationTransition = CXAnimationTransition(.up)
        popupConfig.safeAreaStyle = .wrap
        popupConfig.safeAreaGapColor = .white
    }
}
