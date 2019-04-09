//
//  PopupBackgroundView.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/3/19.
//

import UIKit

class PopupBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
