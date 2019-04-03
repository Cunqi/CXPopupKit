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
        CXDatePicker.Builder()
            .withMessage("Pick a date")
            .withDefault(selectedDate)
            .withConfirmHandler("Confirm", { [weak self] (date) in
                self?.selectedDate = date
                print("Current Date: \(date)")
            })
            .create(on: self)
            .pop(on: self)
    }
}
