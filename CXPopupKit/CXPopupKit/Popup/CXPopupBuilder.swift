//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

public typealias CXPopupAction = (Any?) -> Void
public typealias CXSimpleAction = () -> Void

public class CXPopupBuilder {
    let popup = CXBasicPopupWindow()
    weak var prsenting: UIViewController?
    
    public init(content: CXPopupable, presenting: UIViewController?) {
        popup.contentView = content
        self.prsenting = presenting
    }
    
    public func withAppearance(_ appearance: CXPopupAppearance) -> Self {
        popup.popupAppearance = appearance
        return self
    }

    @discardableResult
    func withViewDidAppear(_ action: @escaping CXSimpleAction) -> Self {
        popup.viewDidAppearAction = action
        return self
    }
    
    public func build() -> CXPopupWindow & UIViewController {
        popup.cxPresentationController = CXPresentationController(presented: popup, presenting: self.prsenting, appearance: popup.popupAppearance)
        return popup
    }
}
