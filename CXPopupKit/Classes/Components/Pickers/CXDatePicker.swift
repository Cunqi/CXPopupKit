//
//  CXDatePicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/29/19.
//

import UIKit

public typealias CXDateHandler = (Date) -> Void

public class CXDatePicker: CXControlablePopup<UIDatePicker> {
    private let datePicker: UIDatePicker
    init(_ config: CXDatePickerConfig, _ message: String?, _ defaultDate: Date?, _ confirmText: String?, _ handler: CXDateHandler?, _ vc: UIViewController?) {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = config.datePickerMode
        datePicker.date = defaultDate ?? Date()
        let rightText = confirmText ?? ""
        super.init(datePicker,
                   message,
                   nil,
                   (rightText, { (datePicker) in
                    handler?(datePicker.date)
                   }), config.popupConfig, nil, { (navigationBar) in
                    navigationBar.barTintColor = config.pickerBackgroundColor
                }, vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public class Builder {
        private var handler: CXDateHandler?
        private var confirmText: String?
        private var defaultDate: Date?
        private var message: String?
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

        public func create(on vc: UIViewController?) -> CXPopup {
            return CXDatePicker(config, message, defaultDate, confirmText, handler, vc)
        }
    }
}

extension UIDatePicker: CXDialog {
}

public struct CXDatePickerConfig {
    public var popupConfig: CXPopupConfig
    public var pickerBackgroundColor = UIColor.white
    public var datePickerMode = UIDatePicker.Mode.date

    public init() {
        popupConfig = CXPopupConfig()
        popupConfig.layoutStyle = .bottom(height: 240)
        popupConfig.animationStyle = .basic
        popupConfig.animationTransition = CXAnimationTransition(.up)
        popupConfig.safeAreaStyle = .wrap
        popupConfig.safeAreaGapColor = .white
    }
}
