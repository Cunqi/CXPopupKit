//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

public typealias CXPopupAction = (Any?) -> Void

public class CXPopup {
    let popup: CXBasicPopupWindow
    
    public init(content: CXPopupable) {
        self.popup = CXBasicPopupWindow()
        popup.contentView = content
    }
    
    public func withStyle(_ style: CXPopupAppearance) -> Self {
        popup.popupAppearance = style
        return self
    }
    
    public func withPositiveAction(_ action: @escaping CXPopupAction) -> Self {
        popup.positiveAction = action
        return self
    }
    
    public func withNegativeAction(_ action: @escaping CXPopupAction) -> Self {
        popup.negativeAction = action
        return self
    }
    
    public func build() -> CXPopupWindow {
        return popup
    }
}
