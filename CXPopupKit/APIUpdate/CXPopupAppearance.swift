//
//  CXPopupAppearance.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/5/18.
//  Copyright © 2018 Cunqi Xiao. All rights reserved.
//

import UIKit


/// Control the unify appearance style of displayed popup window
public class CXPopupAppearance {
    static let `default` = CXPopupAppearance()

    public init() {}

    static func createAppearance() -> CXPopupAppearance {
        var appearance = CXPopupAppearance()
        appearance.animation = CXPopupAppearance.default.animation
        appearance.shadow = CXPopupAppearance.default.shadow
        appearance.orientation = CXPopupAppearance.default.orientation
        appearance.uiStyle = CXPopupAppearance.default.uiStyle
        appearance.dimension = CXPopupAppearance.default.dimension
        appearance.isTouchOutsideDismissEnabled = CXPopupAppearance.default.isTouchOutsideDismissEnabled
        return appearance
    }

    public var shadow = Shadow()
    public var orientation = Orientation()
    public var uiStyle = UIStyle()
    public var dimension = Dimension()
    public var animation = Animation()

    public var isTouchOutsideDismissEnabled = true

    public struct Shadow {
        public var isEnabled = true
        public var radius: CGFloat = 2.0
        public var opacity: Float = 0.5
        public var offset: CGSize = CGSize(width: 1.0, height: 1.0)
        public var color: UIColor = .black
    }

    public struct Orientation {
        public var isAutoRotationEnabled = false
        public var supportedInterfaceOrientations: UIInterfaceOrientationMask = .all
        public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation = .portrait
    }

    public struct UIStyle {
        public var maskBackgroundColor: UIColor = .black
        public var maskBackgroundAlpha: CGFloat = 0.3
        public var popupBackgroundColor: UIColor? = nil
    }

    public struct Dimension {
        public var width: CXWindowLength = .matchPartent
        public var height: CXWindowLength = .matchPartent
        public var position: CXWindowPosition = .center
        public var safeAreaOption: CXWindowSafeAreaOption = .normal
        public var margin: UIEdgeInsets = .zero
    }

    public struct Animation {
        public var style: CXAnimationStyle = .plain
        public var transition: CXAnimationTransition = .roundTrip(direction: .center)
        public var duration: CXAnimationDuration = .roundTrip(duration: 0.35)
    }
}
