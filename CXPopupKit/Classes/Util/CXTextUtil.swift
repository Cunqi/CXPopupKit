//
//  CXTextUtil.swift
//  CXPopupKit
//
//  Created by Cunqi on 9/18/18.
//  Copyright © 2018 Cunqi. All rights reserved.
//

import UIKit

class CXTextUtil {
    static func getTextSize(for text: String, with estimateSize: CGSize, font: UIFont) -> CGSize {
        let _text = text as NSString
        return _text.boundingRect(with: estimateSize,
                                  options: [.usesLineFragmentOrigin, .usesFontLeading],
                                  attributes: [.font: font],
                                  context: nil)
            .size
    }
    
    static func getTextSize(for attributedText: NSAttributedString, with estimateSize: CGSize) -> CGSize {
        return attributedText.boundingRect(with: estimateSize,
                                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                    context: nil)
            .size
    }
}
