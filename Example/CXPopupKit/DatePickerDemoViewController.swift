//
//  DatePickerDemoViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi Xiao on 1/31/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CXPopupKit
class DatePickerDemoViewController: UIViewController {
    @IBOutlet private weak var tapMeButton: UIButton!
    private var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DatePicker"
        tapMeButton.addTarget(self, action: #selector(didTapTapMeButton), for: .touchUpInside)
    }

    @objc private func didTapTapMeButton() {
        let datePicker = CXDatePicker(title: "Date Picker", leftAction: nil, rightAction: .action(text: "Confirm"))
        datePicker.picker.datePickerMode = .time
        datePicker.textColor = .white
        datePicker.handler = { date in
            print(date)
        }
        datePicker.pop(on: self)
    }
}
