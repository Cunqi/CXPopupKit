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
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressForDismissal))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc
    private func didLongPressForDismissal() {
        popup?.dismiss(animated: true, completion: nil)
    }
}

extension DemoPopupViewController: CXPopupControlDelegate {
    func shouldOutsideTouchTriggerDismissalCompletionBlock() -> Bool {
        return false
    }
}
