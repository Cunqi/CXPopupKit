//
//  CXTappable.swift
//  CXPopupKit
//
//  Created by Cunqi on 2/16/19.
//

import UIKit

public typealias CXTappableHandler = (String) -> Void

class CXTappable: Equatable, Hashable {
    let text: String
    var handler: CXTappableHandler
    
    init(_ text: String, _ handler: @escaping CXTappableHandler) {
        self.text = text
        self.handler = handler
    }
    
    static func ==(lhs: CXTappable, rhs: CXTappable) -> Bool {
        return lhs.text == rhs.text
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}
