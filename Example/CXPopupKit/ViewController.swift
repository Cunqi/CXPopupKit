//
//  ViewController.swift
//  CXPopupKitDemo
//
//  Created by Cunqi on 7/23/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit
import CXPopupKit

class ViewController: UIViewController {
    @IBOutlet private weak var button: UIButton!

    private var globalConfig = CXPopupConfig()
    private var customView = MyView()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        globalConfig.layoutStyle = .topLeft(size: CGSize(width: 300, height: 300))
        globalConfig.animationStyle = .bounce
        globalConfig.animationTransition = CXAnimationTransition(.down)
        globalConfig.safeAreaStyle = .on
        globalConfig.isAutoRotateEnabled = true

        customView.backgroundColor = .red

        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        globalConfig.layoutStyle = .bottom(height: 200)
        globalConfig.animationStyle = .basic
        globalConfig.animationTransition = CXAnimationTransition(.up)
        globalConfig.maskBackgroundColor = .clear

        var config = CXPickerConfig()
        config.popupConfig = globalConfig
        config.messageBackgroundColor = .black
        config.optionBackgroundColor = .black
        config.separatorColor = .white
        config.optionTextColor = .white
        config.messageTextColor = .white

        let array = ["A", "B", "C", "D"]
        let picker = CXPicker<String>.Builder(array)
            .withConfig(config)
            .withDefault(array.firstIndex(of: "C"))
            .withMessage("Confirm Pickup")
            .create(on: self)
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func didTapConfigButton(_ sender: Any) {
        let actionSheet = CXAlert.Builder(.actionSheet)
            .withTitle("Warning!")
            .withMessage("Select a photo to upload")
            .withButton1("OK") { _ in }
            .withButton2("Skip") { _ in }
            .create(on: self)
        self.present(actionSheet, animated: true, completion: nil)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        globalConfig.layoutStyle = .custom(rect: CGRect(origin: location, size: CGSize(width: 120, height: 200)))
        globalConfig.animationStyle = .pop
        globalConfig.animationTransition = CXAnimationTransition(.center)
        globalConfig.maskBackgroundColor = .clear

        var config = CXPickerConfig()
        config.popupConfig = globalConfig

        let array = [1, 2, 3, 4, 5, 6, 7]
        let picker = CXPicker<Int>.Builder(array)
            .withConfig(config)
            .withDefault(array.firstIndex(of: 7))
            .create(on: self)
        self.present(picker, animated: true, completion: nil)
    }
}

class MyView: UIView, CXDialog {
    
}
