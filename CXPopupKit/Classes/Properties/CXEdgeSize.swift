//
//  CXEdgeSize.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

public enum CXEdgeSize {
    case full
    case part(ratio: CGFloat)
    case fixed(value: CGFloat)

    func getValue(based length: CGFloat) -> CGFloat {
        switch self {
        case .full:
            return length
        case .part(let ratio):
            return ratio * length
        case .fixed(let value):
            return value
        }
    }
}
