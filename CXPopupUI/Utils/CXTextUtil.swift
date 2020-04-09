class CXTextUtil {
    static func textSize(_ text: String, _ maximumSize: CGSize, _ font: UIFont) -> CGSize {
        let _text = text as NSString
        return _text.boundingRect(
            with: maximumSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil).size
    }
    
    static func textSize(_ attributedText: NSAttributedString, _ maximumSize: CGSize) -> CGSize {
        return attributedText.boundingRect(with: maximumSize,
                                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                                    context: nil)
            .size
    }
}
