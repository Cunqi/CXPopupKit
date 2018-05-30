//
//  BasicDemoViewController.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 4/7/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class BasicDemoViewController: UIViewController {
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var optionBarButtonItem: UIBarButtonItem!

    @IBAction func didTapButton(_ sender: UIButton) {
        let basicView = UIView()
        basicView.backgroundColor = .white

        let appearance = CXPopupAppearance.createAppearance()
        appearance.dimension.width = .matchPartent
        appearance.dimension.height = .percentageOfParent(ratio: 0.5)
        appearance.dimension.position = .top
        appearance.dimension.safeAreaOption = .insidePopup
        appearance.uiStyle.popupBackgroundColor = .white
        appearance.animation.style = .bounceZoom
        appearance.animation.duration = .roundTrip(duration: 0.35)
        appearance.animation.transition = .oneWay(in: .down, out: .up)
        let popup = CXPopupWindow.createPopup(with: basicView, appearance: appearance)
        popup.popup(at: self, positive: nil, negative: nil)
    }
}
