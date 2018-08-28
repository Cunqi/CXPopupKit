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
//        let view = MyView()
//        view.backgroundColor = .red
//        var appearance = CXPopupAppearance()
//        appearance.width = .full
//        appearance.height = .part(ratio: 0.5)
//        appearance.position = CXPosition(horizontal: .left, vertical: .top)
//        appearance.backgroundColor = .blue
//        appearance.animationStyle = .pop
//        appearance.animationDuration = CXAnimationDuration(round: 0.35)
//        appearance.animationTransition = CXAnimationTransition(in: .center)
//        appearance.safeAreaType = .wrapped
//
//        let popup = CXPopupBuilder(content: view, presenting: self)
//                    .withAppearance(appearance)
//                    .build()
//        self.present(popup, animated: true, completion: nil)

        let dataSet = ["one", "two", "three"]
        let picker = CXPickerBuilder<String>(title: "Test", at: self)
                        .withSimpleData(dataSet)
                        .withSelectionConfirmed({ indexes in
                            print(dataSet[indexes[0]])
                        })
                        .build()
        self.present(picker, animated: true, completion: nil)
    }
}

class MyView: UIView, CXPopupable {

}
