//
//  LabelLayoutBuilder.swift
//  CXPopupKit
//
//  Created by Cunqi on 2/16/19.
//

import UIKit

class LabelLayoutBuilder {
    private let text: String
    private var font = UIFont.systemFont(ofSize: 13.0)
    private var textAlignment: NSTextAlignment = .center
    private var numberOfLines = 0
    private var textColor: UIColor?
    private var backgroundColor: UIColor?
    private var lineBreakMode: NSLineBreakMode = .byWordWrapping
    private var insets: UIEdgeInsets = .zero
    private var estimateWidth: CGFloat = 0
    
    init(_ text: String){
        self.text = text
        estimateWidth = UIScreen.main.bounds.size.width
    }
    
    func withTextAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    func withNumberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    func withLineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }
    
    func withTextColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    func withBackgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    func withFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func withInsets(_ insets: UIEdgeInsets) -> Self {
        self.insets = insets
        return self
    }
    
    func withEstimateWidth(_ width: CGFloat) -> Self {
        self.estimateWidth = estimateWidth
        return self
    }
    
    func build() -> LabelLayout {
        let label = createLabel()
        let finalSize = calculateSize()
        let layout = UIView()
        layout.backgroundColor = backgroundColor
        CXLayoutUtil.fill(label, at: layout, insets: insets)
        return (label, layout, finalSize)
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.textColor = textColor
        label.backgroundColor = .clear
        return label
    }
    
    private func calculateSize() -> CGSize {
        let estimateSize = CGSize(width: estimateWidth, height: CGFloat(Double.greatestFiniteMagnitude))
        let calculatedSize = CXTextUtil.getTextSize(for: text, with: estimateSize, font: font)
        let finalSize = CGSize(width: ceil(calculatedSize.width) + insets.horizontal, height: ceil(calculatedSize.height) + insets.vertical)
        return finalSize
    }
}
