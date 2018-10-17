//
//  CXColorStyle.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 10/8/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import Foundation

extension UIColor {
    static func colorFromHex(_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

enum CXColorStyle {
    static let important = UIColor.colorFromHex("#333333")
    static let normal = UIColor.colorFromHex("#666666")
    static let secondary = UIColor.colorFromHex("#999999")
    static let divider = UIColor.colorFromHex("#e6e6e6")
    static let placeHolder = UIColor.colorFromHex("#dadada")
    static let background = UIColor.colorFromHex("#f9f9f9")
}
