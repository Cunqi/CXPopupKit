//
//  CXPopupConfig.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public struct CXPopupAppearance {
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

    public var isAutoRotateEnabled = true

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
}
