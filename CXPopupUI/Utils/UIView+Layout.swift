//
//  UIView+Layout.swift
//  CXPopupKit
//
//  Created by Cunqi on 4/8/20.
//

import UIKit
import SnapKit

extension UIView {
    func embed(_ insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = true
        wrapper.addSubview(self)
        self.snp.makeConstraints { (maker) in
            guard insets != .zero else {
                maker.center.equalToSuperview()
                return
            }
            maker.edges.equalToSuperview().inset(insets)
        }
        return wrapper
    }
}
