//
//  CXDatePicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 1/29/19.
//

import UIKit

public class CXDatePicker: CXBasePicker, CXItemSelectable {

    public typealias Item = Date

    public var handler: ((Date) -> Void)?

    public lazy var picker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        return picker
    }()

    public override var textColor: UIColor {
        get { return pickerAppearance.textColor }
        set { pickerAppearance.textColor = newValue }
    }

    @objc public dynamic var datePickerMode: UIDatePicker.Mode {
        get { return picker.datePickerMode }
        set { picker.datePickerMode = newValue }
    }

    public init(title: String?,
                leftAction: CXPopupNavigateAction?,
                rightAction: CXPopupNavigateAction?,
                mode: UIDatePicker.Mode = .date,
                date: Date? = nil,
                popupAppearance: CXPopupAppearance = CXDatePicker.bottomPopupAppearance,
                handler: ((Date) -> Void)? = nil) {
        super.init(title, leftAction, rightAction, popupAppearance)
        self.handler = handler
        self.picker.datePickerMode = mode
        self.picker.date = date ?? Date()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        picker.setValue(pickerAppearance.textColor, forKey: "textColor")
        self.popupController?.navigationController?.navigationBar.tintColor = pickerAppearance.textColor
        CXLayoutBuilder.fill(picker, self, .zero)
    }

    override func dismiss(for type: CXDismissType) {
        guard type == .confirm else {
            return
        }
        handler?(picker.date)
    }
}
