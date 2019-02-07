//
//  CGRect+Extension.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 2/8/19.
//

import Foundation

extension CGRect {
    func stretch(horizontal ratio: CGFloat) -> CGRect {
        return CGRect(origin: origin, size: CGSize(width: size.width * ratio, height: size.height))
    }

    func stretch(vertical ratio: CGFloat) -> CGRect {
        return CGRect(origin: origin, size: CGSize(width: size.width, height: size.height * ratio))
    }

    func offset(_ padding: CGFloat) -> CGRect {
        return CGRect(x: origin.x + padding / 2.0, y: origin.y + padding / 2.0, width: width - padding, height: height - padding)
    }

    func square() -> CGRect {
        let length = min(size.width, size.height)
        let x = (size.width - length) / 2.0 + origin.x
        let y = (size.height - length) / 2.0 + origin.y
        return CGRect(x: x, y: y, width: length, height: length)
    }

    var center: CGPoint {
        return CGPoint(x: size.width / 2.0 + origin.x, y: size.height / 2.0 + origin.y)
    }
}

extension UIEdgeInsets {
    init(_ edge: CGFloat) {
        self.init(top: edge, left: edge, bottom: edge, right: edge)
    }

    var horizontal: CGFloat {
        return self.left + self.right
    }

    var vertical: CGFloat {
        return self.top + self.bottom
    }
}

extension CGSize {
    var square: CGSize {
        let length = min(width, height)
        return CGSize(width: length, height: length)
    }
}
