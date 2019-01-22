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
        let builder = CXPopup.Builder()
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
        
        //        let dataSet = [["one", "two", "three"], ["one", "two", "three"]]
        //        let picker = CXPickerBuilder<String>(title: "Test", at: self)
        //                        .withComplexData(dataSet)
        //                        .withComplexDataSelected({ actions in
        //                            for action in actions {
        //                                print(action)
        //                            }
        //                        })
        //                        .build()
        //        self.present(picker, animated: true, completion: nil)
        
        //        let toast = CXToastBuilder(message: "2018-10-02 19:54:31.682618-0700 CXPopupKitDemo[1874:61352] [AXMediaCommon] Unexpected physical screen orientation").build()
        //        self.present(toast, animated: true, completion: nil)
        
        let datePicker = CXDatePickerBuilder(title: "Test DateTime", at: self)
            .withDateTimeSelected { date in
                print(date)
            }
            .build()
        self.present(datePicker, animated: true, completion: nil)
        
        //        let alertView = CXAlertBuilder(type: .actionSheet, at: self)
        //            .withTitle("Hello World This is a testing title for test CXAlert")
        //            .withMessage("Jackson helps you actually communicate with your cat by properly learning their body language. And trust us, your cat’s body language is very different than your dog’s! ")
        //            .withCancel("Cancel")
        //            .withActions(["Sure", "No Problem"])
        //            .build()
        //        self.present(alertView, animated: true, completion: nil)
    }
}

class MyView: UIView, CXPopupable {
    
}
