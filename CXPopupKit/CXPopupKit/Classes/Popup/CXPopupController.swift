import UIKit

public typealias PopupContainableViewController = UIViewController & CXPopupControlDelegate

public protocol CXPopupControlDelegate: UIViewController {
    var popup: CXPopupController? { get }
}

public extension CXPopupControlDelegate {
    var popup: CXPopupController? {
        var parent = self.parent
        while parent != nil {
            if parent is CXPopupController {
                return parent as? CXPopupController
            }
            parent = parent?.parent
        }
        return nil
    }
}

public class CXPopupController: UIViewController {
    public var style: CXPopupStyle {
        didSet {
            self.popupPresentationController?.style = style
        }
    }

    private let containableViewController: PopupContainableViewController
    private var popupPresentationController: CXPresentationController?
    private let dismissalCompletionBlock: (( )-> Void)?
    
    /// The only initializer method to create a popup
    /// - Parameters:
    ///   - attachedAtViewController: the
    ///   - containableViewController: the view controller which intents to present the popup
    ///   - style: popup style
    ///   - dismissalCompletionBlock: dismiss action after the popup dismissed
    public init(_ attachedAtViewController: UIViewController,
                _ containableViewController: PopupContainableViewController,
                _ style: CXPopupStyle = CXPopupStyle(),
                dismissalCompletionBlock: (() -> Void)? = nil) {
        self.style = style
        self.containableViewController = containableViewController
        self.dismissalCompletionBlock = dismissalCompletionBlock
        super.init(nibName: nil, bundle: nil)
        self.popupPresentationController = CXPresentationController(style, self, attachedAtViewController)
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
        super.dismiss(animated: flag, completion: dismissalCompletionBlock)
    }

    // MARK - private helper methods

    private func setupUI() {
        view.backgroundColor = style.backgroundColor
        CXLayoutUtil.setupFill(containableViewController.view, view, style.position.padding(style.safeAreaPolicy))
    }
}

