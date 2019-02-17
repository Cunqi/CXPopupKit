//
//  ButtonLayoutBuilder.swift
//  CXPopupKit
//
//  Created by Cunqi on 2/16/19.
//

import UIKit

class ButtonLayoutBuilder {
    private let button = UIButton(type: .custom)
    
    func withTitle(_ title: String, state: UIControl.State) -> Self {
        button.setTitle(title, for: state)
        return self
    }
    
    func withFont(_ font: UIFont) -> Self {
        button.titleLabel?.font = font
        return self
    }
    
    func withTitleColor(_ color: UIColor, state: UIControl.State) -> Self {
        button.setTitleColor(color, for: state)
        return self
    }
    
    func withBackgroundImage(_ image: UIImage?, state: UIControl.State) -> Self {
        button.setBackgroundImage(image, for: state)
        return self
    }
    
    func withTarget(_ target: Any?, action: Selector) -> Self {
        button.addTarget(target, action: action, for: .touchUpInside)
        return self
    }
    
    func build() -> UIButton {
        return button
    }
}
