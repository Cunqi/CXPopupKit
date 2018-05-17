//
// Created by Cunqi Xiao on 5/16/18.
// Copyright (c) 2018 Cunqi Xiao. All rights reserved.
//

import UIKit

public class CXAbstractPopupWindow: UIViewController {
    override public var shouldAutorotate: Bool {
        return appearance.orientation.isAutoRotationEnabled
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return appearance.orientation.supportedInterfaceOrientations
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return appearance.orientation.preferredInterfaceOrientationForPresentation
    }

    var appearance: CXPopupAppearance = CXPopupAppearance.createAppearance()
    let popupable: CXPopupable

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        popupable.popupWindowDidLoad()
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popupable.popupWindowDidDisappear()
    }

    init(with popupable: CXPopupable, appearance: CXPopupAppearance) {
        self.popupable = popupable
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
    }

    private func setup() {
        view.backgroundColor = appearance.uiStyle.popupBackgroundColor ?? (popupable as? UIView)?.backgroundColor
        LayoutUtil.fill(view: (popupable as! UIView), at: view)
    }
}
