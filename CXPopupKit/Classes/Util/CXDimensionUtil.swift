import Foundation

class CXDimensionUtil {
    static let defaultHeight: CGFloat = 44

    static var keyWindowSafeAreInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
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
        let insets = CXDimensionUtil.keyWindowSafeAreInsets
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
