import UIKit
import CXPopupKit
import SnapKit

public class CXHUD {
    
    public enum Style {
        case systemDefault
    }
    
    static let size = CGSize(width: 150, height: 150)
    
    var hudInstance: CXHUDViewController?
    
    var hudTintColor: UIColor = .black
    var hudStyle: CXHUD.Style = .systemDefault
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
        popupStyle = CXPopupStyle.styleForHUD()
    }
    
    /// Dismiss current HUD from the top most view
    /// - Parameters:
    ///   - delay: time delay for dismissing the HUD
    ///   - completion: completion after dismissed
    public static func dismissHUD(after delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            CXHUD.shared.hudInstance?.dismiss(animated: true) {
                CXHUD.shared.hudInstance = nil
            }
        }
    }
    
    public static func dismissHUD() {
        dismissHUD(after: 0)
    }
    
    public static func showLoading(with text: String?) {
        guard let presentingVC = CXViewControllerUtils.getTopMostViewController() else {
            return
        }
        
        let instance = CXHUDViewController()
        func applyHUDStyle(to popupStyle: CXPopupStyle) -> CXPopupStyle {
            instance.setupForLoading(text)
            return popupStyle
        }
        
        let popup = CXPopupController(
            presentingVC,
            instance,
            applyHUDStyle(to: CXHUD.shared.popupStyle),
            dismissalCompletionBlock: nil)
        
        presentingVC.present(popup, animated: true)
        CXHUD.shared.hudInstance = instance
    }
}

class CXHUDViewController: UIViewController, CXPopupControlDelegate {
    let stackView = UIStackView()
    var activityIndicatorView: UIActivityIndicatorView!
    var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
    }
    
    func setupForLoading(_ loadingText: String?) {
        switch CXHUD.hudStyle {
        case .systemDefault:
            activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
                activityIndicatorView.color = CXHUD.shared.hudTintColor
                stackView.addArrangedSubview(activityIndicatorView.embed(.zero))
        }
        
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
            CGSize(width: CXHUD.size.width, height: CGFloat.greatestFiniteMagnitude),
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
        style.width = .fixed(CXHUD.size.width)
        style.height = .fixed(CXHUD.size.height)
        style.maskBackgroundAlpha = 0.5
        style.maskBackgroundColor = .black
        style.backgroundColor = .darkGray
        style.shouldDismissOnBackgroundTap = false
        style.cornerRadius = 16
        return style
    }
}
