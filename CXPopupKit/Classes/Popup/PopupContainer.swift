//
//  PopupContainer.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/9/19.
//

import UIKit

class PopupContainer {
    var appearance: CXPopupAppearance

    lazy var shadowContainer: UIView = {
        let view = UIView()
        if appearance.isShadowEnabled {
            view.layer.shadowOpacity = appearance.shadowOpacity
            view.layer.shadowRadius = appearance.shadowRadius
            view.layer.shadowOffset = appearance.shadowOffset
            view.layer.shadowColor = appearance.shadowColor.cgColor
            view.layer.masksToBounds = false
        }
        return view
    }()

    lazy var roundedCornerContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = appearance.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    lazy var safeAreaContainer: UIView = {
        return UIView()
    }()

    var content: UIView?

    var container: UIView {
        return shadowContainer
    }

    var backgroundColor: UIColor? {
        get { return self.safeAreaContainer.backgroundColor }
        set { if self.appearance.safeAreaGapColor == nil {
            self.safeAreaContainer.backgroundColor = newValue
            }
        }
    }

    init(_ appearance: CXPopupAppearance) {
        self.appearance = appearance
    }

    func install(_ content: UIView) {
        uninstall(self.content)
        
        let layoutStyle = appearance.layoutStyle
        if appearance.safeAreaStyle == .wrap {
            safeAreaContainer.backgroundColor = appearance.safeAreaGapColor ?? content.backgroundColor
            CXLayoutBuilder.addToSafeAreaContainer(content, safeAreaContainer, layoutStyle)
            CXLayoutBuilder.setSizeConstraint(content, safeAreaContainer, layoutStyle)
            CXLayoutBuilder.addToRoundedCornerContainer(safeAreaContainer, roundedCornerContainer, layoutStyle)
        } else {
            CXLayoutBuilder.addToRoundedCornerContainer(content, roundedCornerContainer, layoutStyle)
            CXLayoutBuilder.setSizeConstraint(content, roundedCornerContainer, layoutStyle)
        }
        CXLayoutBuilder.fillToShadowContainer(roundedCornerContainer, shadowContainer)
        
        self.content = content
    }

    func uninstall(_ content: UIView?) {
        guard let content = content else {
            return
        }
        if content.isDescendant(of: roundedCornerContainer) {
            content.removeFromSuperview()
        }
        safeAreaContainer.removeFromSuperview()
        roundedCornerContainer.removeFromSuperview()
        shadowContainer.removeFromSuperview()
    }
}
