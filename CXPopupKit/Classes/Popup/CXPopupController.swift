import UIKit

public typealias PopupContainableViewController = UIViewController & CXPopupControlDelegate

public protocol CXPopupControlDelegate {
    func notifyPopupControllerDismissal() -> Bool
}

public class CXPopupController: UIViewController {
    public var style: CXPopupStyle

    private let containableViewController: PopupContainableViewController
    private var cxPresentationController: CXPresentationController?
    private let dismissalCompletionBlock: (( )-> Void)?

    // MARK - Initialization & De-initialization

    public init(_ attachedViewController: UIViewController,
                _ containableViewController: PopupContainableViewController,
                _ style: CXPopupStyle = CXPopupStyle(),
                dismissalCompletionBlock: (() -> Void)? = nil) {
        self.style = style
        self.containableViewController = containableViewController
        self.dismissalCompletionBlock = dismissalCompletionBlock
        super.init(nibName: nil, bundle: nil)
        self.cxPresentationController = CXPresentationController(style, self, attachedViewController)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK - Lifecycle override

    override public func viewDidLoad() {
        super.viewDidLoad()
        addChild(containableViewController)
        view.addSubview(containableViewController.view)
        containableViewController.didMove(toParent: self)
        setupUI()
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }

    public override func dismiss(animated flag: Bool, completion _: (() -> ())?) {
        if containableViewController.notifyPopupControllerDismissal() {
            super.dismiss(animated: flag, completion: dismissalCompletionBlock)
        }
    }

    // MARK - private helper methods

    private func setupUI() {
        view.backgroundColor = style.backgroundColor
        CXLayoutUtil.setupFill(containableViewController.view, self.view, style.position.padding(style.safeAreaPolicy))
    }
}

