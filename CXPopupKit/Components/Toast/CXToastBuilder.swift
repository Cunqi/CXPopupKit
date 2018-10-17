//
// Created by Cunqi on 2018-10-02.
// Copyright (c) 2018 Cunqi. All rights reserved.
//

import UIKit

public class CXToastBuilder {
    let toast: CXToast

    public init(message: String) {
        self.toast = CXToast(message: message)
    }

    public init(attributedMessage: NSAttributedString) {
        self.toast = CXToast(attributedMessage: attributedMessage)
    }

    public func withDuration(duration: CXToastDuration) -> Self {
        toast.toastDuration = duration
        return self
    }

    public func withToastLabelConfiguration(_ configuration: @escaping (UILabel) -> Void) -> Self {
        toast.toastLabelConfiguration = configuration
        return self
    }

    public func build() -> UIViewController {
        return CXPopupBuilder(content: self.toast, presenting: UIScreen.getMostTopViewController())
                .withViewDidAppear(toast.setupDelayDismiss)
                .withAppearance(toast.popupAppearance)
                .build()
    }
}

public enum CXToastDuration {
    case short
    case long
    case custom(duration: TimeInterval)

    var duration: TimeInterval {
        switch self {
        case .short:
            return 1.5
        case .long:
            return 3
        case .custom(let duration):
            return duration
        }
    }
}