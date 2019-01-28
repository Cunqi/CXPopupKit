//
//  CXPopupConfig.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

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
}

public struct CXPopupConfig {
    public init() {}
    // MARK - Properties: LayoutStyle
    public var layoutStyle = CXLayoutStyle.center(size: .zero)
    public var layoutInsets = UIEdgeInsets.zero
    
    // MARK - Properties: Shadow
    public var isShadowEnabled: Bool = true
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.8
    public var shadowRadius: CGFloat = 26.0
    public var shadowOffset: CGSize = CGSize(width: 0, height: 13.0)
    
    // MARK - Properties: Behavior
    public var isAutoRotateEnabled: Bool = false
    public var allowTouchOutsideToDismiss: Bool = true
    
    // MARK - Properties: SafeArea
    public var safeAreaStyle: CXSafeAreaStyle = .on
    
    // MARK - Properties: UI
    public var maskBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.8)
    public var cornerRadius: CGFloat = 4.0

    // MARK - Properties: Animation
    public var animationStyle: CXAnimationStyle = .basic
    public var animationDuration: CXAnimationDuration = CXAnimationDuration(round: 0.35)
    public var animationTransition: CXAnimationTransition = CXAnimationTransition(.center)
}
