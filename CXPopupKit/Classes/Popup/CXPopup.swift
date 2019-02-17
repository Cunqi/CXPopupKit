//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public typealias CXView = UIView & CXDialog
public typealias CXPopupAction = () -> Void

public protocol CXPopupLifeCycleDelegate: class {
    func viewDidLoad()
    func viewDidDisappear()
}

public protocol CXPopupInteractable: class {
    func dismiss()
    func dismiss(_ completion: CXPopupAction?)
    func pop()
    func pop(_ completion: CXPopupAction?)
}

public class CXPopup: UIViewController, CXPopupInteractable {
    override public var shouldAutorotate: Bool {
        return config.isAutoRotateEnabled
    }

    private let customView: CXView
    private let config: CXPopupConfig
    private weak var delegate: CXPopupLifeCycleDelegate?
    private weak var presenting: UIViewController?
    private var _presentationController: CXPresentationController?

    init(_ view: CXView, _ config: CXPopupConfig, _ delegate: CXPopupLifeCycleDelegate?, _ presenting: UIViewController?) {
        self.customView = view
        self.config = config
        self.delegate = delegate
        self.presenting = presenting
        super.init(nibName: nil, bundle: nil)
        self._presentationController = CXPresentationController(presentedViewController: self, presenting: presenting, config: config)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("CXPopup was destroyed.")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = config.popupBackgroundColor

        if config.safeAreaStyle == .wrap {
            let wrapper = CXLayoutUtil.createWrapperView(customView, layoutStyle: config.layoutStyle)
            wrapper.backgroundColor = config.safeAreaGapColor ?? customView.backgroundColor
            CXLayoutUtil.fill(wrapper, at: view, insets: config.padding)
        } else {
            CXLayoutUtil.fill(customView, at: view, insets: config.padding)
        }
        delegate?.viewDidLoad()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear()
        _presentationController = nil
    }

    public func dismiss() {
        dismiss(nil)
    }

    public func dismiss(_ completion: CXPopupAction? = nil) {
        self.dismiss(animated: true, completion: completion)
    }

    public func pop() {
        pop(nil)
    }

    public func pop(_ completion: CXPopupAction? = nil) {
        _presentationController = CXPresentationController(presentedViewController: self, presenting: presenting, config: config)
        self.presenting?.present(self, animated: true, completion: completion)
    }
    
    public class Builder {
        let view: CXView
        var config: CXPopupConfig
        weak var delegate: CXPopupLifeCycleDelegate?

        public init(_ view: CXView) {
            self.view = view
            self.config = CXPopupConfig()
        }
        
        public func withConfig(_ config: CXPopupConfig) -> Self {
            self.config = config
            return self
        }
        
        public func withDelegate(_ delegate: CXPopupLifeCycleDelegate) -> Self {
            self.delegate = delegate
            return self
        }
        
        public func create(on vc: UIViewController?) -> CXPopup {
            return CXPopup(view, config, delegate, vc)
        }
    }
}

public extension CXPopupLifeCycleDelegate {
    func viewDidLoad(){}
    func viewDidDisappear(){}
}
