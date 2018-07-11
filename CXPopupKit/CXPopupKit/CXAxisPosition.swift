//
//  CXAxisPosition.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

protocol CXAxisPosition {
    
}

public enum CXXAxisPosition: CXAxisPosition {
    case left
    case right
    case center
    case custom(x: CGFloat)
}

public enum CXYAxisPosition: CXAxisPosition {
    case top
    case bottom
    case center
    case custom(y: CGFloat)
}

public struct CXPosition {
    public static let center = CXPosition(x: .center, y: .center)
    
    let x: CXXAxisPosition
    let y: CXYAxisPosition
    
    public init(x: CXXAxisPosition, y: CXYAxisPosition) {
        self.x = x
        self.y = y
    }
}
