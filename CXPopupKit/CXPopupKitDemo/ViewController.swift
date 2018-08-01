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
        appearance.width = .full
        appearance.height = .part(ratio: 0.5)
        appearance.position = CXPosition(horizontal: .left, vertical: .top)
        appearance.backgroundColor = .blue
        appearance.animationStyle = .basic
        appearance.animationDuration = CXAnimationDuration(round: 0.35)
        appearance.animationTransition = CXAnimationTransition(in: .down)
        appearance.safeAreaType = .wrapped
        
        let popup = CXPopup(content: view)
                    .withAppearance(appearance)
                    .build(at: self)
        self.present(popup, animated: true, completion: nil)
    }
}

extension UIView: CXPopupable {
    
}
