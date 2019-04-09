//
//  BasePopupController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/9/19.
//

import UIKit

public typealias CXView = UIView & CXDialog
public typealias CXViewController = UIViewController & CXDialog

public protocol CXPopupInteractable: class {
    func dismiss()
    func pop(on vc: UIViewController?)
}

/// The base popup controller, define the basic behavior that a popup has,
/// for example, how to layout subviews, add child view controller, etc.
public class BasePopupController: UIViewController {

    /// Respect auto rotate config in popup appearance
    override public var shouldAutorotate: Bool {
        return appearance.isAutoRotateEnabled
    }

    public weak var delegate: CXPopupLifecycleDelegate?

    /// Appearance for popup controller
    let appearance: CXPopupAppearance

    let popupContainer: PopupContainer

    /// popup view controller
    var viewController: UIViewController

    /// Customized presentation manager
    var presentationManager: CXPresentationManager!

    /// Popup custom view with customized popup appearance
    ///
    /// - Parameters:
    ///   - content: custom view
    ///   - appearance: popup appearance
    ///   - delegate: hook to popup lifecycle methods
    public convenience init(_ content: CXView, appearance: CXPopupAppearance, _ delegate: CXPopupLifecycleDelegate? = nil) {
        let contentContainer = PopupContentContainer(content)
        self.init(contentContainer, appearance, delegate)
    }

    /// Popup custom view controller with customized popup appearance
    ///
    /// - Parameters:
    ///   - viewController: custom view controller
    ///   - appearance: popup appearance
    ///   - delegate: hook to popup lifecycle methods
    public init(_ viewController: CXViewController, _ appearance: CXPopupAppearance, _ delegate: CXPopupLifecycleDelegate? = nil) {
        self.popupContainer = PopupContainer(appearance)
        self.viewController = viewController
        self.appearance = appearance
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        presentationManager = CXPresentationManager(appearance: appearance)
        transitioningDelegate = presentationManager
        modalPresentationStyle = .custom

        // Add child view controller
        addChild(viewController)
        popupContainer.install(viewController.view)
        viewController.didMove(toParent: self)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Allow user to tap outside of content to dismiss the popup
        if appearance.allowTouchOutsideToDismiss {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutsideToDismiss))
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
        }

        delegate?.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.viewWillAppear()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear()
    }

    @objc private func tapOutsideToDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIGestureRecognizerDelegate
// Implement shouldReceive method to make sure only the touched view will response to the tap event.
// Reference: https://bencoding.com/2017/02/27/stopping-tap-gesture-from-bubbling-to-child-controls/
extension BasePopupController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}


// MARK: - CXPopupInteractable
extension BasePopupController: CXPopupInteractable {
    public func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    public func pop(on vc: UIViewController?) {
        vc?.present(self, animated: true, completion: nil)
    }
}
