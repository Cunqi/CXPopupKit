//
//  CXAlertLayout.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 10/8/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

protocol CXAlertActionsLayout {
    func layout(buttons: [UIButton], at parent: CXAbstractAlertView) -> CGFloat
}

class CXAlertHorizontalLayout: CXAlertActionsLayout {
    func layout(buttons: [UIButton], at parent: CXAbstractAlertView) -> CGFloat {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill

        parent.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: parent.messageLabel.bottomAnchor, constant: CXSpacing.item1.value).isActive = true
        stackView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        return CXDimensionUtil.defaultHeight
    }
}

class CXAlertVerticalLayout: CXAlertActionsLayout {
    func layout(buttons: [UIButton], at parent: CXAbstractAlertView) -> CGFloat {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill

        parent.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: parent.messageLabel.bottomAnchor, constant: CXSpacing.item1.value).isActive = true
        stackView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        return CXDimensionUtil.defaultHeight * CGFloat(buttons.count)
    }
}
