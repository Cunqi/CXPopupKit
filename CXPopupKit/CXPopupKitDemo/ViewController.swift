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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTapButton(_ sender: Any) {
        let view = UIView()
        view.backgroundColor = .black
        var appearance = CXPopupAppearance()
        appearance.width = .part(ratio: 0.5)
        appearance.height = .part(ratio: 0.5)
        appearance.animationStyle = .basic
        appearance.animationDuration = CXAnimationDuration(round: 0.35)
        appearance.animationTransition = CXAnimationTransition(in: .down)
        
        let popup = CXPopup(content: view)
                    .withStyle(appearance)
                    .build()
        popup.show(at: self)
    }
}

extension UIView: CXPopupable {
    
}
