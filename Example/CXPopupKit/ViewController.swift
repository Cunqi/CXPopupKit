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
        let displayedVC = DisplayedViewController()
        let popup = CXPopupController(self, displayedVC)
        popup.style.width = .ratio(0.5)
        popup.style.height = .ratio(0.5)
        popup.style.position = CXPosition(.center, .center)
        popup.style.safeAreaPolicy = .auto
        popup.style.animationType = .pop
        popup.style.cornerRadius = 12
        popup.style.animationDuration = CXAnimationDuration(0.35, 0.067)
        present(popup, animated: true, completion: nil)
    }
}

class DisplayedViewController: UIViewController, CXPopupControlDelegate {
    var button: UIButton!
    func needsToDismissPopupController() -> Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        button = UIButton(type: .system)
        button.setTitle("Tap", for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapButton() {
        self.parent?.dismiss(animated: true, completion: nil)
    }
}
