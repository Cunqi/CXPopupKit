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
}

public struct CXPopupConfig {
    // MARK - Properties: LayoutStyle
    public var layoutStyle = CXLayoutStyle.center
    
    // MARK - Properties: Shadow
    public var isShadowEnabled: Bool = false
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.8
    public var shadowRadius: CGFloat = 13.0
    public var shadowOffset: CGSize = CGSize(width: 0, height: 6.0)
    
    // MARK - Properties: Behavior
    public var isAutoRotateEnabled: Bool = false
    public var allTapOutsideToDismiss: Bool = true
    
    // MARK - Properties: SafeArea
    public var safeAreaType: CXSafeAreaType = .default
    
    /*UI*/
    public var maskBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.8)
    public var cornerRadius: CGFloat = 4.0
}
