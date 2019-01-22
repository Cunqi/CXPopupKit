//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public protocol CXPopupLifeCycleDelegate: class {
    func viewDidLoad()
}

public class CXPopup {
    private let dialog: UIViewController
    init(_ view: UIView, _ config: CXPopupConfig, _ delegate: CXPopupLifeCycleDelegate?) {
        dialog = CXDialog(view, config, delegate)
    }
    
    public func show() {
        
    }
    
    public func dismiss() {
        
    }
    
    public class Builder {
        public init(view: UIView) {
            self.view = view
        }
        
        private var view: UIView
        private var config: CXPopupConfig = CXPopupConfig()
        private weak var delegate: CXPopupLifeCycleDelegate?
        
        public func withConfig(_ config: CXPopupConfig) {
            self.config = config
        }
        
        public func withDelegate(_ delegate: CXPopupLifeCycleDelegate) {
            self.delegate = delegate
        }
        
        public func create() -> CXPopup {
            return CXPopup(view, config, delegate)
        }
    }
}
