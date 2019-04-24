//
//  PickerDemoViewController.swift
//  CXPopupKitDemo
//
//  Created by Cunqi on 7/23/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit
import CXPopupKit

class PickerDemoViewController: UIViewController {
    @IBOutlet private weak var button: UIButton!

    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
//        var config = CXPickerConfig()
//        // Do any additional setup after loading the view, typically from a nib.
//        config.popupConfig.layoutStyle = .bottom(height: 240)
//        config.popupConfig.animationStyle = .bounce
//        config.popupConfig.animationTransition = CXAnimationTransition(.up)
//        config.popupConfig.safeAreaStyle = .wrap
//        config.popupConfig.isAutoRotateEnabled = true
//
//        let array = ["A", "B", "C", "D"]
//        let picker = CXPicker<String>.Builder(array)
//            .withConfig(config)
//            .withDefault(array.firstIndex(of: "C"))
//            .withMessage("Confirm Pickup")
//            .create(on: self)
//        self.present(picker, animated: true, completion: nil)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)

//        var config = CXPickerConfig()
//        config.popupConfig.layoutStyle = .custom(rect: CGRect(origin: location, size: CGSize(width: 120, height: 200)))
//        config.popupConfig.animationStyle = .pop
//        config.popupConfig.animationTransition = CXAnimationTransition(.center)
//        config.popupConfig.maskBackgroundColor = .clear
//
//        let array = [1, 2, 3, 4, 5, 6, 7]
//        let picker = CXPicker<Int>.Builder(array)
//            .withConfig(config)
//            .withDefault(array.firstIndex(of: 7))
//            .create(on: self)
//        self.present(picker, animated: true, completion: nil)
    }
}

class MyView: UIView, CXDialog {
    
}
