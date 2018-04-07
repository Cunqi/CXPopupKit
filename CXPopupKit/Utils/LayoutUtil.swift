//
// Created by Cunqi Xiao on 12/20/17.
// Copyright (c) 2017 Cunqi Xiao. All rights reserved.
//

import Foundation
import SnapKit

class LayoutUtil {
    static func getEstimateHeight(for string: NSString, with width: CGFloat, and font: UIFont) -> CGFloat {
        return string.boundingRect(with: CGSize(width: Double(width), height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedStringKey.font: font],
                                   context: nil)
            .size.height
    }

    static func fill(view child: UIView, at parent: UIView) {
        parent.addSubview(child)
        child.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalTo(parent)
        }
    }
}
