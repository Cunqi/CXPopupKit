import UIKit
import CXPopupKit
import SnapKit

public class CXHUD {
    
    public enum Style {
        case medium
        case large
    }
    
    var hudInstance: CXHUDViewController
    
    var hudTintColor: UIColor = .black
    var hudStyle: CXHUD.Style = .large
    var hudTextFont: UIFont = .systemFont(ofSize: 15.0, weight: .medium)
    
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
    
    public static var hudTextFont: UIFont {
        get {
            CXHUD.shared.hudTextFont
        }
        set {
            CXHUD.shared.hudTextFont = newValue
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
        
        func applyHUDStyle(to popupStyle: CXPopupStyle) -> CXPopupStyle {
            CXHUD.shared.hudInstance.setupForLoading(text)
            popupStyle.width = .fixed(CXHUD.shared.hudStyle.size.width)
            popupStyle.height = .fixed(CXHUD.shared.hudStyle.size.height)
            return popupStyle
        }
        
        let popup = CXPopupController(
            presentingVC,
            CXHUD.shared.hudInstance,
            applyHUDStyle(to: CXHUD.shared.popupStyle),
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
    let stackView = UIStackView()
    var activityIndicatorView: UIActivityIndicatorView!
    var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
    }
    
    func setupForLoading(_ loadingText: String?) {
        activityIndicatorView = UIActivityIndicatorView(style: CXHUD.shared.hudStyle.asActivityIndicatorStyle)
        activityIndicatorView.color = CXHUD.shared.hudTintColor
        stackView.addArrangedSubview(activityIndicatorView.embed(.zero))
        
        guard let text = loadingText else {
            return
        }
        let label = UILabel()
        label.text = text
        label.textColor = CXHUD.shared.hudTintColor
        label.font = CXHUD.shared.hudTextFont
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        let labelHeight = CXTextUtil.textSize(
            text,
            CGSize(width: CXHUD.shared.hudStyle.size.width, height: CGFloat.greatestFiniteMagnitude),
            CXHUD.shared.hudTextFont).height
        
        self.label = label
        let labelWrapper = label.embed(UIEdgeInsets(top: 0, left: 0, bottom: .spacing4, right: 0))
        
        labelWrapper.translatesAutoresizingMaskIntoConstraints = false
        labelWrapper.snp.makeConstraints { (maker) in
            maker.height.equalTo(labelHeight + .spacing4)
        }
        
        stackView.addArrangedSubview(labelWrapper)
    }
    
    private func setupLayouts() {
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
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
            return CGSize(width: 150, height: 150)
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
