//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public typealias CXView = UIView & CXDialog

public protocol CXPopupLifeCycleDelegate: class {
    func viewDidLoad()
    func viewDidDisappear()
}

public protocol CXPopupInteractable: class {
    func dismiss(completion: (() -> Void)?)
}

public class CXPopup: UIViewController, CXPopupInteractable {
    override public var shouldAutorotate: Bool {
        return config.isAutoRotateEnabled
    }

    private let customView: CXView
    private let config: CXPopupConfig
    private weak var delegate: CXPopupLifeCycleDelegate?

    private var _presentationController: CXPresentationController?

    init(_ view: CXView, _ config: CXPopupConfig, _ delegate: CXPopupLifeCycleDelegate?, _ presenting: UIViewController?) {
        self.customView = view
        self.config = config
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self._presentationController = CXPresentationController(presentedViewController: self, presenting: presenting, config: config)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if config.safeAreaStyle == .wrap {
            let wrapper = CXLayoutUtil.createWrapperView(customView, layoutStyle: config.layoutStyle)
            wrapper.backgroundColor = config.safeAreaGapColor ?? customView.backgroundColor
            CXLayoutUtil.fill(wrapper, at: view)
        } else {
            CXLayoutUtil.fill(customView, at: view)
        }
        delegate?.viewDidLoad()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear()
        _presentationController = nil
    }

    public func dismiss(completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }
    
    public class Builder {
        public init(view: CXView) {
            self.view = view
        }
        
        private let view: CXView
        private var config: CXPopupConfig = CXPopupConfig()
        private weak var delegate: CXPopupLifeCycleDelegate?
        
        public func withConfig(_ config: CXPopupConfig) -> Self {
            self.config = config
            return self
        }
        
        public func withDelegate(_ delegate: CXPopupLifeCycleDelegate) -> Self {
            self.delegate = delegate
            return self
        }
        
        public func create(on vc: UIViewController?) -> UIViewController {
            return CXPopup(view, config, delegate, vc)
        }
    }
}
