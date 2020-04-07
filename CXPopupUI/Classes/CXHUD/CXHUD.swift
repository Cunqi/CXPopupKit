import UIKit
import CXPopupKit

public class CXHUD {
    var hudInstance: CXHUDViewController
    private static let shared = CXHUD()
    
    private init() {
        hudInstance = CXHUDViewController()
    }
    
    /// Dismiss current HUD from the top most view
    /// - Parameters:
    ///   - delay: time delay for dismissing the HUD
    ///   - completion: completion after dismissed
    public static func dismissHUD(_ delay: TimeInterval = 0, _ completion: (() -> Void)? = nil) {
        
    }
    
    public static func showLoading(with text: String?, _ anchorView: UIView) {
        guard let presentingVC = getTopMostVC(from: anchorView) else {
            return
        }
        
        let popup = CXPopupController(
            presentingVC,
            CXHUD.shared.hudInstance,
            CXPopupStyle.styleForHUD(),
            dismissalCompletionBlock: nil)
        
        presentingVC.present(popup, animated: true)
    }
    
    private static func getTopMostVC(from view: UIView) -> UIViewController? {
        if #available(iOS 13, *) {
            return view.window?.rootViewController
        }
        return UIApplication.shared.delegate?.window??.rootViewController
    }
}

class CXHUDViewController: PopupContainableViewController {
    private var activityIndicatorView: UIActivityIndicatorView!
    private var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension CXPopupStyle {
    static func styleForHUD() -> CXPopupStyle {
        let style = CXPopupStyle.style(axisX: .center)
        style.width = .fixed(120)
        style.height = .fixed(120)
        style.backgroundColor = .black
        return style
    }
}
