//
// Created by Cunqi Xiao on 12/20/17.
// Copyright (c) 2017 Cunqi Xiao. All rights reserved.
//

import UIKit

public final class PopupWindow: UIViewController {

    public override var shouldAutorotate: Bool {
        return appearance.orientation.isAutoRotationEnabled
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return appearance.orientation.supportedInterfaceOrientations
    }

    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return appearance.orientation.preferredInterfaceOrientationForPresentation
    }

    var viewDidLoadAction: CXPopupLifeCycleAction?
    var viewDidDisappearAction: CXPopupLifeCycleAction?
    var negativeAction: CXPopupHandler?
    var positiveAction: CXPopupHandler?
    var appearance: CXAppearance!
    var content: UIView!

    // Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewDidLoadAction?()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearAction?()
    }

    deinit {
        print("POPUP DEINIT")
    }

    private func setup() {
        let window = appearance.window
        view.backgroundColor = window.backgroundColor

        let strategy = getLayoutStrategy()
        strategy.install(content ?? UIView(), into: view, basedOn: appearance)
    }

    @objc private func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
}
