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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        globalConfig.layoutStyle = .topLeft(size: CGSize(width: 300, height: 300))
        globalConfig.animationStyle = .bounce
        globalConfig.animationTransition = CXAnimationTransition(in: .down)
        globalConfig.safeAreaStyle = .on
        globalConfig.isAutoRotateEnabled = true

        customView.backgroundColor = .red
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        let popup = CXPopup.Builder(view: customView).withConfig(globalConfig).create(on: self)
        self.present(popup, animated: true, completion: nil)
    }

    @IBAction func didTapConfigButton(_ sender: Any) {
        let alertView = CXAlertPopup.Builder(.alert)
            .withTitle("Hello")
            .withMessage("Returns a Context with the appropriate theme for dialogs created by this Builder. Applications should use this Context for obtaining LayoutInflaters for inflating views that will be used in the resulting dialogs, as it will cause views to be inflated with the correct theme.")
            .withButton1("Cancel", { (title) in
                print(title)
            })
            .withButton2("OK", { (title) in
                print(title)
            })
            .withButton3("Skip", { (title) in
                print(title)
            })
            .create(on: self)
        self.present(alertView, animated: true, completion: nil)
    }
}

class MyView: UIView, CXDialog {
    
}
