import UIKit

class CXLayoutUtil {
    
    static var keyWindowSafeAreInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    /// Set auto layout constraints for a subview to make it fill full of the parent view
    /// - Parameters:
    ///   - content: subview
    ///   - parent: parent view
    ///   - insets: insets between subview's edge and parent view's edge
    static func setupFill(_ content: UIView, _ parent: UIView, _ insets: UIEdgeInsets) {
        parent.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left).isActive = true
        content.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.right).isActive = true
        content.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        content.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom).isActive = true
    }
    static func fill(_ content: UIView, _ parent: UIView?, _ insets: UIEdgeInsets = .zero) {
        guard let parent = parent else {
            return
        }
        setupFill(content, parent, insets)
    }

    static func rect(_ width: CXEdge,
                     _ height: CXEdge,
                     _ position: CXPosition,
                     _ policy: CXSafeAreaPolicy,
                     _ screen: CGSize) -> CGRect {
        let widthValue = width.value(screen.width)
        let heightValue = height.value(screen.height)
        let margin = safeAreaMargin(position, policy)
        let size = CGSize(
                width: widthValue + margin.left + margin.right,
                height: heightValue + margin.top + margin.bottom)
        return CGRect(origin: origin(position, size, screen, policy), size: size)
    }

    private static func safeAreaMargin(_ position: CXPosition, _ safeAreaType: CXSafeAreaPolicy) -> UIEdgeInsets {
        guard safeAreaType == .auto else {
            return .zero
        }
        let insets = CXLayoutUtil.keyWindowSafeAreInsets
        var result = UIEdgeInsets.zero

        switch position.x {
        case .left:
            result.left = insets.left
        case .right:
            result.right = insets.right
        case .center, .custom:
            fallthrough
        @unknown default:
            break
        }
        switch position.y {
        case .top:
            result.top = insets.top
        case .bottom:
            result.bottom = insets.bottom
        case .center, .custom:
            fallthrough
        @unknown default:
            break
        }
        
        return result
    }

    private static func origin(_ position: CXPosition, _ size: CGSize, _ screen: CGSize, _ policy: CXSafeAreaPolicy) -> CGPoint {
        let safeArea = policy == .system ? keyWindowSafeAreInsets : .zero
        return CGPoint(
                x: position.x.offset(size.width, screen.width, safeArea),
                y: position.y.offset(size.height, screen.height, safeArea))
    }
}
