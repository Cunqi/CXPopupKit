//
//  CXPopupWindowStyle.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

public struct CXPopupWindowStyle {
    /*Dimension*/
    public var width: CXEdgeSize = .full
    public var height: CXEdgeSize = .full
    public var position: CXPosition = .center
    public var margin: UIEdgeInsets = .zero
    
    /*Shadow*/
    public var isShadowEnabled: Bool = false
    public var shadowColor: UIColor = .black
    public var shadowOpacity: CGFloat = 0.8
    public var shadowRadius: CGFloat = 3.0
    
    /*Orientation*/
    public var isAutoRotateEnabled: Bool = false

    /*UI*/
    public var backgroundColor: UIColor = .clear
    public var maskBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.8)
    public var maskBackgroundAlpha: CGFloat = 1.0

    /*Behavior*/
    public var allOutsideDismiss: Bool = true
    
    
}
