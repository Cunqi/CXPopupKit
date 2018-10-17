//
//  CXPopupAppearance.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public struct CXPopupAppearance {
    /*Dimension*/
    public var width: CXEdgeSize = .full
    public var height: CXEdgeSize = .full
    public var position: CXPosition = .center
    public var safeAreaType: CXSafeAreaType = .default
    
    /*Shadow*/
    public var isShadowEnabled: Bool = false
    public var shadowColor: UIColor = .black
    public var shadowOpacity: Float = 0.8
    public var shadowRadius: CGFloat = 13.0
    public var shadowOffset: CGSize = CGSize(width: 0, height: 6.0)
    
    /*Orientation*/
    public var isAutoRotateEnabled: Bool = false

    /*UI*/
    public var backgroundColor: UIColor = .clear
    public var maskBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.8)
    public var maskBackgroundAlpha: CGFloat = 1.0
    public var cornerRadius: CGFloat = 4.0

    /*Behavior*/
    public var shouldDismissOnBackgroundTap: Bool = true
    
    // Animation
    public var animationStyle: CXAnimationStyle = .basic
    public var animationDuration: CXAnimationDuration = CXAnimationDuration(round: 0.35)
    public var animationTransition: CXAnimationTransition = CXAnimationTransition(in: .center)
    
    public init() {}
}
