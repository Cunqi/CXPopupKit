//
//  CXPopup+Lifecycle.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/3/19.
//

import UIKit

public protocol CXPopupLifeCycleDelegate: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDisappear()
}

public extension CXPopupLifeCycleDelegate {
    func viewDidLoad(){}
    func viewWillAppear(){}
    func viewDidDisappear(){}
}
