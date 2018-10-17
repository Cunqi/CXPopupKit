//
//  CXDatePickerBuilder.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 10/8/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public class CXDatePickerBuilder {
    let cxDatePicker: CXDatePicker
    var presenting: UIViewController?

    public init(title: String?, at presenting: UIViewController?) {
        self.cxDatePicker = CXDatePicker(title: title)
    }

    public func withDateTimeSelected(_ action: @escaping (Date) -> Void) -> Self {
        self.cxDatePicker.datetimeSelectedAction = action
        return self
    }

    public func withNavigationBarConfiguration(_ configuration: @escaping (UINavigationBar) -> Void) -> Self {
        cxDatePicker.navigationBarConfiguration = configuration
        return self
    }

    public func withDatePickerConfiguration(_ configuration: @escaping  (UIDatePicker) -> Void) -> Self {
        cxDatePicker.datePickerConfiguration = configuration
        return self
    }

    public func withStartDate(_ date: Date) -> Self {
        self.cxDatePicker.datePicker.date = date
        return self
    }

    public func build() -> UIViewController {
        return CXPopupBuilder(content: self.cxDatePicker, presenting: self.presenting)
            .withAppearance(self.cxDatePicker.popupAppearance)
            .build()
    }
}
