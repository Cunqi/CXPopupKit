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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DatePicker"
        tapMeButton.addTarget(self, action: #selector(didTapTapMeButton), for: .touchUpInside)
    }

    @objc private func didTapTapMeButton() {
        let datePicker = CXDatePicker.Builder().withMessage("Pick a date").create(on: self)
        self.present(datePicker, animated: true, completion: nil)
    }
}
