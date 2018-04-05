//
//  MenuSample.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class MenuSample: UIView {
}

extension MenuSample: CXPopupable {
    func createPopup() -> CXPopup {
        let popup = CXPopup(with: self)

        popup.appearance.dimension.width = .fixValue(size: 300)
        popup.appearance.dimension.height = .matchPartent
        popup.appearance.dimension.position = .left
        popup.appearance.uiStyle.maskBackgroundColor = .clear
        popup.appearance.animation.duration = .roundTrip(duration: 0.35)
        popup.appearance.animation.style = .fade
        popup.appearance.animation.transition = .oneWay(in: .left, out: .right)
        return popup
    }
}

