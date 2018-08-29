//
//  UIScreenUtil.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 8/29/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

extension UIScreen {
    static func getMostTopViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }

    static func getCustomY(for percentage: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.size.height * (1.0 - percentage)
    }
}
