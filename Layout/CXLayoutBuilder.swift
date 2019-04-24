//
//  CXLayoutBuilder.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/8/19.
//

import UIKit

class CXLayoutBuilder {

    static func addToRoundedCornerContainer(_ view: UIView, _ container: UIView, _ layoutStyle: CXLayoutStyle) {
        fill(view, container, .zero)
    }

    static func fillToShadowContainer(_ roundedCornerContainer: UIView, _ shadowContainer: UIView) {
        fill(roundedCornerContainer, shadowContainer, .zero)
    }

    static func addToSafeAreaContainer(_ content: UIView, _ safeAreaContainer: UIView, _ layoutStyle: CXLayoutStyle) {
        let safeAreaInsets = layoutStyle.safeAreaInsets()
        fill(content, safeAreaContainer, safeAreaInsets)
    }

    static func attachToRootView(_ view: UIView, _ rootView: UIView, _ layoutStyle: CXLayoutStyle, _ layoutInsets: UIEdgeInsets) {
        addSubView(view, rootView)
        let insets = layoutStyle.insets(layoutInsets)
        installHorizontalConstraint(view, rootView, layoutStyle, insets)
        attachVerticalConstraint(view, rootView, layoutStyle, insets)
    }

    private static func installHorizontalConstraint(_ view: UIView, _ rootView: UIView, _ layoutStyle: CXLayoutStyle, _ insets: UIEdgeInsets) {
        switch layoutStyle {
        case .left, .topLeft, .centerLeft, .bottomLeft:
            view.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: insets.left).isActive = true
        case .right, .topRight, .centerRight, .bottomRight:
            view.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -insets.right).isActive = true
        case .center, .topCenter, .bottomCenter:
            view.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        case .bottom, .top:
            view.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: insets.left).isActive = true
            view.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -insets.right).isActive = true
        case .custom(let rect):
            view.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: rect.origin.x).isActive = true
        }
    }

    private static func attachVerticalConstraint(_ view: UIView, _ rootView: UIView, _ layoutStyle: CXLayoutStyle, _ insets: UIEdgeInsets) {
        switch layoutStyle {
        case .center, .centerLeft, .centerRight:
            view.centerYAnchor.constraint(equalTo: rootView.centerYAnchor).isActive = true
        case .top, .topLeft, .topCenter, .topRight:
            view.topAnchor.constraint(equalTo: rootView.topAnchor, constant: insets.top).isActive = true
        case .bottom, .bottomLeft, .bottomCenter, .bottomRight:
            view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -insets.bottom).isActive = true
        case .left, .right:
            view.topAnchor.constraint(equalTo: rootView.topAnchor, constant: insets.top).isActive = true
            view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -insets.bottom).isActive = true
        case .custom(let rect):
            view.topAnchor.constraint(equalTo: rootView.topAnchor, constant: rect.origin.y)
        }
    }

    static func fill(_ view: UIView, _ parent: UIView, _ insets: UIEdgeInsets) {
        addSubView(view, parent)
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left).isActive = true
        view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.right).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom).isActive = true
    }

    private static func addSubView(_ content: UIView, _ parent: UIView) {
        if content.isDescendant(of: parent) {
            content.removeFromSuperview()
        }
        parent.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
    }

    static func setSizeConstraint(_ content: UIView, _ parent: UIView, _ layoutStyle: CXLayoutStyle) {
        let size = layoutStyle.size
        guard size != .zero else {
            return
        }
        switch layoutStyle {
        case .left, .right:
            content.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            content.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        case .bottom, .top:
            content.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
            content.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        default:
            content.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            content.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension UIEdgeInsets {
    func merge(_ another: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: top + another.top,
                            left: left + another.left,
                            bottom: bottom + another.bottom,
                            right: right + another.right)
    }
}

extension CGFloat {
    var half: CGFloat {
        return self * 0.5
    }
    var quarter: CGFloat {
        return self * 0.25
    }
}
