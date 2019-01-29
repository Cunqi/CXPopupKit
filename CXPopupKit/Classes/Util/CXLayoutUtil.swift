//
//  CXLayoutUtil.swift
//  CXPopupKit
//
//  Created by Cunqi on 9/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

enum CXSpacing {
    static let spacing1: CGFloat = 2
    static let spacing2: CGFloat = 4
    static let spacing3: CGFloat = 8
    static let spacing4: CGFloat = 16
    static let spacing5: CGFloat = 32
    static let spacing6: CGFloat = 64
    static let spacing7: CGFloat = 80
    static let spacing8: CGFloat = 96
}

class CXLayoutUtil {
    static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }

    static func fill(_ content: UIView, at parent: UIView?, with insets: UIEdgeInsets = .zero) {
        guard let parent = parent else {
            return
        }
        parent.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left).isActive = true
        content.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.right).isActive = true
        content.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        content.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom).isActive = true
    }

    static func layout(layoutStyle: CXLayoutStyle, safeAreaStyle: CXSafeAreaStyle, insets: UIEdgeInsets) -> CGRect {
        let saInsets = getLatestInsets(safeAreaStyle)
        switch layoutStyle {
        case .left(let width):
            return CGRect(x: saInsets.left + insets.left, y: saInsets.top + insets.top, width: width, height: getHeight(safeAreaStyle, insets: insets))
        case .right(let width):
            let screenWidth = UIScreen.main.bounds.size.width
            return CGRect(
                x: screenWidth - insets.right - width - saInsets.right,
                y: saInsets.top + insets.top,
                width: width,
                height: getHeight(safeAreaStyle, insets: insets))
        case .top(let height):
            return CGRect(x: saInsets.left + insets.left, y: saInsets.top + insets.top, width: getWidth(safeAreaStyle, insets: insets), height: height)
        case .bottom(let height):
            let screenHeight = UIScreen.main.bounds.size.height
            return CGRect(
                x: saInsets.left + insets.left,
                y: screenHeight - insets.bottom - height - saInsets.bottom,
                width: getWidth(safeAreaStyle, insets: insets),
                height: height)
        case .topLeft(let size):
            return CGRect(origin: CGPoint(x: saInsets.left + insets.left, y: saInsets.top + insets.top), size: size)
        case .topRight(let size):
            let screenWidth = UIScreen.main.bounds.size.width
            return CGRect(origin: CGPoint(x: screenWidth - insets.left - size.width - saInsets.right, y: saInsets.top + insets.top), size: size)
        case .bottomLeft(let size):
            let screenHeight = UIScreen.main.bounds.size.height
            return CGRect(origin: CGPoint(x: saInsets.left + insets.left, y: screenHeight - insets.bottom - size.height - saInsets.bottom), size: size)
        case .bottomRight(let size):
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width
            return CGRect(
                origin: CGPoint(
                    x: screenWidth - insets.left - size.width - saInsets.right,
                    y: screenHeight - insets.bottom - size.height - saInsets.bottom),
                size: size)
        case .centerLeft(let size):
            let screenHeight = UIScreen.main.bounds.size.height
            return CGRect(origin: CGPoint(x: saInsets.left + insets.left, y: (screenHeight - size.height) / 2.0), size: size)
        case .centerRight(let size):
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width
            return CGRect(
                origin: CGPoint(
                    x: screenWidth - insets.left - size.width - saInsets.right,
                    y: (screenHeight - size.height) / 2.0),
                size: size)
        case .center(let size):
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width
            return CGRect(
                origin: CGPoint(
                    x: (screenWidth - size.width) / 2.0,
                    y: (screenHeight - size.height) / 2.0),
                size: size)
        case .topCenter(let size):
            let screenWidth = UIScreen.main.bounds.size.width
            return CGRect(
                origin: CGPoint(
                    x: (screenWidth - size.width) / 2.0,
                    y: saInsets.top + insets.top),
                size: size)
        case .bottomCenter(let size):
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width
            return CGRect(
                origin: CGPoint(
                    x: (screenWidth - size.width) / 2.0,
                    y: screenHeight - insets.bottom - size.height - saInsets.bottom),
                size: size)
        case .custom(let rect):
            let bounds = UIScreen.main.bounds
            var x = rect.origin.x
            var y = rect.origin.y
            let w = rect.size.width
            let h = rect.size.height

            //  |- [] ----|
            var fx: CGFloat = x
            var fy: CGFloat = y

            if x + w > bounds.size.width {
                fx = x - w
            }

            if fx < 0 && w < bounds.size.width {
                fx = (bounds.size.width - w) / 2.0
            }

            if y + h > bounds.size.height {
                fy = y - h
            }

            if fy < 0 && h < bounds.size.height {
                fy = (bounds.size.height - h) / 2.0
            }
            return CGRect(x: fx, y: fy, width: w, height: h)
        }
    }

    private static func getHeight(_ safeAreaStyle: CXSafeAreaStyle, insets: UIEdgeInsets) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height - insets.top - insets.bottom
        switch safeAreaStyle {
        case .on:
            return screenHeight - safeAreaInsets.top - safeAreaInsets.bottom
        case .off:
            return screenHeight
        }
    }

    private static func getWidth(_ safeAreaStyle: CXSafeAreaStyle, insets: UIEdgeInsets) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width - insets.left - insets.right
        switch safeAreaStyle {
        case .on:
            return screenWidth - safeAreaInsets.left - safeAreaInsets.right
        case .off:
            return screenWidth
        }
    }

    private static func getLatestInsets(_ safeAreaStyle: CXSafeAreaStyle) -> UIEdgeInsets {
        return safeAreaStyle == .on ? safeAreaInsets : .zero
    }
}