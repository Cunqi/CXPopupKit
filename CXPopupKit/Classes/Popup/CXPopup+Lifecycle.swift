//
//  CXPopup+Lifecycle.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/3/19.
//

import UIKit

public protocol CXPopupLifecycleDelegate: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDisappear(_ dismissType: CXDismissType)
    func finalizeLayoutStyleBeforeInstallConstraints(_ current: CXPopupAppearance, _ submit: (CXLayoutStyle) -> Void)
}

public extension CXPopupLifecycleDelegate {
    func viewDidLoad(){}
    func viewWillAppear(){}
    func viewDidDisappear(_ dismissType: CXDismissType){}
    func finalizeLayoutStyleBeforeInstallConstraints(_ current: CXPopupAppearance, _ submit: (CXLayoutStyle) -> Void){}
}
