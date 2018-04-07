//
//  DimensionUtil.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/5/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import Foundation

class DimensionUtil {
    static func size(width: CXWindowLength, height: CXWindowLength, basedOn reference: CGSize, insets: UIEdgeInsets) -> CGSize {
        let w = length(of: width, basedOn: reference.width, insets: insets, isWidth: true)
        let h = length(of: height, basedOn: reference.height, insets: insets, isWidth: false)
        return CGSize(width: w, height: h)
    }

    static func length(of windowLength: CXWindowLength, basedOn reference: CGFloat, insets: UIEdgeInsets, isWidth: Bool) -> CGFloat {
        let marginSpace = isWidth ? insets.left + insets.right : insets.top + insets.bottom
        switch windowLength {
        case .matchPartent:
            return reference - marginSpace
        case .percentageOfParent(let ratio):
            let ratioSize = ratio * reference
            return min(ratioSize, reference - marginSpace)
        case .fixValue(let fixSize):
            return fixSize
        }
    }

    static func origin(of windowPosition: CXWindowPosition, insets: UIEdgeInsets, size: CGSize, basedOn bounds: CGSize) -> CGPoint {
        let x = getX(width: size.width, basedOn: bounds.width, insets: insets, for: windowPosition)
        let y = getY(height: size.height, basedOn: bounds.height, insets: insets, for: windowPosition)
        return CGPoint(x: x, y: y)
    }

    private static func getX(width: CGFloat, basedOn reference: CGFloat, insets: UIEdgeInsets, for position: CXWindowPosition) -> CGFloat {
        switch position {
        case .center, .top, .bottom:
            return (reference - width) / 2.0
        case .left:
            return insets.left
        case .right:
            return reference - insets.right - width
        case let .custom(x, _):
            return x
        }
    }

    private static func getY(height: CGFloat, basedOn reference: CGFloat, insets: UIEdgeInsets, for position: CXWindowPosition) -> CGFloat {
        switch position {
        case .center, .left, .right:
            return (reference - height) / 2.0
        case .top:
            return insets.top
        case .bottom:
            return reference - insets.bottom - height
        case let .custom(_, y):
            return y
        }
    }

    static func rect(width: CXWindowLength, height: CXWindowLength, position: CXWindowPosition, margin: UIEdgeInsets, safeAreaOption: CXWindowSafeAreaOption, basedOn container: UIView) -> CGRect {
        let safeAreaInsets = getSafeAreaInsets(for: container)
        let mergedInsets = getMergeInsets(for: margin, safeAreaInsets: safeAreaInsets, safeAreaOption: safeAreaOption)

        let windowSize = size(width: width, height: height, basedOn: container.bounds.size, insets: mergedInsets)
        let windowOrigin = origin(of: position, insets: mergedInsets, size: windowSize, basedOn: container.bounds.size)
        return CGRect(origin: windowOrigin, size: windowSize)
    }

    static func updatedRect(rect: CGRect, position: CXWindowPosition, margin: UIEdgeInsets, safeAreaOption: CXWindowSafeAreaOption, basedOn container: UIView) -> CGRect {
        let safeAreaInsets = getSafeAreaInsets(for: container)
        let updatedWindowSize = updateWindowSize(for: rect.size, safeAreaInsets: safeAreaInsets, position: position, safeAreaOption: safeAreaOption)
        let updatedWindowOrigin = updateWindowOrigin(for: rect.origin, safeAreaInsets: safeAreaInsets, position: position, safeAreaOption: safeAreaOption)
        return CGRect(origin: updatedWindowOrigin, size: updatedWindowSize)
    }

    private static func updateWindowSize(for size: CGSize, safeAreaInsets: UIEdgeInsets, position: CXWindowPosition, safeAreaOption: CXWindowSafeAreaOption) -> CGSize {
        guard safeAreaOption == .insidePopup else {
            return size
        }

        switch position {
        case .center:
            return CGSize(width: size.width + safeAreaInsets.left + safeAreaInsets.right, height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
        case .left:
            return CGSize(width: size.width + safeAreaInsets.left, height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
        case .right:
            return CGSize(width: size.width + safeAreaInsets.right, height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
        case .top:
            return CGSize(width: size.width, height: size.height + safeAreaInsets.top)
        case .bottom:
            return CGSize(width: size.width, height: size.height + safeAreaInsets.bottom)
        case .custom:
            return size
        }
    }

    private static func updateWindowOrigin(for origin: CGPoint, safeAreaInsets: UIEdgeInsets, position: CXWindowPosition, safeAreaOption: CXWindowSafeAreaOption) -> CGPoint {
        guard safeAreaOption == .insidePopup else {
            return origin
        }

        switch position {
        case .center:
            return origin
        case .left:
            return CGPoint(x: origin.x + safeAreaInsets.left, y: origin.y)
        case .right:
            return CGPoint(x: origin.x - safeAreaInsets.right, y: origin.y)
        case .top:
            return CGPoint(x: origin.x, y: origin.y + safeAreaInsets.top)
        case .bottom:
            return CGPoint(x: origin.x, y: origin.y - safeAreaInsets.bottom)
        case .custom:
            return origin
        }
    }

    private static func getMergeInsets(for margin: UIEdgeInsets, safeAreaInsets: UIEdgeInsets, safeAreaOption: CXWindowSafeAreaOption) -> UIEdgeInsets {
        switch safeAreaOption {
        case .none, .insidePopup:
            return margin
        case .normal:
            return UIEdgeInsets(top: margin.top + safeAreaInsets.top, left: margin.left + safeAreaInsets.left, bottom: margin.bottom + safeAreaInsets.bottom, right: margin.right + safeAreaInsets.right)
        }
    }

    static func getSafeAreaInsets(for view: UIView?) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }
}
