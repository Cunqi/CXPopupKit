import UIKit
import CXPopupKit

public class CXHUD {
    
    public enum Style {
        case medium
        case large
    }
    
    var hudInstance: CXHUDViewController
    
    var hudTintColor: UIColor = .black
    var hudStyle: CXHUD.Style = .large
    
    let popupStyle: CXPopupStyle
    
    public static var backgroundColor: UIColor {
        get {
            CXHUD.shared.popupStyle.backgroundColor
        }
        set {
            CXHUD.shared.popupStyle.backgroundColor = newValue
        }
    }
    
    public static var tintColor: UIColor {
        get {
            CXHUD.shared.hudTintColor
        }
        set {
            CXHUD.shared.hudTintColor = newValue
        }
    }
    
    public static var hudStyle: CXHUD.Style {
        get {
            CXHUD.shared.hudStyle
        }
        set {
            CXHUD.shared.hudStyle = newValue
            CXHUD.shared.popupStyle.width = .fixed(newValue.size.width)
            CXHUD.shared.popupStyle.height = .fixed(newValue.size.height)
        }
    }
    
    static let shared = CXHUD()
    
    private init() {
        hudInstance = CXHUDViewController()
        popupStyle = CXPopupStyle.styleForHUD()
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
            CXHUD.shared.popupStyle,
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
    var activityIndicatorView: UIActivityIndicatorView!
    var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        activityIndicatorView = UIActivityIndicatorView(style: CXHUD.shared.hudStyle.asActivityIndicatorStyle)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.color = CXHUD.shared.hudTintColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
    }
}

extension CXPopupStyle {
    static func styleForHUD() -> CXPopupStyle {
        let style = CXPopupStyle.style(axisX: .center)
        style.width = .fixed(CXHUD.Style.medium.size.width)
        style.height = .fixed(CXHUD.Style.medium.size.height)
        style.maskBackgroundAlpha = 0.5
        style.maskBackgroundColor = .black
        style.backgroundColor = .darkGray
        style.shouldDismissOnBackgroundTap = false
        return style
    }
}

extension CXHUD.Style {
    var asActivityIndicatorStyle: UIActivityIndicatorView.Style {
        if #available(iOS 13, *) {
            return self == .medium ? .medium : .large
        }
        return self == .medium ? .white : .whiteLarge
    }
    
    var size: CGSize {
        switch self {
        case .medium:
            return CGSize(width: 120, height: 120)
        case .large:
            return CGSize(width: 180, height: 180)
        }
    }
}

extension UIActivityIndicatorView.Style {
    var asHUDStyle: CXHUD.Style {
        if #available(iOS 13, *) {
            if self == .medium || self == .gray || self == .white {
                return .medium
            } else {
                return .large
            }
        }
        return self == .whiteLarge ? .large : .medium
    }
}
