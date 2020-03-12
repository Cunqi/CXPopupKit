//
//  DemoHomeViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 3/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class DemoHomeViewController: UIViewController {
    @IBAction func didTapBasicDemoButton(_ sender: Any) {
        let demoPlaygroundVC = DemoPlaygroundViewController()
        navigationController?.pushViewController(demoPlaygroundVC, animated: true)
    }
}
