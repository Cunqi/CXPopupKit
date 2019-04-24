//
//  CXBasePicker.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 4/24/19.
//

import UIKit

public class CXBasePicker<T: CustomStringConvertible>: UIView, CXDialog, CXPopupLifecycleDelegate {
    struct PickerAppearance {
        var font = UIFont.systemFont(ofSize: 13.0)
        var textAlignment = NSTextAlignment.natural
        var textColor = UIColor.black
        var backgroundColor: UIColor? = UIColor.white
        init(){}
    }

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

    var preferredHeight = UIScreen.main.bounds.height.quarter
    var popupAppearance: CXPopupAppearance
    var pickerAppearance = PickerAppearance()

    var handler: ((T) -> Void)?

    init(_ popupAppearance: CXPopupAppearance, _ handler: ((T) -> Void)?) {
        self.popupAppearance = popupAppearance
        self.handler = handler
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let size = CGSize(width: CXLayoutStyle.screen.size.width, height: preferredHeight)
        let layoutStyle = current.layoutStyle.update(size: size)
        submit(layoutStyle)
    }
}

extension CXBasePicker: CXPopupable {
    public func pop(on vc: UIViewController?) {
        CXPopupController(self, appearance: self.popupAppearance, self).pop(on: vc)
    }
}
