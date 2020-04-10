//
//  DemoHUDViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 4/6/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import CXPopupUI
import SnapKit
import UIKit

class DemoHUDViewController: UIViewController {
    private var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HUD Tapping"
        view.backgroundColor = .white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(recognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Tap anywhere to show the HUD"
        descriptionLabel.textColor = .lightGray
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.lessThanOrEqualTo(view)
        }
    }
    
    @objc
    private func didTapView(recognizer: UITapGestureRecognizer) {
        CXHUD.backgroundColor = UIColor(white: 0, alpha: 1)
        CXHUD.tintColor = .white
        CXHUD.showLoading(with: "Loading...", self.view)
        CXHUD.dismissHUD(after: 5)
    }
}
