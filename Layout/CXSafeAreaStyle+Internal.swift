//
//  CXSafeAreaStyle+Internal.swift
//  CXLayoutKit
//
//  Created by Cunqi Xiao on 4/8/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import UIKit

extension CXSafeAreaStyle {
    static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }

    func insets(_ layoutStyle: CXLayoutStyle) -> UIEdgeInsets {
        switch self {
        case .off:
            return .zero
        case .on, .wrap:
            return layoutStyle.safeAreaInsets()
        }
    }
}
