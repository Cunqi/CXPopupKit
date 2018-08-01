//
//  CXDimensionUtil.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 7/17/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

class CXDimensionUtil {
    static func getRect(width: CXEdgeSize, height: CXEdgeSize, position: CXPosition, safeAreaType: CXSafeAreaType, screen: CGSize) -> CGRect {

        let calculatedWidth = width.getValue(based: screen.width)
        let calculatedwHeight = height.getValue(based: screen.height)
        let safeAreaMargin = getSafeAreaMargin(position, safeAreaType)
        let w = calculatedWidth + safeAreaMargin.left + safeAreaMargin.right
        let h = calculatedwHeight + safeAreaMargin.top + safeAreaMargin.bottom
        let size = CGSize(width: w, height: h)
        let origin = getOrigin(position, size: size, screen: screen, safeAreaType: safeAreaType)
        return CGRect(origin: origin, size: size)
    }

    static var windowSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }

    private static func getSafeAreaMargin(_ position: CXPosition, _ safeAreaType: CXSafeAreaType) -> UIEdgeInsets {
        guard safeAreaType == .wrapped else {
            return .zero
        }

        var result = UIEdgeInsets.zero
        switch position.horizontal {
        case .left:
            result.left = CXDimensionUtil.windowSafeAreaInsets.left
        case .right:
            result.right = CXDimensionUtil.windowSafeAreaInsets.left
        default:
            break
        }

        switch position.vertical {
        case .top:
            result.top = CXDimensionUtil.windowSafeAreaInsets.top
        case .bottom:
            result.bottom = CXDimensionUtil.windowSafeAreaInsets.bottom
        default:
            break
        }

        return result
    }

    private static func getOrigin(_ position: CXPosition, size: CGSize, screen: CGSize, safeAreaType: CXSafeAreaType) -> CGPoint {
        let safeAreaInsets = safeAreaType == .default ? windowSafeAreaInsets : .zero
        let x = position.horizontal.getXisValue(based: size.width, screen: screen.width, safeArea: safeAreaInsets)
        let y = position.vertical.getXisValue(based: size.height, screen: screen.height, safeArea: safeAreaInsets)
        return CGPoint(x: x, y: y)
    }
}
