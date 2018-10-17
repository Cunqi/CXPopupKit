//
//  CXActionSheet.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 10/3/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXActionSheet: CXAbstractAlertView {
    
    override func setupPopupAppearance() {
        popupAppearance.position = .init(horizontal: .center, vertical: .bottom)
        popupAppearance.width = .full
        popupAppearance.safeAreaType = .wrapped
        popupAppearance.animationTransition = CXAnimationTransition(in: .up)
        popupAppearance.animationStyle = .basic
        popupAppearance.backgroundColor = CXColorStyle.background
    }

    override func layoutActions() {
        if let mCancelAction = cancelAction {
            actions.append(mCancelAction)
        }
        super.layoutActions()
        let actionsLayout: CXAlertActionsLayout = CXAlertVerticalLayout()
        finalHeight += actionsLayout.layout(buttons: actions.map { $0.button }, at: self)
    }
}
