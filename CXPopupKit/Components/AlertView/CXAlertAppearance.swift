//
//  CXAlertAppearance.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/10/17.
//  Copyright © 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

public enum CXAlertType {
    case alert
    case actionSheet

    var appearance: CXAlertAppearance {
        return CXAlertAppearance(with: self)
    }
}

public struct CXAlertAppearance {
    public struct Font {
        public var title = UIFont.boldSystemFont(ofSize: 16.0)
        public var detail = UIFont.systemFont(ofSize: 13.0)
        public var action = UIFont.boldSystemFont(ofSize: 14.0)
    }

    public struct Color {
        public var backgroundColor: UIColor = .white
        public var title: UIColor = .black
        public var detail: UIColor = .black
        public var actionBackground: UIColor = .white
        public var actionTitle: UIColor? = nil
    }

    public struct Separator {
        public var isEnabled: Bool = true
        public var color: UIColor = UIColor(white: 0, alpha: 0.15)
        public var width: CGFloat = 1
    }

    public struct Dimension {
        public var titleMargin: UIEdgeInsets = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        public var messageMargin: UIEdgeInsets = UIEdgeInsets(top: 24, left: 8, bottom: 24, right: 8)
        public var buttonHeight: CGFloat = 44
        public var cornerRadius: CGFloat = 8.0
        public var rectCorners: UIRectCorner = .allCorners
    }

    let alertType: CXAlertType
    var appearance = CXPopupAppearance()

    public var font = Font()
    public var dimension = Dimension()
    public var color = Color()
    public var separator = Separator()

    public var isModal = true {
        didSet {
            appearance.isTouchOutsideDismissEnabled = !isModal
        }
    }

    public init(with type: CXAlertType) {
        self.alertType = type

        switch alertType {
        case .actionSheet:
            appearance.dimension.width = .matchPartent
            appearance.dimension.position = .bottom
            appearance.dimension.safeAreaOption = .normal
            appearance.animation.style = .plain
            appearance.animation.duration = .roundTrip(duration: 0.35)
            appearance.animation.transition = .oneWay(in: .up, out: .down)
        case .alert:
            appearance.dimension.width = .fixValue(size: 300)
            appearance.animation.style = .bounceZoom
            appearance.animation.duration = .roundTrip(duration: 0.35)
            appearance.animation.transition = .oneWay(in: .up, out: .down)
            appearance.isTouchOutsideDismissEnabled = false
        }
    }
}
