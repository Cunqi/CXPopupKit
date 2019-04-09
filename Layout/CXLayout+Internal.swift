//
//  CXLayout+Internal.swift
//  CXLayoutKit
//
//  Created by Cunqi Xiao on 4/8/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import UIKit

extension CXLayoutStyle {
    var screen: CGRect {
        return UIScreen.main.bounds
    }

    var size: CGSize {
        switch self {
        case .left(let width):
            return CGSize(width: width, height: screen.height)
        case .right(let width):
            return CGSize(width: width, height: screen.height)
        case .top(let height):
            return CGSize(width: screen.width, height: height)
        case .bottom(let height):
            return CGSize(width: screen.width, height: height)
        case .center(let size):
            return size
        case .topLeft(let size):
            return size
        case .topRight(let size):
            return size
        case .bottomLeft(let size):
            return size
        case .bottomRight(let size):
            return size
        case .centerLeft(let size):
            return size
        case .centerRight(let size):
            return size
        case .topCenter(let size):
            return size
        case .bottomCenter(let size):
            return size
        case .custom(let rect):
            return rect.size
        }
    }

    func insets(_ origin: UIEdgeInsets) -> UIEdgeInsets {
        switch self {
        case .left:
            return UIEdgeInsets(top: 0, left: origin.left, bottom: 0, right: 0)
        case .right:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: origin.right)
        case .top:
            return UIEdgeInsets(top: origin.top, left: 0, bottom: 0, right: 0)
        case .bottom:
            return UIEdgeInsets(top: 0, left: 0, bottom: origin.bottom, right: 0)
        case .center:
            return .zero
        case .topLeft:
            return UIEdgeInsets(top: origin.top, left: origin.left, bottom: 0, right: 0)
        case .topRight:
            return UIEdgeInsets(top: origin.top, left: 0, bottom: 0, right: origin.right)
        case .bottomLeft:
            return UIEdgeInsets(top: 0, left: origin.left, bottom: origin.bottom, right: 0)
        case .bottomRight:
            return UIEdgeInsets(top: 0, left: 0, bottom: origin.bottom, right: origin.right)
        case .centerLeft:
            return UIEdgeInsets(top: 0, left: origin.left, bottom: 0, right: 0)
        case .centerRight:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: origin.right)
        case .topCenter:
            return UIEdgeInsets(top: origin.top, left: 0, bottom: 0, right: 0)
        case .bottomCenter:
            return UIEdgeInsets(top: 0, left: 0, bottom: origin.bottom, right: 0)
        case .custom:
            return .zero
        }
    }

    mutating func update(size: CGSize) {
        switch self {
        case .left:
            self = .left(width: size.width)
        case .right:
            self = .right(width: size.width)
        case .top:
            self = .top(height: size.height)
        case .bottom:
            self = .bottom(height: size.height)
        case .topLeft:
            self = .topLeft(size: size)
        case .topRight:
            self = .topRight(size: size)
        case .bottomLeft:
            self = .bottomLeft(size: size)
        case .bottomRight:
            self = .bottomRight(size: size)
        case .centerLeft:
            self = .centerLeft(size: size)
        case .centerRight:
            self = .centerRight(size: size)
        case .center:
            self = .center(size: size)
        case .topCenter:
            self = .topCenter(size: size)
        case .bottomCenter:
            self = .bottomCenter(size: size)
        case .custom(let rect):
            self = .custom(rect: CGRect(origin: rect.origin, size: size))
        }
    }


    func safeAreaInsets() -> UIEdgeInsets {
        return insets(CXSafeAreaStyle.safeAreaInsets)
    }
}
