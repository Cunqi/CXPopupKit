//
//  CXWindowSize.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/5/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

public enum CXWindowLength {
    case matchPartent
    case percentageOfParent(ratio: CGFloat)
    case fixValue(size: CGFloat)
}
