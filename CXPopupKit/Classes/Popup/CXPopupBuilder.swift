//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 7/10/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

public typealias CXVoidAction = () -> Void

public class CXPopupBuilder {
    let popup: CXBasePopupController
    
    public init(content: CXPopupable & UIView, presenting: UIViewController?) {
        popup = CXBasePopupController(content, presenting)
    }
    
    public func withAppearance(_ appearance: CXPopupAppearance) -> Self {
        popup.popupAppearance = appearance
        return self
    }

    @discardableResult
    func withViewDidAppear(_ action: @escaping CXVoidAction) -> Self {
        popup.viewDidAppearAction = action
        return self
    }
    
    public func build() -> UIViewController {
        return popup
    }
}
