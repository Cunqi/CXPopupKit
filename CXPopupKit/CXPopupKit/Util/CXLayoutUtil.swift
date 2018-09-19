//
//  CXLayoutUtil.swift
//  CXPopupKit
//
//  Created by Cunqi on 9/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

enum CXSpacing: Int {
    case item1 = 1
    case item2
    case item3
    case item4
    case item5
    case item6
    case item7
    case item8
    case item9
    
    var value: CGFloat {
        return CGFloat(self.rawValue * 4)
    }
}

class CXLayoutUtil {
    
}
