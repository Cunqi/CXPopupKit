//
//  AlertViewDemoViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi Xiao on 1/31/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CXPopupKit

class AlertViewDemoViewController: UIViewController {
    @IBOutlet private weak var alertViewButton: UIButton!
    @IBOutlet private weak var actionSheetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Alert View"
        self.alertViewButton.addTarget(self, action: #selector(didTapAlertViewButton), for: .touchUpInside)
        self.actionSheetButton.addTarget(self, action: #selector(didTapActionSheetButton), for: .touchUpInside)
    }

    @objc private func didTapAlertViewButton() {
        CXAlert.Builder(.alert)
            .withTitle("Warning!")
            .withMessage("A or B")
            .withButton1("A") { _ in }
            .withButton2("B") { _ in }
            .create(on: self)
            .pop()
    }

    @objc private func didTapActionSheetButton() {
        CXAlert.Builder(.actionSheet)
            .withTitle("Warning!")
            .withMessage("Select a photo to upload")
            .withButton1("OK") { _ in }
            .withButton2("Skip") { _ in }
            .create(on: self)
            .pop()
    }
}
