//
//  CXAlert.swift
//  CXPopupKit
//
//  Created by Cunqi on 9/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXAlert: CXAbstractAlertView {
    
    override func setupPopupAppearance() {
        popupAppearance.shouldDismissOnBackgroundTap = false
        popupAppearance.animationTransition = CXAnimationTransition(in: .center)
        popupAppearance.animationStyle = .pop
        popupAppearance.animationDuration = CXAnimationDuration(in: 0.25, out: 0.1)
        popupAppearance.width = .fixed(value: 270)
        popupAppearance.backgroundColor = CXColorStyle.background
    }

    override func layoutActions() {
        if let mCancelAction = cancelAction {
            if actions.count < 2 {
                mCancelAction.attachDividerOnButton(at: .right)
                actions.insert(mCancelAction, at: 0)
            } else {
                actions.append(mCancelAction)
            }
        }
        super.layoutActions()
        let actionsLayout: CXAlertActionsLayout = actions.count < 3 ? CXAlertHorizontalLayout() : CXAlertVerticalLayout()
        finalHeight += actionsLayout.layout(buttons: actions.map { $0.button }, at: self)
    }
}
