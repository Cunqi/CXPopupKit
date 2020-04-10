//
//  CXViewControllerUtils.swift
//  CXPopupKit
//
//  Created by Cunqi on 4/9/20.
//

import UIKit

class CXViewControllerUtils {
    static func getTopMostViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    }
}
