//
//  CXPopup.swift
//  CXPopupKit
//
//  Created by Cunqi on 1/20/19.
//

import UIKit

public typealias CXView = UIView & CXDialog
public typealias CXPopupAction = () -> Void

public protocol CXPopupInteractable: class {
    func dismiss()
    func pop(on vc: UIViewController?)
}

public class CXPopup: UIViewController, CXPopupInteractable {
    override public var shouldAutorotate: Bool {
        return config.isAutoRotateEnabled
    }

    private let customView: CXView
    private let config: CXPopupConfig
    private weak var delegate: CXPopupLifeCycleDelegate?
    private var presentationManager: CXPresentationManager!
    private var action: CXPopupAction?

    private lazy var shadowContainer: UIView = {
        let view = UIView()
        if self.config.isShadowEnabled {
            view.layer.shadowOpacity = config.shadowOpacity
            view.layer.shadowRadius = config.shadowRadius
            view.layer.shadowOffset = config.shadowOffset
            view.layer.shadowColor = config.shadowColor.cgColor
            view.layer.masksToBounds = false
        }
        return view
    }()

    private lazy var roundedCornerContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = self.config.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    convenience init(_ view: CXView, _ config: CXPopupConfig, _ delegate: CXPopupLifeCycleDelegate?) {
        self.init(view, config, delegate, nil)
    }

    init(_ view: CXView, _ config: CXPopupConfig, _ delegate: CXPopupLifeCycleDelegate?, _ presenting: UIViewController?) {
        self.customView = view
        self.config = config
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        presentationManager = CXPresentationManager(config: config)
        transitioningDelegate = presentationManager
        modalPresentationStyle = .custom
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
            let wrapper = UIView()
            wrapper.backgroundColor = config.safeAreaGapColor ?? customView.backgroundColor
            CXLayoutBuilder.addToSafeAreaContainer(customView, wrapper, config.layoutStyle)
            CXLayoutBuilder.setSizeConstraint(customView, wrapper, config.layoutStyle)
            CXLayoutBuilder.addToRoundedCornerContainer(wrapper, roundedCornerContainer, config.layoutStyle, config.layoutInsets)
        } else {
            CXLayoutBuilder.addToRoundedCornerContainer(customView, roundedCornerContainer, config.layoutStyle, config.layoutInsets)
            CXLayoutBuilder.setSizeConstraint(customView, roundedCornerContainer, config.layoutStyle)
        }

        CXLayoutBuilder.fillToShadowContainer(roundedCornerContainer, shadowContainer)
        CXLayoutBuilder.attachToRootView(shadowContainer, self.view, config.layoutStyle, config.layoutInsets)

        delegate?.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.viewWillAppear()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        delegate?.viewDidDisappear()
        super.viewDidDisappear(animated)
    }

    public func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    public func pop(on vc: UIViewController?) {
        vc?.present(self, animated: true, completion: nil)
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
        
        public func create() -> CXPopup {
            return CXPopup(view, config, delegate)
        }
    }
}
