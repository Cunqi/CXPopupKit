//
//  CXAxisPosition.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

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
    public static let center = CXPosition(horizontal: .center, vertical: .center)
    
    let horizontal: CXXAxisPosition
    let vertical: CXYAxisPosition
    
    public init(horizontal: CXXAxisPosition, vertical: CXYAxisPosition) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public init(x: CGFloat, y: CGFloat) {
        self.horizontal = .custom(x: x)
        self.vertical = .custom(y: y)
    }

    func getPaddingInsets(for safeAreaType: CXSafeAreaStyle) -> UIEdgeInsets {
        let initialInsets = CXDimensionUtil.windowSafeAreaInsets
        guard safeAreaType == .wrapped, initialInsets != .zero else {
            return .zero
        }

        var finalInsets = initialInsets

        switch horizontal {
        case .left:
            finalInsets.right = 0
        case .right:
            finalInsets.left = 0
        default:
            finalInsets.left = 0
            finalInsets.right = 0
        }

        switch vertical {
        case .top:
            finalInsets.bottom = 0
        case .bottom:
            finalInsets.top = 0
        default:
            finalInsets.top = 0
            finalInsets.bottom = 0
        }
        return finalInsets
    }
}
