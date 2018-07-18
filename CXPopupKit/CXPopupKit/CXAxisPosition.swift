//
//  CXAxisPosition.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

protocol CXAxisPosition {
    func getXisValue(based length: CGFloat, screen: CGFloat, safeArea: UIEdgeInsets) -> CGFloat
}

public enum CXXAxisPosition: CXAxisPosition {
    case left
    case right
    case center
    case custom(x: CGFloat)

    func getXisValue(based length: CGFloat, screen: CGFloat, safeArea: UIEdgeInsets) -> CGFloat {
        switch self {
        case .left:
            return safeArea.left
        case .right:
            return screen - length - safeArea.right
        case .center:
            return (screen - length) / 2.0
        case .custom(let x):
            return x
        }
    }
}

public enum CXYAxisPosition: CXAxisPosition {
    case top
    case bottom
    case center
    case custom(y: CGFloat)

    func getXisValue(based length: CGFloat, screen: CGFloat, safeArea: UIEdgeInsets) -> CGFloat {
        switch self {
        case .top:
            return safeArea.top
        case .bottom:
            return screen - length - safeArea.bottom
        case .center:
            return (screen - length) / 2.0
        case .custom(let y):
            return y
        }
    }
}

public struct CXPosition {
    public static let center = CXPosition(x: .center, y: .center)
    
    let x: CXXAxisPosition
    let y: CXYAxisPosition
    
    public init(x: CXXAxisPosition, y: CXYAxisPosition) {
        self.x = x
        self.y = y
    }

    public init(x: CGFloat, y: CGFloat) {
        self.x = .custom(x: x)
        self.y = .custom(y: y)
    }
}
