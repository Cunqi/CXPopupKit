import Foundation

public enum CXEdge {
    case full
    case ratio(ratio: CGFloat)
    case fixed(value: CGFloat)

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
