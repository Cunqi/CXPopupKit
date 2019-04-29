//
//  BasePopupController.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/9/19.
//

import UIKit

public typealias CXView = UIView & CXDialog
public typealias CXViewController = UIViewController & CXDialog

public protocol CXPopupable {
    func pop(on vc: UIViewController?)
}

public protocol CXDismissable {
    func dismiss()
    func commit()
}

public protocol CXNavigateable {
    func didTapLeftBarButtonItem(_ action: CXPopupNavigateAction)
    func didTapRightBarButtonItem(_ action: CXPopupNavigateAction)
}

public typealias CXPopupInteractable = CXPopupable & CXDismissable & CXNavigateable


/// Describe why popup closed
///
/// - cancel: popup closed due to a cancel action.
/// - confirm: popup closed due to a confirm action.
public enum CXDismissType {
    case cancel
    case confirm
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
    var appearance: CXPopupAppearance {
        didSet {
            popupContainer.appearance = appearance
        }
    }

    let popupContainer: PopupContainer

    /// popup view controller
    var viewController: UIViewController

    /// Customized presentation manager
    var presentationManager: CXPresentationManager!

    /// Used to determine why you dismiss the popup
    /// This value will be used in `viewDidDisappear` lifecycle ONLY
    private var dismissType = CXDismissType.cancel


    /// Popup a navigateable view with customized popup appearance
    ///
    /// - Parameters:
    ///   - content: customized popup view
    ///   - title: title for the view
    ///   - left: left action for navigation
    ///   - right: right action for navigation
    ///   - appearance: popup appearance
    ///   - delegate: hook to popup lifecycle methods
    public convenience init(content: CXView,
                            title: String?,
                            left: CXPopupNavigateAction?,
                            right: CXPopupNavigateAction,
                            appearance: CXPopupAppearance,
                            delegate: CXPopupLifecycleDelegate? = nil) {
        let navigationController = CXNavigationController(title: title, left: left, right: right, view: content)
        self.init(navigationController, appearance, delegate)
    }


    /// Popup a navigateable view controller with customized popup appearance
    ///
    /// - Parameters:
    ///   - content: customized popup view controller
    ///   - title: title for the view controller
    ///   - left: left action for navigation
    ///   - right: right action for navigation
    ///   - appearance: popup appearance
    ///   - delegate: hook to popup lifecycle methods
    public convenience init(content: CXViewController,
                            title: String?,
                            left: CXPopupNavigateAction?,
                            right: CXPopupNavigateAction,
                            appearance: CXPopupAppearance,
                            delegate: CXPopupLifecycleDelegate? = nil) {
        let navigationController = CXNavigationController(title: title, left: left, right: right, viewController: content)
        self.init(navigationController, appearance, delegate)
    }

    /// Popup custom view with customized popup appearance
    ///
    /// - Parameters:
    ///   - content: custom view
    ///   - appearance: popup appearance
    ///   - delegate: hook to popup lifecycle methods
    public convenience init(_ content: CXView, _ appearance: CXPopupAppearance, _ delegate: CXPopupLifecycleDelegate? = nil) {
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
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print(String(describing: self) + "was destroyed.")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate?.finalizeLayoutStyleBeforeInstallConstraints(appearance, { [weak self] (layoutStyle) in
            self?.appearance.layoutStyle = layoutStyle
        })

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

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.viewDidAppear()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear(dismissType)
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
    public func didTapLeftBarButtonItem(_ action: CXPopupNavigateAction) {
    }

    public func didTapRightBarButtonItem(_ action: CXPopupNavigateAction) {
    }

    public func dismiss() {
        dismissType = .cancel
        self.dismiss(animated: true, completion: nil)
    }

    public func commit() {
        dismissType = .confirm
        self.dismiss(animated: true, completion: nil)
    }

    public func pop(on vc: UIViewController?) {
        vc?.present(self, animated: true, completion: nil)
    }
}
