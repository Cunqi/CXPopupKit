//
//  CXLayoutUtil.swift
//  CXPopupKit
//
//  Created by Cunqi on 9/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXLayoutUtil {
    static func setupFill(_ content: UIView, _ parent: UIView, _ insets: UIEdgeInsets) {
        parent.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left).isActive = true
        content.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.right).isActive = true
        content.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        content.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    static func fill(_ content: UIView, _ parent: UIView?, _ insets: UIEdgeInsets = .zero) {
        guard let parent = parent else {
            return
        }
        setupFill(content, parent, insets)
    }
}
