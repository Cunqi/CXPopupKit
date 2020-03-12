//
//  DemoPopupViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 3/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import UIKit

class DemoPopupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
}

extension DemoPopupViewController: CXPopupControlDelegate {
}
