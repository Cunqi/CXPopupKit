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
        view.backgroundColor = .red
        var appearance = CXPopupAppearance()
        appearance.width = .fixed(value: 150)
        appearance.height = .fixed(value: 150)
        appearance.position = CXPosition(x: .left, y: .top)
        appearance.backgroundColor = .blue
        appearance.animationStyle = .basic
        appearance.animationDuration = CXAnimationDuration(round: 0.35)
        appearance.animationTransition = CXAnimationTransition(in: .down)
        
        let popup = CXPopup(content: view)
                    .withAppearance(appearance)
                    .build(at: self)
        self.present(popup, animated: true, completion: nil)
    }
}

extension UIView: CXPopupable {
    
}
