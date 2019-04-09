//
//  ProgressBarView.swift
//  CXPopupKit
//
//  Created by Cunqi Xiao on 2/8/19.
//

import UIKit

public protocol CXProgressBarUpdatable {
    func updateProgress(_ progress: CGFloat)
}

class CXProgressBarView: UIView, CXDialog, CXProgressBarUpdatable {
    var config: CXProgressConfig = CXProgressConfig()
    private(set) var progress: CGFloat = 0

    let backgroundLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()

    init() {
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup() // Auto layout style
    }

    func setup() {
        backgroundColor = config.backgroundColor
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }

    func updateProgress(_ progress: CGFloat) {
        self.progress = min(max(progress, 0), 1)
    }

    func reset() {
        updateProgress(0)
    }
}

class CXLineProgressBar: CXProgressBarView {
    override func setup() {
        super.setup()
        let rect = bounds.offset(config.lineProgressBarBorderWidth)
        backgroundLayer.fillColor = config.barBackgroundColor.cgColor
        backgroundLayer.strokeColor = config.barForegroundColor.cgColor
        backgroundLayer.lineWidth = config.lineProgressBarBorderWidth
        backgroundLayer.lineCap = CAShapeLayerLineCap.round
        backgroundLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: config.lineProgressBarCornerRadius).cgPath

        progressLayer.fillColor = config.barForegroundColor.cgColor
        updateProgress(progress)
    }

    override func updateProgress(_ progress: CGFloat) {
        super.updateProgress(progress)
        let rect = bounds.offset(config.lineProgressBarBorderWidth)
        let progressRect = rect.stretch(horizontal: progress)
        progressLayer.path = UIBezierPath(roundedRect: progressRect, cornerRadius: config.lineProgressBarCornerRadius).cgPath
    }
}

class CXCircleProgressBar: CXProgressBarView {
    private let startAngle: CGFloat = CGFloat(Double.pi / -2.0)
    private var scaleRatio: CGFloat = 0.08
    private var radius: CGFloat = 0
    private var barCenter: CGPoint = .zero
    
    override func setup() {
        super.setup()
        let square = bounds.square()
        let offset = square.size.width * scaleRatio
        let backgroundRect = square.offset(offset)
        radius = backgroundRect.size.width / 2.0
        barCenter = backgroundRect.center
        
        backgroundLayer.fillColor = config.barBackgroundColor.cgColor
        backgroundLayer.path = UIBezierPath(ovalIn: square).cgPath
        
        progressLayer.fillColor = config.barForegroundColor.cgColor
        updateProgress(progress)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        super.updateProgress(progress)
        let endAngle = startAngle + CGFloat(Double.pi) * 2 * progress
        let path = UIBezierPath(arcCenter: barCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: barCenter)
        progressLayer.path = path.cgPath
    }
}

class CXRingProgressBar: CXProgressBarView {
    private let startAngle: CGFloat = CGFloat(Double.pi / -2.0)
    private var scaleRatio: CGFloat = 0.08
    private var barCenter: CGPoint = .zero
    private var radius: CGFloat = 0
    
    override func setup() {
        super.setup()
        let square = bounds.square()
        let offset = square.size.width * scaleRatio
        let backgroundRect = square.offset(offset)
        let borderWidth = square.size.width - backgroundRect.size.width
        radius = backgroundRect.size.width / 2.0
        barCenter = backgroundRect.center
        
        backgroundLayer.strokeColor = config.barBackgroundColor.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.path = UIBezierPath(ovalIn: backgroundRect).cgPath
        backgroundLayer.lineCap = CAShapeLayerLineCap.round
        backgroundLayer.lineWidth = borderWidth
        
        progressLayer.strokeColor = config.barForegroundColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = borderWidth
        updateProgress(progress)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        super.updateProgress(progress)
        let endAngle = startAngle + CGFloat(Double.pi) * 2 * progress
        let path = UIBezierPath(arcCenter: barCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = path.cgPath
    }
}

class CXActivityIndicatorView: CXProgressBarView, CXPopupLifecycleDelegate {
    private let highSpeedThreshold: CGFloat = 0.8
    private let highSpeedInterval: CGFloat = 0.96 / 60
    private let lowSpeedInterval: CGFloat = 0.24 / 60
    private let baseAngle: CGFloat = CGFloat(Double.pi / -2.0)
    private var scaleRatio: CGFloat = 0.08
    private var barCenter: CGPoint = .zero
    private var radius: CGFloat = 0
    private var barSizeRatio: CGFloat = 0.12
    
    private var displayLink: CADisplayLink?
    
    
    override func setup() {
        super.setup()
        let square = bounds.square()
        let offset = square.size.width * scaleRatio
        let backgroundRect = square.offset(offset)
        let borderWidth = square.size.width - backgroundRect.size.width
        radius = backgroundRect.size.width / 2.0
        barCenter = backgroundRect.center
        
        backgroundLayer.strokeColor = config.barBackgroundColor.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.path = UIBezierPath(ovalIn: backgroundRect).cgPath
        backgroundLayer.lineCap = CAShapeLayerLineCap.round
        backgroundLayer.lineWidth = borderWidth
        
        progressLayer.strokeColor = config.barForegroundColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = borderWidth
        updateProgress(progress)
    }
    
    @objc private func executeAnimation() {
        var updatedProgress: CGFloat
        if progress >= highSpeedThreshold {
            updatedProgress = progress + lowSpeedInterval
        } else {
            updatedProgress = progress + highSpeedInterval
        }
        if updatedProgress >= 1 {
            updatedProgress = 0
        }
        updateProgress(updatedProgress)
    }
    
    override func updateProgress(_ progress: CGFloat) {
        super.updateProgress(progress)
        let startAngle = baseAngle + progress * CGFloat(Double.pi) * 2
        let endAngle = startAngle + CGFloat(Double.pi) * 2 * barSizeRatio
        let path = UIBezierPath(arcCenter: barCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = path.cgPath
    }
    
    func startAnimating() {
        if let link = displayLink, link.isPaused {
            link.isPaused = false
        } else {
            displayLink = CADisplayLink(target: self, selector: #selector(executeAnimation))
            displayLink?.add(to: RunLoop.current, forMode: .default)
            displayLink?.isPaused = false
        }
    }

    func viewDidDisappear() {
        displayLink?.isPaused = true
    }

    deinit {
        displayLink?.invalidate()
        print("Activity Indicator deinit")
    }
}
