//
//  BasicSample.swift
//  CXPopupKitDemo
//
//  Created by Cunqi Xiao on 3/13/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit
import CXPopupKit

class BasicSample: UIView {
}

extension BasicSample: CXPopupable {
    func createPopup() -> CXPopup {
        return CXPopup(with: self)
    }
}
