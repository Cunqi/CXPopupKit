//
//  CXAlertAction.swift
//  CXPopupKit
//
//  Created by Cunqi on 10/2/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

enum CXAlertActionType {
    case `default`
    case cancel
}

enum CXDividerPosition {
    case top
    case bottom
    case left
    case right
}

class CXAlertAction {
    static let buttonHeight: CGFloat = 44
    
    let button: UIButton
    let type: CXAlertActionType
    var handler: CXAlertActionHandler
    
    init(_ name: String, _ type: CXAlertActionType, _ handler: @escaping CXAlertActionHandler) {
        self.button = UIButton(type: .custom)
        self.type = type
        self.handler = handler
        setupAlertButton(name)
    }
    
    func attachDividerOnButton(at position: CXDividerPosition) {
        let divider = UIView()
        divider.backgroundColor = CXColorStyle.divider
        self.button.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        if position == .top || position == .bottom {
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
            divider.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        } else {
            divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
            divider.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
            divider.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        }
        
        switch position {
        case .top:
            divider.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        case .bottom:
            divider.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        case .left:
            divider.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        case .right:
            divider.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        }
    }
    
    private func setupAlertButton(_ name: String) {
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setBackgroundImage(createHighlightedImage(), for: .highlighted)
        button.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        attachDividerOnButton(at: .top)
        button.setTitleColor(type == .default ? CXColorStyle.important : CXColorStyle.normal, for: .normal)
    }
    
    private func createHighlightedImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(CXColorStyle.placeHolder.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc private func didTapActionButton(_ sender: UIButton) {
        handler(button.title(for: .normal) ?? "")
    }
}

