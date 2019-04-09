//
//  CXLayoutStyle.swift
//  CXLayoutKit
//
//  Created by Cunqi Xiao on 4/8/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import UIKit

/// Describe Layout attributes with position & size
///
/// - left: attatched to left edge of screen, construct size with given width and screen height
/// - right: attatched to right edge of screen, construct size with given width and screen height
/// - top: attatched to top edge of screen, construct size with given height and screen width
/// - bottom: attatched to bottom edge of screen, construct size with given height and screen width
/// - center: attatched to center of screen, with given size
/// - topLeft: attatched to top left of screen, with given size
/// - topRight: attatched to top right of screen, with given size
/// - bottomLeft: attatched to bottom left of screen, with given size
/// - bottomRight: attatched to bottom right of screen, with given size
/// - centerLeft: attatched to center left of screen, with given size
/// - centerRight: attatched to center right of screen, with given size
/// - topCenter: attatched to top center of screen, with given size
/// - bottomCenter: attatched to bottom center of screen, with given size
/// - custom: attatched to given position with given size
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
