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
        let array = ["A", "B", "C", "D"]
        let picker = CXPicker<String>.Builder(array)
            .withConfig(globalConfig)
            .withDefault(array.firstIndex(of: "C"))
            .create(on: self)
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func didTapConfigButton(_ sender: Any) {
        let toast = CXToast("Downloading...", .short)
        self.present(toast, animated: true, completion: nil)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        globalConfig.layoutStyle = .custom(rect: CGRect(origin: location, size: CGSize(width: 120, height: 200)))
        globalConfig.animationStyle = .pop
        globalConfig.animationTransition = CXAnimationTransition(.center)
        globalConfig.maskBackgroundColor = .clear
        let array = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
        let picker = CXPicker<String>.Builder(array)
            .withConfig(globalConfig)
            .withDefault(array.firstIndex(of: "H"))
            .create(on: self)
        self.present(picker, animated: true, completion: nil)
    }
}

class MyView: UIView, CXDialog {
    
}
