import UIKit

public typealias CXPopupContainableViewController = UIViewController & CXPopupControlDelegate

public protocol CXPopupControlDelegate: UIViewController {
    var popup: CXPopupController? { get }
    
    func shouldOutsideTouchTriggerDismissalCompletionBlock() -> Bool
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
    
    func shouldOutsideTouchTriggerDismissalCompletionBlock() -> Bool {
        return false
    }
}

public class CXPopupController: UIViewController {
    public var style: CXPopupStyle {
        didSet {
            self.popupPresentationController?.style = style
        }
    }
    
    public var dismissalCompletionBlock: (( )-> Void)?

    private let containableViewController: CXPopupContainableViewController
    private var popupPresentationController: CXPresentationController?
    
    /// The only initializer method to create a popup
    /// - Parameters:
    ///   - attachedAtViewController: the
    ///   - containableViewController: the view controller which intents to present the popup
    ///   - style: popup style
    ///   - dismissalCompletionBlock: dismiss action after the popup dismissed
    public init(_ attachedAtViewController: UIViewController,
                _ containableViewController: CXPopupContainableViewController,
                _ style: CXPopupStyle = CXPopupStyle(),
                dismissalCompletionBlock: (() -> Void)? = nil) {
        self.style = style
        self.containableViewController = containableViewController
        super.init(nibName: nil, bundle: nil)
        self.dismissalCompletionBlock = dismissalCompletionBlock
        self.popupPresentationController = CXPresentationController(style, self, attachedAtViewController)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PopupController deinited.")
    }

    // MARK - Lifecycle override

    override public func viewDidLoad() {
        super.viewDidLoad()
        addChild(containableViewController)
        view.addSubview(containableViewController.view)
        containableViewController.didMove(toParent: self)
        setupUI()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popupPresentationController = nil
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }

    public override func dismiss(animated flag: Bool, completion : (() -> ())?) {
        super.dismiss(animated: flag, completion: completion ?? dismissalCompletionBlock)
    }

    // MARK - private helper methods
    
    func shouldOutsideTouchTriggerDismissalCompletionBlock() -> Bool {
        containableViewController.shouldOutsideTouchTriggerDismissalCompletionBlock()
    }

    private func setupUI() {
        view.backgroundColor = style.backgroundColor
        CXLayoutUtil.setupFill(containableViewController.view, view, style.position.padding(style.safeAreaPolicy))
    }
}

