//
//  CXBasePicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/24/19.
//

import UIKit

public protocol CXItemSelectable {
    associatedtype Item: CustomStringConvertible
    var handler: ((Item) -> Void)? { get set }
}

public class CXBasePicker: UIView, CXDialog, CXPopupLifecycleDelegate {
    struct PickerAppearance {
        var font = UIFont.systemFont(ofSize: 13.0)
        var textAlignment = NSTextAlignment.natural
        var textColor = UIColor.black
        var backgroundColor: UIColor? = UIColor.white
        init(){}
    }

    public static let bottomPopupAppearance: CXPopupAppearance = {
        var appearance = CXPopupAppearance()
        appearance.layoutStyle = .bottom(height: 240)
        appearance.animationStyle = .fade
        appearance.animationTransition = CXAnimationTransition(.up, .down)
        appearance.safeAreaStyle = .wrap
        return appearance
    }()

    @objc public dynamic var font: UIFont {
        get {return pickerAppearance.font }
        set {pickerAppearance.font = newValue }
    }

    @objc public dynamic var textColor: UIColor {
        get { return pickerAppearance.textColor }
        set { pickerAppearance.textColor = newValue }
    }

    @objc public dynamic var textAlignment: NSTextAlignment {
        get { return pickerAppearance.textAlignment }
        set { pickerAppearance.textAlignment = newValue }
    }

    @objc public dynamic override var backgroundColor: UIColor? {
        get { return pickerAppearance.backgroundColor }
        set { pickerAppearance.backgroundColor = newValue
              self.backgroundColor = newValue
              self.popupController?.popupContainer.backgroundColor = newValue }
    }

    public var title: String?
    public var leftAction: CXPopupNavigateAction?
    public var rightAction: CXPopupNavigateAction?

    var popupAppearance: CXPopupAppearance
    var pickerAppearance = PickerAppearance()

    init(_ title: String?, _ left: CXPopupNavigateAction?, _ right: CXPopupNavigateAction?, _ popupAppearance: CXPopupAppearance) {
        self.title = title
        self.leftAction = left
        self.rightAction = right
        self.popupAppearance = popupAppearance
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK - CXNavigateable
    public func tapLeftBarButtonItem(_ action: CXPopupNavigateAction) {
        didTapAction(action)
    }

    public func tapRightBarButtonItem(_ action: CXPopupNavigateAction) {
        didTapAction(action)
    }

    private func didTapAction(_ action: CXPopupNavigateAction) {
        switch action {
        case .cancel:
            self.popupController?.dismiss()
        case .action:
            self.popupController?.commit()
        }
    }

    // MARK - Subclasses should implement these two methods
    func layout() {
        fatalError("layout has not been implemented")
    }

    func dismiss(for type: CXDismissType) {
        fatalError("dismiss(for:) has not been implemented")
    }

    // MARK - CXPopupLifecycleDelegate
    public func viewDidLoad() {
        layout()
    }

    public func viewDidDisappear(_ dismissType: CXDismissType) {
        dismiss(for: dismissType)
    }

    public func finalizeLayoutStyleBeforeInstallConstraints(_ current: CXPopupAppearance, _ submit: (CXLayoutStyle) -> Void) {
        submit(current.layoutStyle)
    }
}

extension CXBasePicker: CXPopupable {
    public func pop(on vc: UIViewController?) {
        CXNavigatePopupController(content: self,
                                  title: title,
                                  left: leftAction,
                                  right: rightAction,
                                  appearance: popupAppearance,
                                  delegate: self)
            .pop(on: vc)
    }
}
