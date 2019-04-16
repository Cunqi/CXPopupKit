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
}

public extension CXPopupLifecycleDelegate {
    func viewDidLoad(){}
    func viewWillAppear(){}
    func viewDidDisappear(_ dismissType: CXDismissType){}
}
