import UIKit

public protocol CXAnimation: UIViewControllerAnimatedTransitioning {
}

public enum CXAnimationType {
    case basic, fade, bounce, zoom, pop
    case custom(_ animation: CXAnimation)
}

public struct CXAnimationDuration {
    let `in`: TimeInterval
    let out: TimeInterval

    public init(_ `in`: TimeInterval, _ out: TimeInterval) {
        self.in = `in`
        self.out = out
    }

    public init(_ roundTrip: TimeInterval) {
        self.in = roundTrip
        self.out = roundTrip
    }
}

public enum CXAnimationDirection: Int {
    case up = 1, left, center, right, down

    public var opposite: CXAnimationDirection {
        CXAnimationDirection(rawValue: 6 - self.rawValue)!
    }
}

public struct CXAnimationTransition {
    let `in`: CXAnimationDirection
    let out: CXAnimationDirection

    public init(_ `in`: CXAnimationDirection, _ out: CXAnimationDirection) {
        self.`in` = `in`
        self.out = out
    }
}

// Helper methods

extension CGRect {
    func offsetForInitialPosition(direction: CXAnimationDirection, offsetSize: CGSize) -> CGRect {
        let origin = direction.position(self.origin, offsetSize, true)
        return CGRect(origin: origin, size: self.size)
    }

    func offsetForFinalPosition(direction: CXAnimationDirection, offsetSize: CGSize) -> CGRect {
        let origin = direction.position(self.origin, offsetSize, false)
        return CGRect(origin: origin, size: self.size)
    }
}

extension CXAnimationDirection {
    func position(_ base: CGPoint, _ size: CGSize, _ isStart: Bool) -> CGPoint {
        switch self {
        case .up:
            return CGPoint(x: base.x, y: isStart ? base.y + size.height : base.y - size.height)
        case .down:
            return CGPoint(x: base.x, y: isStart ? base.y - size.height : base.y + size.height)
        case .center:
            return base
        case .left:
            return CGPoint(x: isStart ? base.x + size.width : base.x - size.width, y: base.y)
        case .right:
            return CGPoint(x: isStart ? base.x - size.width : base.x + size.width, y: base.y)
        }
    }
}
