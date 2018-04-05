//
//  CXPopupLayoutStrategy.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 3/8/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

protocol CXPopupLayoutStrategy {
    func install(_ content: UIView, into parent: UIView, basedOn appearance: CXPopupAppearance)
}

class LayoutWithoutSafeAreaStrategy: CXPopupLayoutStrategy {
    func install(_ content: UIView, into parent: UIView, basedOn appearance: CXAppearance) {
        LayoutUtil.fill(view: content, at: parent)
    }
}

class LayoutWithOutsideSafeAreaStrategy: CXPopupLayoutStrategy {
    func install(_ content: UIView, into parent: UIView, basedOn appearance: CXAppearance) {
        LayoutUtil.installWithSafeArea(view: content, into: parent, inset: .zero)
    }
}
