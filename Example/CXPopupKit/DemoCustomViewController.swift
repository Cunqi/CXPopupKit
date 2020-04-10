//
//  DemoCustomViewController.swift
//  CXPopupKit_Example
//
//  Created by Cunqi on 3/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CXPopupKit
import SnapKit
import UIKit

class DemoCustomViewController: UIViewController {
    private var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Custom Tapping"
        view.backgroundColor = .white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(recognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Tap anywhere to show the popup"
        descriptionLabel.textColor = .lightGray
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.lessThanOrEqualTo(view)
        }
    }
    
    @objc
    private func didTapView(recognizer: UITapGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        
        let popupController = CXPopupController(self, DemoPopupViewController()) {
            print("Dismissed")
        }
        popupController.style.backgroundColor = .blue
        popupController.style.width = .fixed(120)
        popupController.style.height = .fixed(120)
        popupController.style.animationType = .pop
        popupController.style.animationTransition = CXAnimationTransition(.center, .center)
        popupController.style.position = CXPosition(touchPoint.x, touchPoint.y)
        present(popupController, animated: true, completion: nil)
    }
}
