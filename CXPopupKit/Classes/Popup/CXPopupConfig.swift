//
//  CXPopupConfig.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public enum CXSafeAreaStyle {
    case on
    case off
    case wrap
}

public enum CXLayoutStyle {
    case left(width: CGFloat)
    case right(width: CGFloat)
    case top(height: CGFloat)
    case bottom(height: CGFloat)
    case center(size: CGSize)
    case topLeft(size: CGSize)
    case topRight(size: CGSize)
    case bottomLeft(size: CGSize)
    case bottomRight(size: CGSize)
    case centerLeft(size: CGSize)
    case centerRight(size: CGSize)
    case topCenter(size: CGSize)
    case bottomCenter(size: CGSize)
    case custom(rect: CGRect)
}

public struct CXPopupConfig {
    public init() {}

    /// MARK - Layout Position & Size

    public var layoutStyle = CXLayoutStyle.center(size: .zero)
    public var layoutInsets: UIEdgeInsets = .zero
    
    /// MARK - Shadow

    public var isShadowEnabled: Bool = true
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.8
    public var shadowRadius: CGFloat = 26.0
    public var shadowOffset = CGSize(width: 0, height: 13.0)
    
    /// MARK - Rotation

    public var isAutoRotateEnabled = false

    /// MARK - Tap behavior

    public var allowTouchOutsideToDismiss = true
    
    /// MARK - Safe area

    public var safeAreaStyle = CXSafeAreaStyle.on
    
    /// MARK - UI

    public var maskBackgroundColor = UIColor(white: 0, alpha: 0.8)
    public var cornerRadius: CGFloat = 4.0
    public var safeAreaGapColor: UIColor? = nil

    /// MARK - Animation

    public var animationStyle = CXAnimationStyle.basic
    public var animationDuration = CXAnimationDuration(0.35, 0.12)
    public var animationTransition = CXAnimationTransition(.center)
    
    // MARK - Properties: Internal Usage
    var padding: UIEdgeInsets = .zero
    var popupBackgroundColor: UIColor? = nil
}

extension CXLayoutStyle {
    var size: CGSize {
        switch self {
        case .left(let width):
            let bounds = UIScreen.main.bounds.size
            return CGSize(width: width, height: bounds.height)
        case .right(let width):
            let bounds = UIScreen.main.bounds.size
            return CGSize(width: width, height: bounds.height)
        case .top(let height):
            let bounds = UIScreen.main.bounds.size
            return CGSize(width: bounds.width, height: height)
        case .bottom(let height):
            let bounds = UIScreen.main.bounds.size
            return CGSize(width: bounds.width, height: height)
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
}
