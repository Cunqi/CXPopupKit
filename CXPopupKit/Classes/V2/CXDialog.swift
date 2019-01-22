//
//  CXDialog.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

class CXDialog: UIViewController {
    private let customView: UIView
    private let config: CXPopupConfig
    private weak var delegate: CXPopupLifeCycleDelegate?
    
    init(_ view: UIView, _ config: CXPopupConfig, _ delegate: CXPopupLifeCycleDelegate?) {
        self.customView = view
        self.config = config
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CXLayoutUtil.fill(customView, at: view)
        delegate?.viewDidLoad()
    }
}
