//
//  CXPickerBuilder.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 10/8/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public class CXPickerBuilder<T: CustomStringConvertible> {
    let cxPicker: CXPicker<T>
    var presenting: UIViewController?

    public init(title: String?, at presenting: UIViewController?) {
        self.cxPicker = CXPicker<T>(title: title)
    }

    public func withSimpleData(_ data: [T]) -> Self {
        cxPicker.pickerAdapter = CXPickerAdapter<T>(simple: data)
        cxPicker.dataType = .simple
        return self
    }

    public func withComplexData(_ data: [[T]]) -> Self {
        cxPicker.pickerAdapter = CXPickerAdapter<T>(complex: data)
        cxPicker.dataType = .complex
        return self
    }

    public func withSimpleDataSelected(_ action: @escaping (T) -> Void) -> Self {
        cxPicker.simpleDataSelectedAction = action
        return self
    }

    public func withComplexDataSelected(_ action: @escaping ([T]) -> Void) -> Self {
        cxPicker.complexDataSelectedAction = action
        return self
    }

    public func withSelectionConfirmed(_ action: @escaping (UIPickerView) -> Void) -> Self {
        cxPicker.selectionConfirmedAction = action
        return self
    }

    public func withDataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        cxPicker.picker.dataSource = dataSource
        return self
    }

    public func withDelegate(_ delegate: UIPickerViewDelegate) -> Self {
        cxPicker.picker.delegate = delegate
        return self
    }

    public func withNavigationBarConfiguration(_ configuration: @escaping (UINavigationBar) -> Void) -> Self {
        cxPicker.navigationBarConfiguration = configuration
        return self
    }

    public func build() -> UIViewController {
        return CXPopupBuilder(content: self.cxPicker, presenting: presenting)
            .withAppearance(self.cxPicker.popupAppearance)
            .build()
    }
}

