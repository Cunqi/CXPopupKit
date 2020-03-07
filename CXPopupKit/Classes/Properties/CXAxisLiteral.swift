import UIKit

protocol CXAxisLiteral {
    func calculate(_ edge: CGFloat, _ screenEdge: CGFloat, _ insets: UIEdgeInsets) -> CGFloat
    func updateInsets(_ insets: UIEdgeInsets) -> UIEdgeInsets
}

public enum CXAxisX {
    case left, right, center, custom(x: CGFloat)
}

public enum CXAxisY {
    case top, bottom, center, custom(y: CGFloat)
}

extension CXAxisX: CXAxisLiteral {
    func calculate(_ edge: CGFloat, _ screenEdge: CGFloat, _ insets: UIEdgeInsets) -> CGFloat {
        switch self {
        case .left:
            return insets.left
        case .right:
            return screenEdge - edge - insets.right
        case .center:
            return (screenEdge - edge) / 2.0
        case .custom(let x):
            return x
        }
    }

    func updateInsets(_ insets: UIEdgeInsets) -> UIEdgeInsets {
        var updatedInsets = insets
        switch self {
            case .left:
                updatedInsets.right = 0
        case .right:
            updatedInsets.left = 0
        case .center, .custom:
            fallthrough
        @unknown default:
            updatedInsets.left = 0
            updatedInsets.right = 0
        }
        return insets
    }
}

extension CXAxisY: CXAxisLiteral {
    func calculate(_ edge: CGFloat, _ screenEdge: CGFloat, _ insets: UIEdgeInsets) -> CGFloat {
        switch self {
        case .top:
            return insets.top
        case .bottom:
            return screenEdge - edge - insets.bottom
        case .center:
            return (screenEdge - edge) / 2.0
        case .custom(let y):
            return y
        }
    }

    func updateInsets(_ insets: UIEdgeInsets) -> UIEdgeInsets {
        var updatedInsets = insets
        switch self {
        case .top:
            updatedInsets.bottom = 0
        case .bottom:
            updatedInsets.top = 0
        case .center, .custom:
            fallthrough
        @unknown default:
            updatedInsets.top = 0
            updatedInsets.bottom = 0
        }
        return updatedInsets
    }
}

public struct CXPosition {
    public static let center = CXPosition(.center, .center)
    let x: CXAxisX
    let y: CXAxisY
    
    public init(_ x : CXAxisX, _ y: CXAxisY) {
        self.x = x
        self.y = y
    }

    public init(_ x: CGFloat, _ y: CGFloat) {
        self.x = .custom(x: x)
        self.y = .custom(y: y)
    }

    func padding(_ policy: CXSafeAreaPolicy) -> UIEdgeInsets {
        guard policy == .auto, CXDimensionUtil.keyWindowSafeAreInsets != .zero else {
            return .zero
        }
        let updatedInsets = x.updateInsets(CXDimensionUtil.keyWindowSafeAreInsets)
        return y.updateInsets(updatedInsets)
    }
}
