import UIKit

/// Control the way popup handle the safe area
public enum CXSafeAreaPolicy: Int {
    case system = 0 // Follow system default safe area behavior
    case auto   // Popup will ignore system safe area behavior and add the safe are inside the view
    case disable // Disable safe area
}

/// Represent edge of the size (width & height)
public enum CXEdge {
    case full // the edge will try to take the maximum value of the width / height
    case ratio(_ ratio: CGFloat) // the edge will try to take part of the screen width / height
    case fixed(_ value: CGFloat) // the edge will be a fix value
}

extension CXEdge {
    func value(_ length: CGFloat) -> CGFloat {
        switch self {
        case .full:
            return length
        case .ratio(let ratio):
            return ratio * length
        case .fixed(let value):
            return value
        }
    }
}

/// Includes some methods regarding coordinate and size calculation
protocol CXAxisLiteral {

    /// Calculate the offset for origin (rect.origin)
    /// - Parameters:
    ///   - edge: current edge length (width / height)
    ///   - screenEdge: length of the screen edge (width / height)
    ///   - insets: additional insets
    func offset(_ edge: CGFloat, _ screenEdge: CGFloat, _ insets: UIEdgeInsets) -> CGFloat
    
    /// Calculate the offset for custom
    /// - Parameters:
    ///   - value: current point axis value (x/y)
    ///   - edge: popup edge value (width / height)
    ///   - screenEdge: screen edge value (width / height)
    func calculateOffset(_ value: CGFloat, _ edge: CGFloat, _ screenEdge: CGFloat) -> CGFloat

    /// Update the padding between the content view and the popupController
    /// - Parameter insets: safe area insets
    func updateInsets(_ insets: UIEdgeInsets) -> UIEdgeInsets
}

extension CXAxisLiteral {
    func calculateOffset(_ value: CGFloat, _ edge: CGFloat, _ screenEdge: CGFloat) -> CGFloat {
        guard value + edge <= screenEdge else {
            return value - edge
        }
        return value
    }
}

public enum CXAxisX {
    case left, right, center, custom(x: CGFloat)
}

public enum CXAxisY {
    case top, bottom, center, custom(y: CGFloat)
}

extension CXAxisX: CXAxisLiteral {
    func offset(_ edge: CGFloat, _ screenEdge: CGFloat, _ insets: UIEdgeInsets) -> CGFloat {
        switch self {
        case .left:
            return insets.left
        case .right:
            return screenEdge - edge - insets.right
        case .center:
            return (screenEdge - edge) / 2.0
        case .custom(let x):
            return calculateOffset(x, edge, screenEdge)
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
    func offset(_ edge: CGFloat, _ screenEdge: CGFloat, _ insets: UIEdgeInsets) -> CGFloat {
        switch self {
        case .top:
            return insets.top
        case .bottom:
            return screenEdge - edge - insets.bottom
        case .center:
            return (screenEdge - edge) / 2.0
        case .custom(let y):
            return calculateOffset(y, edge, screenEdge)
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
        guard policy == .auto, CXLayoutUtil.keyWindowSafeAreInsets != .zero else {
            return .zero
        }
        let updatedInsets = x.updateInsets(CXLayoutUtil.keyWindowSafeAreInsets)
        return y.updateInsets(updatedInsets)
    }
}

